import 'package:flutter/material.dart';
import 'package:front/core/network/api_client.dart';
import 'package:front/core/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:front/core/utils/format_utils.dart';
import 'package:front/core/widgets/dashboard_card.dart';
import 'package:front/core/widgets/loading_indicator.dart';
import 'package:front/core/widgets/error_state.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = '/dashboard';

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Future<Map<String, dynamic>>? _dashboardDataFuture;
  String? _errorMessage;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isRefreshing = true;
      _errorMessage = null;
    });

    try {
      final response = await ApiClient().get('${Constants.baseUrl}/dashboard');
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

  Widget _buildDashboardCard({
    required IconData icon,
    required String title,
    required dynamic value,
    Color? color,
  }) {
    return DashboardCard(
      icon: icon,
      title: title,
      value: value.toString(),
      color: color ?? Theme.of(context).primaryColor,
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 20),
      label: Text(label),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 45), // Sedikit mengurangi tinggi tombol
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Admin'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDashboardData,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isRefreshing
          ? const LoadingIndicator()
          : _errorMessage != null
              ? ErrorState(
                  message: _errorMessage!,
                  onRetry: _loadDashboardData,
                )
              : RefreshIndicator(
                  onRefresh: _loadDashboardData,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(12), // Mengurangi padding keseluruhan
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          'Selamat Datang di Dashboard Owner!',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Ringkasan Aktivitas Properti',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 16), // Mengurangi sedikit spasi

                        // Stats Cards Grid
                        GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          mainAxisSpacing: 12, // Mengurangi spasi antar card
                          crossAxisSpacing: 12, // Mengurangi spasi antar card
                          childAspectRatio: 1.1, // Sedikit menyesuaikan rasio aspek
                          children: [
                            FutureBuilder<Map<String, dynamic>>(
                              future: _dashboardDataFuture,
                              builder: (context, snapshot) {
                                final totalProperties = snapshot.hasData
                                    ? snapshot.data!['total_properties'] ?? 0
                                    : 0;
                                return _buildDashboardCard(
                                  icon: Icons.home_work_outlined,
                                  title: 'Total Properti',
                                  value: FormatUtils.formatNumber(totalProperties),
                                  color: Colors.blue[700],
                                );
                              },
                            ),
                            FutureBuilder<Map<String, dynamic>>(
                              future: _dashboardDataFuture,
                              builder: (context, snapshot) {
                                final activeProperties = snapshot.hasData
                                    ? snapshot.data!['active_properties'] ?? 0
                                    : 0;
                                return _buildDashboardCard(
                                  icon: Icons.check_circle_outline,
                                  title: 'Properti Aktif',
                                  value: FormatUtils.formatNumber(activeProperties),
                                  color: Colors.green[700],
                                );
                              },
                            ),
                            FutureBuilder<Map<String, dynamic>>(
                              future: _dashboardDataFuture,
                              builder: (context, snapshot) {
                                final inactiveProperties = snapshot.hasData
                                    ? snapshot.data!['inactive_properties'] ?? 0
                                    : 0;
                                return _buildDashboardCard(
                                  icon: Icons.visibility_off_outlined,
                                  title: 'Properti Nonaktif',
                                  value:
                                      FormatUtils.formatNumber(inactiveProperties),
                                  color: Colors.orange[700],
                                );
                              },
                            ),
                            FutureBuilder<Map<String, dynamic>>(
                              future: _dashboardDataFuture,
                              builder: (context, snapshot) {
                                final totalBookings = snapshot.hasData
                                    ? snapshot.data!['total_bookings'] ?? 0
                                    : 0;
                                return _buildDashboardCard(
                                  icon: Icons.calendar_today_outlined,
                                  title: 'Total Pemesanan',
                                  value: FormatUtils.formatNumber(totalBookings),
                                  color: Colors.purple[700],
                                );
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 16), // Mengurangi sedikit spasi

                        // Quick Actions
                        Text(
                          'Aksi Cepat',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12), // Mengurangi sedikit spasi
                        Column(
                          children: [
                            _buildActionButton(
                              icon: Icons.add,
                              label: 'Tambah Properti Baru',
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/add_property'),
                            ),
                            const SizedBox(height: 8), // Mengurangi spasi antar tombol
                            _buildActionButton(
                              icon: Icons.list,
                              label: 'Lihat Semua Properti',
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/properties'),
                            ),
                            const SizedBox(height: 8), // Mengurangi spasi antar tombol
                            _buildActionButton(
                              icon: Icons.book,
                              label: 'Kelola Pemesanan',
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/bookings'),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16), // Mengurangi sedikit spasi

                        // Recent Activities
                        Card(
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(12), // Mengurangi padding card
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.history, size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Aktivitas Terkini',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                FutureBuilder<Map<String, dynamic>>(
                                  future: _dashboardDataFuture,
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData ||
                                        snapshot.data!['recent_activities'] ==
                                            null) {
                                      return const Padding(
                                        padding: EdgeInsets.all(8),
                                        child:
                                            Text('Tidak ada aktivitas terkini'),
                                      );
                                    }

                                    final activities =
                                        snapshot.data!['recent_activities']
                                            as List;
                                    if (activities.isEmpty) {
                                      return const Padding(
                                        padding: EdgeInsets.all(8),
                                        child:
                                            Text('Tidak ada aktivitas terkini'),
                                      );
                                    }

                                    return ListView.separated(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: activities.length > 3
                                          ? 3
                                          : activities.length,
                                      separatorBuilder: (_, __) =>
                                          const SizedBox(height: 8), // Mengurangi spasi
                                      itemBuilder: (context, index) {
                                        final activity = activities[index];
                                        return ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          leading: Container(
                                            padding: const EdgeInsets.all(6), // Mengurangi padding icon
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              _getActivityIcon(activity['type']),
                                              size: 18, // Mengurangi ukuran icon
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                          title: Text(
                                            activity['description'] ??
                                                'Aktivitas',
                                            style:
                                                const TextStyle(fontSize: 13), // Mengurangi ukuran font
                                          ),
                                          subtitle: Text(
                                            FormatUtils.formatDateTime(
                                                activity['created_at']),
                                            style: TextStyle(
                                              fontSize: 9, // Mengurangi ukuran font
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                                const SizedBox(height: 4), // Mengurangi spasi
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () => Navigator.pushNamed(
                                        context, '/activities'),
                                    child: const Text('Lihat Semua',
                                        style: TextStyle(fontSize: 12)), // Mengurangi ukuran font
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8), // Mengurangi spasi terakhir
                      ],
                    ),
                  ),
                ),
    );
  }

  IconData _getActivityIcon(String? type) {
    switch (type) {
      case 'property_added':
        return Icons.add_circle_outline;
      case 'property_updated':
        return Icons.edit_outlined;
      case 'booking_created':
        return Icons.calendar_today_outlined;
      default:
        return Icons.notifications_none;
    }
  }
}
