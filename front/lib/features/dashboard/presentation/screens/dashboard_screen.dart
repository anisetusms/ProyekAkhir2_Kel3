import 'package:flutter/material.dart';
import 'package:front/core/network/api_client.dart';
import 'package:front/core/utils/constants.dart';
import 'package:front/core/utils/format_utils.dart';
import 'package:front/core/widgets/dashboard_card.dart';
import 'package:front/core/widgets/loading_indicator.dart';
import 'package:front/core/widgets/error_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = '/dashboard';

  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Color Scheme
  final Color _primaryColor = const Color(0xFF2F9F20);
  final Color _primaryDarkColor = const Color(0xFF247F17);
  final Color _backgroundColor = const Color(0xFFF8F9FA);
  final Color _textPrimaryColor = const Color(0xFF212529);
  final Color _textSecondaryColor = const Color(0xFF495057);
  final Color _cardBackground = Colors.white;

  // Text Styles
  TextStyle get _appBarTitleStyle => const TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  TextStyle get _headlineStyle => TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: _textPrimaryColor,
  );

  TextStyle get _bodyStyle => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: _textSecondaryColor,
  );

  // State variables
  Future<Map<String, dynamic>>? _dashboardDataFuture;
  String? _errorMessage;
  bool _isLoading = false;
  Map<String, dynamic> _userProfile = {};
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
    _fetchProfile();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await ApiClient().get('${Constants.baseUrl}/dashboard');
      if (response is Map<String, dynamic>) {
        setState(() {
          _dashboardDataFuture = Future.value(response);
        });
      } else {
        throw Exception('Invalid dashboard data format');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load data: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) throw Exception('No authentication token found');

      final response = await ApiClient().get('${Constants.baseUrl}/profile');
      if (response['success'] == true) {
        setState(() {
          _userProfile = response['data'];
        });
      } else {
        throw Exception(
          response['message']?.toString() ?? 'Failed to fetch profile',
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load profile: $e';
      });
    }
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back,',
          style: _bodyStyle.copyWith(color: _textSecondaryColor),
        ),
        const SizedBox(height: 4),
        Text(
          _userProfile['name'] ?? 'Owner',
          style: _headlineStyle.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Here\'s your property overview',
          style: _bodyStyle.copyWith(color: _textSecondaryColor),
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.1,
      children: [
        _buildStatCard(
          icon: Icons.home_work_outlined,
          title: 'Total Properties',
          valueKey: 'total_properties',
          color: _primaryColor,
        ),
        _buildStatCard(
          icon: Icons.check_circle_outline,
          title: 'Active Properties',
          valueKey: 'active_properties',
          color: Colors.green[700]!,
        ),
        _buildStatCard(
          icon: Icons.visibility_off_outlined,
          title: 'Inactive Properties',
          valueKey: 'inactive_properties',
          color: Colors.orange[700]!,
        ),
        _buildStatCard(
          icon: Icons.calendar_today_outlined,
          title: 'Total Bookings',
          valueKey: 'total_bookings',
          color: Colors.teal[700]!,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String valueKey,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          color: _cardBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<Map<String, dynamic>>(
          future: _dashboardDataFuture,
          builder: (context, snapshot) {
            final value = snapshot.hasData ? snapshot.data![valueKey] ?? 0 : 0;
            return DashboardCard(
              icon: icon,
              title: title,
              value: FormatUtils.formatNumber(value), // Menggunakan format harga
              color: color,
            );
          },
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: _headlineStyle.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 2.5,
          children: [
            _buildActionButton(
              icon: Icons.add,
              label: 'Add Property',
              route: '/add_property',
              color: _primaryColor,
            ),
            _buildActionButton(
              icon: Icons.list,
              label: 'View Properties',
              route: '/properties',
              color: Colors.green[700]!,
            ),
            _buildActionButton(
              icon: Icons.book,
              label: 'Manage Bookings',
              route: '/bookings',
              color: Colors.teal[700]!,
            ),
            _buildActionButton(
              icon: Icons.settings,
              label: 'Settings',
              route: '/settings',
              color: Colors.blueGrey[700]!,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required String route,
    required Color color,
  }) {
    return ElevatedButton(
      onPressed: () => Navigator.pushNamed(context, route),
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Activities',
              style: _headlineStyle.copyWith(fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/activities'),
              child: Text(
                'View All',
                style: TextStyle(
                  color: _primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: FutureBuilder<Map<String, dynamic>>(
              future: _dashboardDataFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData ||
                    snapshot.data!['recent_activities'] == null) {
                  return Center(
                    child: Text(
                      'No recent activities',
                      style: _bodyStyle.copyWith(color: _textSecondaryColor),
                    ),
                  );
                }

                final activities = snapshot.data!['recent_activities'] as List;
                if (activities.isEmpty) {
                  return Center(
                    child: Text(
                      'No recent activities',
                      style: _bodyStyle.copyWith(color: _textSecondaryColor),
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: activities.length > 5 ? 5 : activities.length,
                  separatorBuilder: (_, __) => const Divider(height: 16),
                  itemBuilder: (context, index) {
                    final activity = activities[index];
                    return _buildActivityItem(activity);
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getActivityColor(activity['type']).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getActivityIcon(activity['type']),
            size: 20,
            color: _getActivityColor(activity['type']),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(activity['description'] ?? 'Activity', style: _bodyStyle),
              const SizedBox(height: 4),
              Text(
                FormatUtils.formatDateTime(activity['created_at']),
                style: _bodyStyle.copyWith(
                  color: _textSecondaryColor,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
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
      case 'payment_received':
        return Icons.payment_outlined;
      default:
        return Icons.notifications_none;
    }
  }

  Color _getActivityColor(String? type) {
    switch (type) {
      case 'property_added':
        return _primaryColor;
      case 'property_updated':
        return Colors.blue;
      case 'booking_created':
        return Colors.purple;
      case 'payment_received':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body:
          _isLoading
              ? const LoadingIndicator()
              : _errorMessage != null
              ? ErrorState(message: _errorMessage!, onRetry: _loadDashboardData)
              : LiquidPullToRefresh(
                color: _primaryColor,
                backgroundColor: _backgroundColor,
                onRefresh: _loadDashboardData,
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverAppBar(
                      title: Text('Dashboard', style: _appBarTitleStyle),
                      centerTitle: false,
                      floating: true,
                      snap: true,
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      flexibleSpace: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [_primaryColor, _primaryDarkColor],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.refresh, color: Colors.white),
                          onPressed: _loadDashboardData,
                          tooltip: 'Refresh',
                        ),
                      ],
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          _buildHeader(),
                          const SizedBox(height: 24),
                          _buildStatsGrid(),
                          const SizedBox(height: 24),
                          _buildQuickActions(),
                          const SizedBox(height: 24),
                          _buildRecentActivities(),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
