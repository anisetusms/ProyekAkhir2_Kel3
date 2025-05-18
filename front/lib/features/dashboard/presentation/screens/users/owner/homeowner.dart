// import 'package:flutter/material.dart';
// import 'package:front/core/network/api_client.dart';
// import 'package:front/core/utils/constants.dart';
// import 'package:dio/dio.dart';
// import 'package:front/core/utils/format_utils.dart';
// import 'package:front/core/widgets/loading_indicator.dart';
// import 'package:front/core/widgets/error_state.dart';
// import 'package:intl/intl.dart';

// class DashboardScreen extends StatefulWidget {
//   static const routeName = '/dashboard';

//   @override
//   _DashboardScreenState createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   Future<Map<String, dynamic>>? _dashboardDataFuture;
//   String? _errorMessage;
//   bool _isRefreshing = false;
//   final ScrollController _scrollController = ScrollController();

//   // Warna tema
//   final Color primaryColor = const Color(
//     0xFF8E44AD,
//   ); // Ungu seperti di screenshot
//   final Color blueCardColor = const Color(0xFFE3F2FD);
//   final Color greenCardColor = const Color(0xFFE8F5E9);
//   final Color purpleCardColor = const Color(0xFFF3E5F5);
//   final Color yellowCardColor = const Color(0xFFFFF8E1);
//   final Color addPropertyColor = const Color(
//     0xFF4CAF50,
//   ); // Hijau untuk tombol tambah properti
//   final Color viewPropertiesColor = const Color(
//     0xFF2196F3,
//   ); // Biru untuk tombol lihat properti
//   final Color manageBookingsColor = const Color(
//     0xFF9C27B0,
//   ); // Ungu untuk tombol kelola pemesanan

//   @override
//   void initState() {
//     super.initState();
//     _loadDashboardData();
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadDashboardData() async {
//     setState(() {
//       _isRefreshing = true;
//       _errorMessage = null;
//     });

//     try {
//       final response = await ApiClient().get('/dashboard');
//       if (response is Map<String, dynamic>) {
//         setState(() {
//           _dashboardDataFuture = Future.value(response);
//         });
//       } else {
//         throw Exception('Format data dashboard tidak sesuai');
//       }
//     } on DioException catch (e) {
//       setState(() {
//         _errorMessage =
//             'Gagal memuat data: ${e.response?.data['message'] ?? e.message}';
//       });
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Terjadi kesalahan: ${e.toString()}';
//       });
//     } finally {
//       setState(() {
//         _isRefreshing = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body:
//           _isRefreshing
//               ? const LoadingIndicator()
//               : _errorMessage != null
//               ? ErrorState(message: _errorMessage!, onRetry: _loadDashboardData)
//               : RefreshIndicator(
//                 onRefresh: _loadDashboardData,
//                 child: CustomScrollView(
//                   controller: _scrollController,
//                   slivers: [
//                     _buildAppBar(),
//                     SliverToBoxAdapter(
//                       child: Padding(
//                         padding: const EdgeInsets.all(16),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             _buildWelcomeSection(),
//                             const SizedBox(height: 24),
//                             _buildStatisticsSection(),
//                             const SizedBox(height: 16),
//                             _buildPendingBookingsAlert(),
//                             const SizedBox(height: 24),
//                             _buildQuickActionsSection(),
//                             const SizedBox(height: 24),
//                             _buildRecentBookingsSection(),
//                             const SizedBox(height: 16),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//     );
//   }

//   Widget _buildAppBar() {
//     return SliverAppBar(
//       expandedHeight: 100,
//       floating: false,
//       pinned: true,
//       backgroundColor: primaryColor,
//       flexibleSpace: FlexibleSpaceBar(
//         title: const Text(
//           'Dashboard',
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         background: Container(color: primaryColor),
//       ),
//       actions: [
//         IconButton(
//           icon: const Icon(Icons.refresh, color: Colors.white),
//           onPressed: _loadDashboardData,
//           tooltip: 'Refresh',
//         ),
//         IconButton(
//           icon: const Icon(Icons.person, color: Colors.white),
//           onPressed: () => Navigator.pushNamed(context, '/profile'),
//           tooltip: 'Profil',
//         ),
//       ],
//     );
//   }

//   Widget _buildWelcomeSection() {
//     return FutureBuilder<Map<String, dynamic>>(
//       future: _dashboardDataFuture,
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return const SizedBox.shrink();
//         }

//         final userData = snapshot.data!['user'];
//         final userName = userData['name'] ?? 'Pemilik';

//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Selamat Datang,',
//               style: TextStyle(fontSize: 16, color: Colors.grey[700]),
//             ),
//             Text(
//               userName,
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: primaryColor,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Kelola properti dan pemesanan Anda dengan mudah',
//               style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildStatisticsSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Icon(Icons.bar_chart, color: primaryColor),
//             const SizedBox(width: 8),
//             Text(
//               'Statistik',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 16),
//         GridView.count(
//           crossAxisCount: 2,
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           mainAxisSpacing: 16,
//           crossAxisSpacing: 16,
//           childAspectRatio: 1.2,
//           children: [
//             _buildStatCard(
//               icon: Icons.home,
//               title: 'Total Properti',
//               value: _getStatValue('total_properties'),
//               backgroundColor: blueCardColor,
//               iconColor: Colors.blue,
//             ),
//             _buildStatCard(
//               icon: Icons.check_circle,
//               title: 'Properti Aktif',
//               value: _getStatValue('active_properties'),
//               backgroundColor: greenCardColor,
//               iconColor: Colors.green,
//             ),
//             _buildStatCard(
//               icon: Icons.calendar_today,
//               title: 'Total Pemesanan',
//               value: _getStatValue('total_bookings'),
//               backgroundColor: purpleCardColor,
//               iconColor: Colors.purple,
//             ),
//             _buildStatCard(
//               icon: Icons.attach_money,
//               title: 'Total Pendapatan',
//               value: _getStatValue('total_revenue', isCurrency: true),
//               backgroundColor: yellowCardColor,
//               iconColor: Colors.amber,
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _getStatValue(String key, {bool isCurrency = false}) {
//     if (_dashboardDataFuture == null) return Text(isCurrency ? 'Rp 0' : '0');

//     return FutureBuilder<Map<String, dynamic>>(
//       future: _dashboardDataFuture,
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) return Text(isCurrency ? 'Rp 0' : '0');

//         final value = snapshot.data![key] ?? 0;
//         if (isCurrency) {
//           return Text(FormatUtils.formatCurrency(value));
//         } else {
//           return Text(FormatUtils.formatNumber(value));
//         }
//       },
//     );
//   }

//   Widget _buildStatCard({
//     required IconData icon,
//     required String title,
//     required Widget value, // Changed to Widget to handle dynamic content
//     required Color backgroundColor,
//     required Color iconColor,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: backgroundColor,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Icon(icon, color: iconColor, size: 28),
//           const SizedBox(height: 8),
//           Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
//           value, // Dynamically added Widget
//         ],
//       ),
//     );
//   }

//   Widget _buildPendingBookingsAlert() {
//     return FutureBuilder<Map<String, dynamic>>(
//       future: _dashboardDataFuture,
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) return const SizedBox.shrink();

//         final pendingBookings = snapshot.data!['pending_bookings'] ?? 0;
//         if (pendingBookings <= 0) return const SizedBox.shrink();

//         return Container(
//           decoration: BoxDecoration(
//             color: Colors.orange[50],
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: Colors.orange[300]!),
//           ),
//           padding: const EdgeInsets.all(16),
//           child: Row(
//             children: [
//               Icon(Icons.notifications_active, color: Colors.orange[700]),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Pemesanan Menunggu Konfirmasi',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.orange[800],
//                       ),
//                     ),
//                     Text(
//                       'Anda memiliki $pendingBookings pemesanan yang perlu dikonfirmasi',
//                       style: TextStyle(color: Colors.orange[800]),
//                     ),
//                   ],
//                 ),
//               ),
//               Icon(
//                 Icons.arrow_forward_ios,
//                 color: Colors.orange[700],
//                 size: 16,
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildQuickActionsSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Icon(Icons.flash_on, color: primaryColor),
//             const SizedBox(width: 8),
//             Text(
//               'Aksi Cepat',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 16),
//         _buildActionButton(
//           icon: Icons.add,
//           label: 'Tambah Properti Baru',
//           onPressed: () => Navigator.pushNamed(context, '/add_property'),
//           color: addPropertyColor,
//         ),
//         const SizedBox(height: 12),
//         _buildActionButton(
//           icon: Icons.list,
//           label: 'Lihat Semua Properti',
//           onPressed: () => Navigator.pushNamed(context, '/properties'),
//           color: viewPropertiesColor,
//         ),
//         const SizedBox(height: 12),
//         _buildActionButton(
//           icon: Icons.book,
//           label: 'Kelola Pemesanan',
//           onPressed: () => Navigator.pushNamed(context, '/bookings'),
//           color: manageBookingsColor,
//         ),
//       ],
//     );
//   }

//   Widget _buildActionButton({
//     required IconData icon,
//     required String label,
//     required VoidCallback onPressed,
//     required Color color,
//   }) {
//     return ElevatedButton.icon(
//       icon: Icon(icon, size: 20),
//       label: Text(label),
//       onPressed: onPressed,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: color,
//         foregroundColor: Colors.white,
//         minimumSize: const Size(double.infinity, 50),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       ),
//     );
//   }

//   Widget _buildRecentBookingsSection() {
//     return FutureBuilder<Map<String, dynamic>>(
//       future: _dashboardDataFuture,
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) return const SizedBox.shrink();

//         final recentBookings = snapshot.data!['recent_bookings'] as List?;
//         if (recentBookings == null || recentBookings.isEmpty) {
//           return const SizedBox.shrink();
//         }

//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     Icon(Icons.calendar_today, color: primaryColor),
//                     const SizedBox(width: 8),
//                     Text(
//                       'Pemesanan Terbaru',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black87,
//                       ),
//                     ),
//                   ],
//                 ),
//                 TextButton(
//                   onPressed: () => Navigator.pushNamed(context, '/bookings'),
//                   child: Text(
//                     'Lihat Semua',
//                     style: TextStyle(color: primaryColor),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             ListView.separated(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: recentBookings.length > 3 ? 3 : recentBookings.length,
//               separatorBuilder: (context, index) => const Divider(),
//               itemBuilder: (context, index) {
//                 final booking = recentBookings[index];
//                 return _buildBookingItem(booking);
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildBookingItem(Map<String, dynamic> booking) {
//     final checkIn =
//         booking['check_in'] != null
//             ? DateTime.parse(booking['check_in'])
//             : DateTime.now();
//     final checkOut =
//         booking['check_out'] != null
//             ? DateTime.parse(booking['check_out'])
//             : DateTime.now().add(const Duration(days: 1));
//     final status = booking['status'] ?? 'pending';

//     Color statusColor;
//     String statusText;

//     switch (status) {
//       case 'pending':
//         statusColor = Colors.orange;
//         statusText = 'Menunggu';
//         break;
//       case 'confirmed':
//         statusColor = Colors.green;
//         statusText = 'Dikonfirmasi';
//         break;
//       case 'completed':
//         statusColor = Colors.blue;
//         statusText = 'Selesai';
//         break;
//       case 'cancelled':
//         statusColor = Colors.red;
//         statusText = 'Dibatalkan';
//         break;
//       default:
//         statusColor = Colors.grey;
//         statusText = 'Tidak Diketahui';
//     }

//     return ListTile(
//       contentPadding: EdgeInsets.zero,
//       leading: CircleAvatar(
//         backgroundColor: Colors.grey[200],
//         backgroundImage:
//             booking['property_image'] != null
//                 ? NetworkImage(
//                   '${Constants.baseUrl}/storage/${booking['property_image']}',
//                 )
//                 : null,
//         child:
//             booking['property_image'] == null
//                 ? const Icon(Icons.home, color: Colors.grey)
//                 : null,
//       ),
//       title: Text(
//         booking['guest_name'] ?? 'Tamu',
//         style: const TextStyle(fontWeight: FontWeight.bold),
//       ),
//       subtitle: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(booking['property_name'] ?? 'Properti'),
//           Text(
//             '${DateFormat('dd MMM yyyy').format(checkIn)} - ${DateFormat('dd MMM yyyy').format(checkOut)}',
//             style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//           ),
//         ],
//       ),
//       trailing: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//             decoration: BoxDecoration(
//               color: statusColor.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(4),
//             ),
//             child: Text(
//               statusText,
//               style: TextStyle(
//                 color: statusColor,
//                 fontSize: 12,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             FormatUtils.formatCurrency(booking['total_price'] ?? 0),
//             style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
//           ),
//         ],
//       ),
//       onTap: () {
//         if (booking['id'] != null) {
//           Navigator.pushNamed(context, '/bookings/${booking['id']}');
//         }
//       },
//     );
//   }
// }





import 'package:flutter/material.dart';
import 'package:front/core/network/api_client.dart';
import 'package:front/core/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:front/core/utils/format_utils.dart';
import 'package:front/core/widgets/loading_indicator.dart';
import 'package:front/core/widgets/error_state.dart';
import 'package:front/features/dashboard/presentation/screens/users/owner/notification_screen.dart';
import 'package:intl/intl.dart';
import 'package:front/features/property/presentation/screens/property_list.dart';
import 'package:front/features/dashboard/presentation/screens/users/owner/admin_booking_list_screen.dart';
import 'package:front/features/dashboard/presentation/screens/users/owner/profil.dart';
import 'package:front/features/dashboard/presentation/screens/users/owner/service/notification_service.dart';


class DashboardScreen extends StatefulWidget {
  static const routeName = '/dashboard';

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Future<Map<String, dynamic>>? _dashboardDataFuture;
  String? _errorMessage;
  bool _isRefreshing = false;
  final ScrollController _scrollController = ScrollController();
  final NotificationService _notificationService = NotificationService();
  int _unreadNotificationsCount = 0;
  bool _isLoadingNotifications = true; // Menandakan apakah notifikasi sedang dimuat

  // Warna tema
  final Color primaryColor = const Color(0xFF4CAF50,
  ); // Ungu seperti di screenshot
  final Color blueCardColor = const Color(0xFFE8F5E9);
  final Color greenCardColor = const Color(0xFFE8F5E9);
  final Color purpleCardColor = const Color(0xFFF3E5F5);
  final Color yellowCardColor = const Color(0xFFFFF8E1);
  final Color addPropertyColor = const Color(
    0xFF4CAF50,
  ); // Hijau untuk tombol tambah properti
  final Color viewPropertiesColor = const Color(0xFF4CAF50,
  ); // Biru untuk tombol lihat properti
  final Color manageBookingsColor = const Color(0xFF4CAF50,
  ); // Ungu untuk tombol kelola pemesanan

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
    _loadUnreadNotificationsCount();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isRefreshing = true;
      _errorMessage = null;
    });

    try {
      final response = await ApiClient().get('/dashboard');
      if (response is Map<String, dynamic>) {
        setState(() {
          _dashboardDataFuture = Future.value(response);
        });
      } else {
        throw Exception('Format data dashboard tidak sesuai');
      }
    } on DioException catch (e) {
      setState(() {
        _errorMessage =
            'Gagal memuat data: ${e.response?.data['message'] ?? e.message}';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Terjadi kesalahan: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isRefreshing = false;
      });
    }
  }

  Future<void> _loadUnreadNotificationsCount() async {
    setState(() {
      _isLoadingNotifications = true;
    });

    try {
      final count = await _notificationService.getUnreadCount();
      setState(() {
        _unreadNotificationsCount = count;
        _isLoadingNotifications = false;
      });
    } catch (e) {
      print('Error loading notifications count: $e');
      setState(() {
        _unreadNotificationsCount = 0;
        _isLoadingNotifications = false;
      });
    }
  }

  void _navigateToNotifications() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NotificationScreen()),
    );

    // Segarkan jumlah notifikasi setelah kembali dari halaman notifikasi
    _loadUnreadNotificationsCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isRefreshing
          ? const LoadingIndicator()
          : _errorMessage != null
              ? ErrorState(message: _errorMessage!, onRetry: _loadDashboardData)
              : RefreshIndicator(
                  onRefresh: _loadDashboardData,
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      _buildAppBar(),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildWelcomeSection(),
                              const SizedBox(height: 24),
                              _buildPendingBookingsAlert(),
                              const SizedBox(height: 24),
                              _buildStatisticsSection(),
                              const SizedBox(height: 24),
                              _buildQuickActionsSection(),
                              const SizedBox(height: 24),
                              _buildRecentBookingsSection(),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 100,
      floating: false,
      pinned: true,
      backgroundColor: Color(0xFF4CAF50),
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        background: Container(color: primaryColor),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white),
          onPressed: () {
            _loadDashboardData();
            _loadUnreadNotificationsCount();
          },
          tooltip: 'Refresh',
        ),
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white),
              onPressed: _navigateToNotifications,
              tooltip: 'Notifikasi',
            ),
            if (_unreadNotificationsCount > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    _unreadNotificationsCount > 9
                        ? '9+'
                        : _unreadNotificationsCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            if (_isLoadingNotifications)
              Positioned(
                left: 8,
                top: 8,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.person, color: Colors.white),
          onPressed: () => _navigateToProfile(),
          tooltip: 'Profil',
        ),
      ],
    );
  }

  Widget _buildWelcomeSection() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _dashboardDataFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final userData = snapshot.data!['user'];
        final userName = userData['name'] ?? 'Pemilik';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selamat Datang,',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            Text(
              userName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Kelola properti dan pemesanan Anda dengan mudah',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPendingBookingsAlert() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _dashboardDataFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();

        final pendingBookings = snapshot.data!['pending_bookings'] ?? 0;
        if (pendingBookings <= 0) return const SizedBox.shrink();

        return InkWell(
          onTap: () => _navigateToBookings(),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange[300]!),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.notifications_active, color: Colors.orange[700]),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pemesanan Menunggu Konfirmasi',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[800],
                        ),
                      ),
                      Text(
                        'Anda memiliki $pendingBookings pemesanan yang perlu dikonfirmasi',
                        style: TextStyle(color: Colors.orange[800]),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.orange[700],
                  size: 16,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatisticsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.bar_chart, color: primaryColor),
            const SizedBox(width: 8),
            Text(
              'Statistik',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.2,
          children: [
            _buildStatCard(
              icon: Icons.home,
              title: 'Total Properti',
              value: _getStatValue('total_properties'),
              backgroundColor: blueCardColor,
              iconColor: Colors.blue,
              onTap: () => _navigateToPropertyList(),
            ),
            _buildStatCard(
              icon: Icons.check_circle,
              title: 'Properti Aktif',
              value: _getStatValue('active_properties'),
              backgroundColor: greenCardColor,
              iconColor: Colors.green,
              onTap: () => _navigateToPropertyList(),
            ),
            _buildStatCard(
              icon: Icons.calendar_today,
              title: 'Total Pemesanan',
              value: _getStatValue('total_bookings'),
              backgroundColor: purpleCardColor,
              iconColor: Colors.purple,
              onTap: () => _navigateToBookings(),
            ),
            _buildStatCard(
              icon: Icons.attach_money,
              title: 'Total Pendapatan',
              value: _getStatValue('total_revenue', isCurrency: true),
              backgroundColor: yellowCardColor,
              iconColor: Colors.amber,
              onTap: () => _navigateToBookings(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _getStatValue(String key, {bool isCurrency = false}) {
    if (_dashboardDataFuture == null) return Text(isCurrency ? 'Rp 0' : '0');

    return FutureBuilder<Map<String, dynamic>>(
      future: _dashboardDataFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Text(isCurrency ? 'Rp 0' : '0');

        final value = snapshot.data![key] ?? 0;
        if (isCurrency) {
          return Expanded(
            child: Text(
              FormatUtils.formatCurrency(value),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          );
        } else {
          return Expanded(
            child: Text(
              FormatUtils.formatNumber(value),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required Widget value, // Changed to Widget to handle dynamic content
    required Color backgroundColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            // Wrap value with FittedBox to prevent overflow
            FittedBox(
              fit:
                  BoxFit
                      .scaleDown, // Ensures that text fits within available space
              child: value,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.flash_on, color: primaryColor),
            const SizedBox(width: 8),
            Text(
              'Aksi Cepat',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildActionButton(
          icon: Icons.add,
          label: 'Tambah Properti Baru',
          onPressed: () => _navigateToAddProperty(),
          color: addPropertyColor,
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          icon: Icons.list,
          label: 'Lihat Semua Properti',
          onPressed: () => _navigateToPropertyList(),
          color: viewPropertiesColor,
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          icon: Icons.book,
          label: 'Kelola Pemesanan',
          onPressed: () => _navigateToBookings(),
          color: manageBookingsColor,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 20),
      label: Text(label),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildRecentBookingsSection() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _dashboardDataFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();

        final recentBookings = snapshot.data!['recent_bookings'] as List?;
        if (recentBookings == null || recentBookings.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      'Pemesanan Terbaru',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () => _navigateToBookings(),
                  child: Text(
                    'Lihat Semua',
                    style: TextStyle(color: primaryColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recentBookings.length > 3 ? 3 : recentBookings.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final booking = recentBookings[index];
                return _buildBookingItem(booking);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildBookingItem(Map<String, dynamic> booking) {
    final checkIn =
        booking['check_in'] != null
            ? DateTime.parse(booking['check_in'])
            : DateTime.now();
    final checkOut =
        booking['check_out'] != null
            ? DateTime.parse(booking['check_out'])
            : DateTime.now().add(const Duration(days: 1));
    final status = booking['status'] ?? 'pending';

    Color statusColor;
    String statusText;

    switch (status) {
      case 'pending':
        statusColor = Colors.orange;
        statusText = 'Menunggu';
        break;
      case 'confirmed':
        statusColor = Colors.green;
        statusText = 'Dikonfirmasi';
        break;
      case 'completed':
        statusColor = Colors.blue;
        statusText = 'Selesai';
        break;
      case 'cancelled':
        statusColor = Colors.red;
        statusText = 'Dibatalkan';
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'Tidak Diketahui';
    }

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: Colors.grey[200],
        backgroundImage:
            booking['property_image'] != null
                ? NetworkImage(
                  '${Constants.baseUrl}/storage/${booking['property_image']}',
                )
                : null,
        child:
            booking['property_image'] == null
                ? const Icon(Icons.home, color: Colors.grey)
                : null,
      ),
      title: Text(
        booking['guest_name'] ?? 'Tamu',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(booking['property_name'] ?? 'Properti'),
          Text(
            '${DateFormat('dd MMM yyyy').format(checkIn)} - ${DateFormat('dd MMM yyyy').format(checkOut)}',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              statusText,
              style: TextStyle(
                color: statusColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            FormatUtils.formatCurrency(booking['total_price'] ?? 0),
            style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
          ),
        ],
      ),
      onTap: () {
        if (booking['id'] != null) {
          _navigateToBookingDetail(booking['id']);
        }
      },
    );
  }

  // Fungsi navigasi
  void _navigateToPropertyList() {
    // Menggunakan BottomBar untuk navigasi
    _updateBottomBarIndex(1); // Index 1 adalah tab Properti
  }

  void _navigateToBookings() {
    // Menggunakan BottomBar untuk navigasi
    _updateBottomBarIndex(2); // Index 2 adalah tab Booking
  }

  void _navigateToProfile() {
    // Menggunakan BottomBar untuk navigasi
    _updateBottomBarIndex(4); // Index 4 adalah tab Profile
  }

  void _navigateToAddProperty() {
    Navigator.pushNamed(context, '/add_property');
  }

  void _navigateToBookingDetail(dynamic bookingId) {
    Navigator.pushNamed(context, '/bookings/$bookingId');
  }

  // Fungsi untuk mengupdate index BottomBar
  Future<void> _updateBottomBarIndex(int index) async {
    // Cek apakah kita berada di dalam BottomBar
    if (Navigator.of(context).canPop()) {
      // Jika bisa pop, berarti kita berada di dalam stack navigasi
      // Kembali ke halaman utama (BottomBar)
      Navigator.of(context).pop();

      // Tunggu sebentar untuk memastikan pop selesai
      await Future.delayed(const Duration(milliseconds: 100));
    }

    // Navigasi ke halaman yang sesuai dengan index
    switch (index) {
      case 1: // Properti
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PropertyListScreen()),
        );
        break;
      case 2: // Booking
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const AdminBookingListScreen(),
          ),
        );
        break;
      case 4: // Profile
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileOwner()),
        );
        break;
      default:
        // Jika index tidak dikenali, tidak melakukan apa-apa
        break;
    }
  }
}
