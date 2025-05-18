import 'package:flutter/material.dart';
import 'package:front/core/network/api_client.dart';
import 'package:front/core/utils/constants.dart';
import 'package:front/core/utils/format_utils.dart';
import 'package:front/core/widgets/error_state.dart';
import 'package:front/core/widgets/loading_indicator.dart';
import 'package:front/features/dashboard/presentation/screens/users/button_navbar.dart';
import 'package:front/features/dashboard/presentation/screens/users/owner/bookings/booking_detail_screen.dart';
import 'package:intl/intl.dart';

class AdminBookingListScreen extends StatefulWidget {
  static const routeName = '/admin/bookings';

  const AdminBookingListScreen({Key? key}) : super(key: key);

  @override
  _AdminBookingListScreenState createState() => _AdminBookingListScreenState();
}

class _AdminBookingListScreenState extends State<AdminBookingListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ApiClient _apiClient = ApiClient();
  List<dynamic> _bookings = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Colors
  final Color backgroundColor = Colors.grey[50]!;
  final Color textPrimaryColor = Colors.black;
  final Color primaryColor = Color(0xFF4CAF50); // Dominant green color
  final Color priceColor = Colors.red; // Red color for prices

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabChange);
    _fetchBookings();
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      _fetchBookings();
    }
  }

  Future<void> _fetchBookings() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _apiClient.get('${Constants.baseUrl}/admin/bookings');
      
      if (response is Map<String, dynamic> && response.containsKey('data')) {
        setState(() {
          _bookings = response['data'] as List<dynamic>;
          _isLoading = false;
        });
      } else {
        throw Exception('Format data tidak sesuai');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Gagal memuat data: $e';
        });
      }
    }
  }

  List<dynamic> get _filteredBookings {
    final String status = _getCurrentTabStatus();
    final query = _searchQuery.toLowerCase();
    
    return _bookings.where((booking) {
      // Filter by status if not "all"
      if (status != 'all' && booking['status'] != status) {
        return false;
      }
      
      // Filter by search query
      final guestName = booking['guest_name']?.toString().toLowerCase() ?? '';
      final propertyName = booking['property']?['name']?.toString().toLowerCase() ?? '';
      final bookingId = booking['id']?.toString() ?? '';
      
      return guestName.contains(query) || 
             propertyName.contains(query) || 
             bookingId.contains(query);
    }).toList();
  }

  String _getCurrentTabStatus() {
    switch (_tabController.index) {
      case 0:
        return 'all';
      case 1:
        return 'pending';
      case 2:
        return 'cancelled';
      case 3:
        return 'completed';
      default:
        return 'all';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Daftar Pemesanan',
              style: TextStyle(
                color: textPrimaryColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textPrimaryColor),
          onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BottomBar()),
          );
        },
      ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: primaryColor,
          labelColor: primaryColor,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Semua'),
            Tab(text: 'Menunggu'),
            Tab(text: 'Dibatalkan'),
            Tab(text: 'Selesai'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: textPrimaryColor, size: 24),
            onPressed: () {
              showSearch(
                context: context,
                delegate: BookingSearchDelegate(_bookings, _getStatusText, _getStatusColor),
              );
            },
            tooltip: 'Cari',
          ),
          IconButton(
            icon: Icon(Icons.refresh, color: textPrimaryColor, size: 24),
            onPressed: _fetchBookings,
            tooltip: 'Segarkan',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari berdasarkan nama tamu atau properti',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: _isLoading
                ? const LoadingIndicator()
                : _errorMessage != null
                    ? ErrorState(
                        message: _errorMessage!,
                        onRetry: _fetchBookings,
                      )
                    : _buildBookingList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingList() {
    final filteredBookings = _filteredBookings;
    
    if (filteredBookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Tidak ada pemesanan ditemukan',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchBookings,
      color: primaryColor,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: filteredBookings.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final booking = filteredBookings[index];
          return _buildBookingCard(booking);
        },
      ),
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> booking) {
    final checkIn = DateTime.parse(booking['check_in']);
    final checkOut = DateTime.parse(booking['check_out']);
    final duration = checkOut.difference(checkIn).inDays;
    final statusColor = _getStatusColor(booking['status']);
    final formattedPrice = FormatUtils.formatCurrency(booking['total_price']);
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookingDetailScreen(bookingId: booking['id']),
            ),
          ).then((_) => _fetchBookings());
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _getStatusText(booking['status']),
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'ID: ${booking['id']}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking['guest_name'] ?? 'Tamu',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          booking['guest_phone'] ?? '-',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.home_outlined, size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                booking['property']?['name'] ?? 'Properti',
                                style: const TextStyle(fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        formattedPrice,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: priceColor, // Changed to red color
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$duration hari',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDateInfo(
                    'Check-in',
                    DateFormat('dd MMM yyyy').format(checkIn),
                    Icons.calendar_today,
                  ),
                  _buildDateInfo(
                    'Check-out',
                    DateFormat('dd MMM yyyy').format(checkOut),
                    Icons.calendar_today,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Dibuat pada: ${DateFormat('dd MMM yyyy, HH:mm').format(DateTime.parse(booking['created_at']))}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Colors.grey,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateInfo(String label, String date, IconData icon) {
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
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(icon, size: 14, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text(
              date,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return primaryColor; // Using the dominant green color
      case 'cancelled':
        return Colors.red;
      case 'completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Menunggu';
      case 'confirmed':
        return 'Dikonfirmasi';
      case 'cancelled':
        return 'Dibatalkan';
      case 'completed':
        return 'Selesai';
      default:
        return 'Tidak Diketahui';
    }
  }
}

class BookingSearchDelegate extends SearchDelegate {
  final List<dynamic> bookings;
  final Function(String) getStatusText;
  final Function(String) getStatusColor;

  BookingSearchDelegate(this.bookings, this.getStatusText, this.getStatusColor);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final results = bookings.where((booking) {
      final guestName = booking['guest_name']?.toString().toLowerCase() ?? '';
      final propertyName = booking['property']?['name']?.toString().toLowerCase() ?? '';
      final bookingId = booking['id']?.toString() ?? '';
      
      return guestName.contains(query.toLowerCase()) || 
             propertyName.contains(query.toLowerCase()) || 
             bookingId.contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final booking = results[index];
        return ListTile(
          title: Text(booking['guest_name'] ?? 'Tamu'),
          subtitle: Text(booking['property']?['name'] ?? 'Properti'),
          trailing: Text(
            getStatusText(booking['status']),
            style: TextStyle(
              color: getStatusColor(booking['status']),
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookingDetailScreen(bookingId: booking['id']),
              ),
            );
          },
        );
      },
    );
  }
}