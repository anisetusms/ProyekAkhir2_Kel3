import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/booking/booking_repository.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/booking/BookingSuccessScreen.dart';
import 'package:front/core/network/api_client.dart';
import 'package:front/features/property/data/models/property_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PropertyBookingScreen extends StatefulWidget {
  final int propertyId;
  final PropertyModel? property;

  const PropertyBookingScreen({
    Key? key,
    required this.propertyId,
    this.property,
  }) : super(key: key);

  @override
  State<PropertyBookingScreen> createState() => _PropertyBookingScreenState();
}

class _PropertyBookingScreenState extends State<PropertyBookingScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  late TabController _tabController;
  
  // Repository
  late BookingRepository _bookingRepository;
  
  // State variables
  bool _isLoading = false;
  bool _isLoadingProperty = true;
  bool _isCheckingAvailability = false;
  String? _errorMessage;
  int _currentStep = 0;
  bool _termsAccepted = false;
  bool _isAvailable = false;
  bool _hasCheckedAvailability = false;
  
  // Form controllers
  final TextEditingController _guestNameController = TextEditingController();
  final TextEditingController _guestPhoneController = TextEditingController();
  final TextEditingController _ktpController = TextEditingController();
  final TextEditingController _specialRequestsController = TextEditingController();
  
  // Booking details
  late DateTime _checkInDate;
  late DateTime _checkOutDate;
  bool _isForOthers = false;
  File? _ktpImage;
  PropertyModel? _property;
  int _selectedMonths = 1; // For kost properties
  
  // Animation
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  // Property type helpers
  bool get _isKost => _property?.propertyTypeId == 1;
  bool get _isHomestay => _property?.propertyTypeId == 2;

  @override
  void initState() {
    super.initState();
    _bookingRepository = BookingRepository(apiClient: ApiClient());
    
    // Set initial dates
    final now = DateTime.now();
    _checkInDate = DateTime(now.year, now.month, now.day);
    _checkOutDate = DateTime(now.year, now.month, now.day + 1); // Default 1 day
    
    // Setup animation
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    
    _animationController.forward();
    
    // Setup tab controller
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentStep = _tabController.index;
      });
    });
    
    // Load property details
    if (widget.property != null) {
      _property = widget.property;
      _isLoadingProperty = false;
      _updateDatesBasedOnPropertyType();
    } else {
      _fetchPropertyDetails();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabController.dispose();
    _animationController.dispose();
    _guestNameController.dispose();
    _guestPhoneController.dispose();
    _ktpController.dispose();
    _specialRequestsController.dispose();
    super.dispose();
  }

  void _updateDatesBasedOnPropertyType() {
    if (_property != null) {
      if (_isKost) {
        // For kost: Set checkout to selected months later
        _checkOutDate = DateTime(
          _checkInDate.year,
          _checkInDate.month + _selectedMonths,
          _checkInDate.day,
        );
      } else {
        // For homestay: Keep current dates or set to 1 day if invalid
        if (_checkOutDate.isBefore(_checkInDate.add(const Duration(days: 1)))) {
          _checkOutDate = _checkInDate.add(const Duration(days: 1));
        }
      }
    }
  }

  Future<void> _fetchPropertyDetails() async {
    setState(() {
      _isLoadingProperty = true;
      _errorMessage = null;
    });
    
    try {
      final property = await _bookingRepository.getPropertyDetails(widget.propertyId);
      setState(() {
        _property = property;
        _isLoadingProperty = false;
        _updateDatesBasedOnPropertyType();
      });
    } catch (e) {
      setState(() {
        _isLoadingProperty = false;
        _errorMessage = 'Gagal memuat detail properti: $e';
      });
    }
  }

  // Calculate duration based on property type
  int _calculateDuration() {
    if (_isKost) {
      return _selectedMonths;
    } else {
      return _checkOutDate.difference(_checkInDate).inDays;
    }
  }

  // Calculate total price
  double _calculateTotalPrice() {
    if (_property == null) return 0.0;
    
    if (_isKost) {
      return _property!.price * _selectedMonths;
    } else {
      final days = _checkOutDate.difference(_checkInDate).inDays;
      return _property!.price * days;
    }
  }

  // Check availability
  Future<void> _checkAvailability() async {
    setState(() {
      _isCheckingAvailability = true;
      _errorMessage = null;
    });

    try {
      debugPrint('Checking availability for property ${widget.propertyId}');
      debugPrint('Check-in: ${DateFormat('yyyy-MM-dd').format(_checkInDate)}');
      debugPrint('Check-out: ${DateFormat('yyyy-MM-dd').format(_checkOutDate)}');
      
      final response = await _bookingRepository.checkAvailability(
        widget.propertyId,
        _checkInDate,
        _checkOutDate,
      );

      setState(() {
        _isCheckingAvailability = false;
        _hasCheckedAvailability = true;
        _isAvailable = response['is_available'] ?? false;
      });

      if (!_isAvailable) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Properti tidak tersedia untuk ${_isKost ? 'periode' : 'tanggal'} yang dipilih'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isCheckingAvailability = false;
        _hasCheckedAvailability = true;
        _isAvailable = false;
        _errorMessage = 'Gagal memeriksa ketersediaan: $e';
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  // Select date
  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    if (_isKost && !isCheckIn) {
      // For kost, checkout date is automatically calculated
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Untuk kost, tanggal berakhir otomatis dihitung berdasarkan durasi sewa'),
          backgroundColor: Colors.blue,
        ),
      );
      return;
    }

    final DateTime today = DateTime.now();
    
    final picked = await showDatePicker(
      context: context,
      initialDate: isCheckIn ? _checkInDate : _checkOutDate,
      firstDate: isCheckIn ? today : _checkInDate.add(const Duration(days: 1)),
      lastDate: DateTime(today.year + 2),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color(0xFF2E7D32),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          _checkInDate = DateTime(picked.year, picked.month, picked.day);
          _updateDatesBasedOnPropertyType();
        } else {
          _checkOutDate = DateTime(picked.year, picked.month, picked.day);
        }
        
        // Reset availability check when dates change
        _hasCheckedAvailability = false;
        _isAvailable = false;
      });
      
      HapticFeedback.selectionClick();
    }
  }

  // Pick KTP image
  Future<void> _pickKTPImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (pickedFile != null) {
      setState(() {
        _ktpImage = File(pickedFile.path);
      });
      
      HapticFeedback.mediumImpact();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('KTP berhasil diunggah'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // Navigate to next step
  void _nextStep() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
      _tabController.animateTo(_currentStep);
    }
  }

  // Navigate to previous step
  void _prevStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _tabController.animateTo(_currentStep);
    }
  }

  // Check login status
  Future<bool> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token != null && token.isNotEmpty;
  }

  // Show login required dialog
  void _showLoginRequiredDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Diperlukan'),
        content: const Text('Anda perlu login untuk melakukan booking. Apakah Anda ingin login sekarang?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Nanti'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
            ),
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }

  // Submit booking
  Future<void> _submitBooking() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_ktpImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap unggah foto KTP'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap setujui syarat dan ketentuan'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    final canProceed = await _checkLoginStatus();
    if (!canProceed) {
      _showLoginRequiredDialog();
      return;
    }
    
    if (!_isAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Properti tidak tersedia untuk ${_isKost ? 'periode' : 'tanggal'} yang dipilih'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final booking = await _bookingRepository.createBooking(
        propertyId: widget.propertyId,
        roomIds: null, // No specific rooms for property booking
        checkIn: _checkInDate,
        checkOut: _checkOutDate,
        isForOthers: _isForOthers,
        guestName: _isForOthers ? _guestNameController.text : null,
        guestPhone: _isForOthers ? _guestPhoneController.text : null,
        ktpImage: _ktpImage!,
        identityNumber: _ktpController.text,
        specialRequests: _specialRequestsController.text.isNotEmpty 
            ? _specialRequestsController.text 
            : null,
      );
      
      HapticFeedback.heavyImpact();
      
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => BookingSuccessScreen(booking: booking),
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
      
      HapticFeedback.vibrate();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal membuat booking: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingProperty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Booking Properti'),
          backgroundColor: const Color(0xFF2E7D32),
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Memuat informasi properti...'),
            ],
          ),
        ),
      );
    }

    if (_property == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Booking Properti'),
          backgroundColor: const Color(0xFF2E7D32),
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 50),
              const SizedBox(height: 16),
              Text(_errorMessage ?? 'Properti tidak ditemukan'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _fetchPropertyDetails,
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    final duration = _calculateDuration();
    final totalPrice = _calculateTotalPrice();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking ${_isKost ? 'Kost' : 'Homestay'}'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading 
          ? _buildLoadingState()
          : FadeTransition(
              opacity: _fadeAnimation,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Progress indicator
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      color: const Color(0xFF2E7D32),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              for (int i = 0; i < 3; i++)
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 4),
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: i <= _currentStep 
                                          ? Colors.white 
                                          : Colors.white.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _currentStep == 0 
                                    ? 'Detail Pemesanan' 
                                    : _currentStep == 1 
                                        ? 'Informasi Pemesan' 
                                        : 'Konfirmasi',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Langkah ${_currentStep + 1}/3',
                                style: const TextStyle(
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // Property summary
                    _buildPropertySummary(),
                    
                    // Error message if any
                    if (_errorMessage != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Error:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _errorMessage!,
                              style: TextStyle(color: Colors.red[800]),
                            ),
                          ],
                        ),
                      ),
                    
                    // Tab content
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _buildBookingDetailsTab(duration, totalPrice),
                          _buildGuestInformationTab(),
                          _buildConfirmationTab(duration, totalPrice),
                        ],
                      ),
                    ),
                    
                    // Navigation buttons
                    _buildNavigationButtons(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF2E7D32),
            Color(0xFF4CAF50),
          ],
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            SizedBox(height: 24),
            Text(
              'Memproses Booking...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Mohon tunggu sebentar',
              style: TextStyle(
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertySummary() {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              _property!.image ?? 'https://via.placeholder.com/80x80?text=No+Image',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 80,
                height: 80,
                color: Colors.grey[300],
                child: const Icon(Icons.image_not_supported),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _property!.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        _property!.address,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: _isKost ? Colors.blue[100] : Colors.amber[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _isKost ? 'Kost' : 'Homestay',
                        style: TextStyle(
                          fontSize: 10,
                          color: _isKost ? Colors.blue[900] : Colors.amber[900],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${currencyFormat.format(_property!.price)} / ${_isKost ? 'bulan' : 'malam'}',
                      style: const TextStyle(
                        color: Color(0xFF2E7D32),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingDetailsTab(int duration, double totalPrice) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date selection card
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E7D32).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.calendar_today,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _isKost ? 'Periode Sewa' : 'Tanggal Menginap',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Property type info
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.blue.shade700,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _isKost
                                ? 'Untuk kost, durasi sewa dihitung per bulan'
                                : 'Untuk homestay, durasi sewa dihitung per hari',
                            style: TextStyle(
                              color: Colors.blue.shade700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Date fields
                  Row(
                    children: [
                      Expanded(
                        child: _buildDateField(
                          label: _isKost ? 'Mulai Sewa' : 'Check-in',
                          date: _checkInDate,
                          onTap: () => _selectDate(context, true),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildDateField(
                          label: _isKost ? 'Berakhir' : 'Check-out',
                          date: _checkOutDate,
                          onTap: () => _selectDate(context, false),
                          isDisabled: _isKost,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Duration selector for kost
                  if (_isKost) _buildMonthSelector(),
                  
                  const SizedBox(height: 16),
                  
                  // Duration and price summary
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Durasi ${_isKost ? 'Sewa' : 'Menginap'}:'),
                            Text(
                              _isKost 
                                  ? '$duration bulan' 
                                  : '$duration hari',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E7D32),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total Harga:'),
                            Text(
                              NumberFormat.currency(
                                locale: 'id_ID',
                                symbol: 'Rp',
                                decimalDigits: 0,
                              ).format(totalPrice),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E7D32),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Availability check
          _buildAvailabilitySection(),
        ],
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime date,
    required VoidCallback onTap,
    bool isDisabled = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: isDisabled ? null : onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(
                color: isDisabled ? Colors.grey.shade200 : Colors.grey.shade300,
              ),
              borderRadius: BorderRadius.circular(8),
              color: isDisabled ? Colors.grey.shade100 : null,
            ),
            child: Row(
              children: [
                Icon(
                  isDisabled ? Icons.lock : Icons.calendar_today,
                  size: 16,
                  color: isDisabled ? Colors.grey : const Color(0xFF2E7D32),
                ),
                const SizedBox(width: 8),
                Text(
                  DateFormat('dd MMM yyyy').format(date),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDisabled ? Colors.grey : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMonthSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Durasi Sewa (Bulan):',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(12, (index) {
            final month = index + 1;
            return ChoiceChip(
              label: Text('$month'),
              selected: _selectedMonths == month,
              selectedColor: const Color(0xFF2E7D32),
              labelStyle: TextStyle(
                color: _selectedMonths == month ? Colors.white : Colors.black,
              ),
              onSelected: (selected) {
                setState(() {
                  _selectedMonths = month;
                  _checkOutDate = DateTime(
                    _checkInDate.year,
                    _checkInDate.month + month,
                    _checkInDate.day,
                  );
                  
                  // Reset availability check
                  _hasCheckedAvailability = false;
                  _isAvailable = false;
                });
                HapticFeedback.selectionClick();
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildAvailabilitySection() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ketersediaan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            if (_hasCheckedAvailability && _isAvailable)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Properti tersedia untuk periode yang dipilih',
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ],
                ),
              )
            else if (_hasCheckedAvailability && !_isAvailable)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.error, color: Colors.red),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Properti tidak tersedia untuk periode yang dipilih',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              )
            else
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isCheckingAvailability ? null : _checkAvailability,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: _isCheckingAvailability
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Cek Ketersediaan'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestInformationTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Guest information card
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E7D32).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.person_outline,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Informasi Pemesan',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Booking untuk orang lain'),
                    subtitle: const Text('Aktifkan jika Anda memesan untuk orang lain'),
                    value: _isForOthers,
                    activeColor: const Color(0xFF2E7D32),
                    onChanged: (value) => setState(() => _isForOthers = value),
                  ),
                  if (_isForOthers) ...[
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _guestNameController,
                      decoration: InputDecoration(
                        labelText: 'Nama Tamu',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.person),
                        floatingLabelStyle: const TextStyle(color: Color(0xFF2E7D32)),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF2E7D32)),
                        ),
                      ),
                      validator: (value) {
                        if (_isForOthers && (value == null || value.isEmpty)) {
                          return 'Harap masukkan nama tamu';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _guestPhoneController,
                      decoration: InputDecoration(
                        labelText: 'Nomor Telepon Tamu',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.phone),
                        floatingLabelStyle: const TextStyle(color: Color(0xFF2E7D32)),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF2E7D32)),
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (_isForOthers && (value == null || value.isEmpty)) {
                          return 'Harap masukkan nomor telepon tamu';
                        }
                        return null;
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Identity card
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.credit_card,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Identitas',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _ktpController,
                    decoration: InputDecoration(
                      labelText: 'Nomor KTP',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.credit_card),
                      floatingLabelStyle: const TextStyle(color: Color(0xFF2E7D32)),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF2E7D32)),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(16),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Harap masukkan nomor KTP';
                      }
                      if (value.length != 16) {
                        return 'Nomor KTP harus 16 digit';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: _pickKTPImage,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _ktpImage == null 
                              ? Colors.grey.shade300 
                              : const Color(0xFF2E7D32),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            _ktpImage == null 
                                ? Icons.upload_file 
                                : Icons.check_circle,
                            size: 48,
                            color: _ktpImage == null ? Colors.grey : const Color(0xFF2E7D32),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _ktpImage == null 
                                ? 'Unggah Foto KTP (Wajib)' 
                                : 'KTP berhasil diunggah',
                            style: TextStyle(
                              color: _ktpImage == null ? Colors.grey : const Color(0xFF2E7D32),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (_ktpImage == null) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Klik untuk memilih file',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                          if (_ktpImage != null) ...[
                            const SizedBox(height: 16),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                _ktpImage!,
                                height: 120,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextButton.icon(
                              onPressed: _pickKTPImage,
                              icon: const Icon(Icons.refresh, size: 16),
                              label: const Text('Ganti Foto'),
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFF2E7D32),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Special requests card
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.message_outlined,
                          color: Colors.purple,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Permintaan Khusus',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _specialRequestsController,
                    decoration: InputDecoration(
                      hintText: 'Masukkan permintaan khusus Anda (opsional)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      floatingLabelStyle: const TextStyle(color: Color(0xFF2E7D32)),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF2E7D32)),
                      ),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationTab(int duration, double totalPrice) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Booking summary
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ringkasan Booking',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildConfirmationItem(
                    'Properti',
                    _property!.name,
                    Icons.home_outlined,
                  ),
                  const Divider(),
                  _buildConfirmationItem(
                    'Tipe Properti',
                    _isKost ? 'Kost' : 'Homestay',
                    _isKost ? Icons.house : Icons.villa,
                  ),
                  const Divider(),
                  _buildConfirmationItem(
                    _isKost ? 'Mulai Sewa' : 'Check-in',
                    DateFormat('dd MMM yyyy').format(_checkInDate),
                    Icons.calendar_today,
                  ),
                  const Divider(),
                  _buildConfirmationItem(
                    _isKost ? 'Berakhir' : 'Check-out',
                    DateFormat('dd MMM yyyy').format(_checkOutDate),
                    Icons.calendar_today,
                  ),
                  const Divider(),
                  _buildConfirmationItem(
                    'Durasi',
                    _isKost ? '$duration bulan' : '$duration hari',
                    Icons.timelapse,
                  ),
                  if (_isForOthers) ...[
                    const Divider(),
                    _buildConfirmationItem(
                      'Tamu',
                      _guestNameController.text,
                      Icons.person,
                    ),
                    const Divider(),
                    _buildConfirmationItem(
                      'Telepon Tamu',
                      _guestPhoneController.text,
                      Icons.phone,
                    ),
                  ],
                  const Divider(),
                  _buildConfirmationItem(
                    'Nomor KTP',
                    _ktpController.text.isEmpty 
                        ? 'Belum diisi' 
                        : _ktpController.text,
                    Icons.credit_card,
                  ),
                  if (_specialRequestsController.text.isNotEmpty) ...[
                    const Divider(),
                    _buildConfirmationItem(
                      'Permintaan Khusus',
                      _specialRequestsController.text,
                      Icons.message,
                    ),
                  ],
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Pembayaran',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        currencyFormat.format(totalPrice),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${currencyFormat.format(_property!.price)} × $duration ${_isKost ? 'bulan' : 'hari'}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Terms and conditions
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _termsAccepted,
                        onChanged: (value) {
                          setState(() {
                            _termsAccepted = value ?? false;
                          });
                        },
                        activeColor: const Color(0xFF2E7D32),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _termsAccepted = !_termsAccepted;
                            });
                          },
                          child: const Text(
                            'Saya menyetujui syarat dan ketentuan yang berlaku',
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 48),
                    child: TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Syarat dan Ketentuan'),
                            content: const SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('1. Pembatalan booking dikenakan biaya sesuai ketentuan'),
                                  SizedBox(height: 8),
                                  Text('2. Identitas yang diberikan harus valid dan dapat diverifikasi'),
                                  SizedBox(height: 8),
                                  Text('3. Penyewa wajib mematuhi peraturan yang berlaku di properti'),
                                  SizedBox(height: 8),
                                  Text('4. Pembayaran harus dilakukan sesuai dengan ketentuan yang berlaku'),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Tutup'),
                              ),
                            ],
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Lihat Syarat dan Ketentuan',
                        style: TextStyle(
                          color: Color(0xFF2E7D32),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationItem(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _prevStep,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Color(0xFF2E7D32)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Kembali'),
              ),
            ),
          if (_currentStep > 0)
            const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _isCheckingAvailability 
                  ? null 
                  : (_currentStep < 2 ? _nextStep : _submitBooking),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: _isCheckingAvailability
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      _currentStep < 2 ? 'Lanjutkan' : 'Buat Booking',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
