import 'package:flutter/material.dart';
import 'package:front/core/network/api_client.dart';
import 'package:front/core/utils/constants.dart';
import 'package:front/features/property/presentation/widgets/property_card.dart';
import 'package:front/features/property/presentation/screens/property_detail.dart';
import 'package:front/features/property/presentation/screens/edit_property_screen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'dart:developer';

class PropertyListScreen extends StatefulWidget {
  static const routeName = '/properties';
  @override
  _PropertyListScreenState createState() => _PropertyListScreenState();
}

class _PropertyListScreenState extends State {
  late Future<List> _propertiesFuture;
  bool _isLoading = false;
  String? _errorMessage;
  final ScrollController _scrollController = ScrollController();
  // Color Scheme
  final Color _primaryColor = const Color(0xFF2F9F20); 
  final Color _primaryDarkColor = const Color(0xFF247F17);
  final Color _backgroundColor = const Color(0xFFF8F9FA);
  final Color _textPrimaryColor = const Color(0xFF212529);
  final Color _textSecondaryColor = const Color(0xFF495057);
  final Color _textHintColor = const Color(0xFF6C757D);
  // Text Styles
  TextStyle get _appBarTitleStyle => const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      );
  TextStyle get _headlineSmallStyle => TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: _textPrimaryColor,
      );
  TextStyle get _bodyMediumStyle => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: _textSecondaryColor,
      );
  TextStyle get _buttonStyle => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      );
  @override
  void initState() {
    super.initState();
    _loadProperties();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future _loadProperties() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response =
          await ApiClient().get('${Constants.baseUrl}/properties');
      log('API Response: ${response.toString()}');

      if (response == null || response['data'] == null) {
        throw Exception('Invalid API response');
      }

      if (response['data'] is! List) {
        throw Exception('Invalid data format');
      }

      setState(() {
        _propertiesFuture = Future.value(response['data'] as List<dynamic>);
      });
    } catch (e) {
      log('Error loading properties: $e');
      setState(() {
        _errorMessage = 'Failed to load property data. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Map<String, dynamic> _parseProperty(dynamic propertyData) {
    final Map<String, dynamic> property = {};
    if (propertyData is Map) {
      propertyData.forEach((key, value) {
        property[key.toString()] = value;
      });
      property['status'] =
          propertyData['isDeleted'] == false ? 'active' : 'inactive';
    }
    property['price'] =
        double.tryParse(property['price']?.toString() ?? '0') ?? 0.0;
    return property;
  }

  Widget _buildPropertyCard(BuildContext context, dynamic propertyData) {
    final property = _parseProperty(propertyData);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: PropertyCard(
        property: property,
        onTap: () {
          Navigator.pushNamed(
            context,
            PropertyDetailScreen.routeName,
            arguments: property['id'],
          );
        },
        onManageRooms: () {
          Navigator.pushNamed(
            context,
            '/manage_rooms',
            arguments: property['id'],
          );
        },
        onEdit: () {
          Navigator.pushNamed(
            context,
            EditPropertyScreen.routeName,
            arguments: property,
          );
        },
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.home_work_outlined,
            size: 100,
            color: _textHintColor.withOpacity(0.5),
          ),
          const SizedBox(height: 24),
          Text(
            'No Properties Added Yet',
            style: _headlineSmallStyle.copyWith(
              color: _textSecondaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Start by adding your first property',
            style: _bodyMediumStyle.copyWith(
              color: _textHintColor,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/add_property');
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add, size: 24, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  'Add New Property',
                  style: _buttonStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: Text(
          'Property Management',
          style: _appBarTitleStyle,
        ),
        centerTitle: false,
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
            icon: const Icon(Icons.search, size: 28, color: Colors.white),
            onPressed: () {
              // Implement search functionality
            },
            tooltip: 'Search',
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, size: 28, color: Colors.white),
            onPressed: () {
              // Implement filter functionality
            },
            tooltip: 'Filters',
          ),
          IconButton(
            icon: const Icon(Icons.refresh, size: 28, color: Colors.white),
            onPressed: _loadProperties,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? _buildShimmerLoading()
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage!,
                        style: _bodyMediumStyle,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryColor,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _loadProperties,
                        child: Text(
                          'Try Again',
                          style: _buttonStyle,
                        ),
                      ),
                    ],
                  ),
                )
              : LiquidPullToRefresh(
                  color: _primaryColor,
                  height: 150,
                  backgroundColor: _backgroundColor,
                  animSpeedFactor: 2,
                  showChildOpacityTransition: false,
                  onRefresh: _loadProperties,
                  child: FutureBuilder<List>(
                    future: _propertiesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 48,
                                color: Colors.red[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Error occurred: ${snapshot.error}',
                                style: _bodyMediumStyle,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _primaryColor,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 32, vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: _loadProperties,
                                child: Text(
                                  'Retry',
                                  style: _buttonStyle,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return _buildEmptyState();
                      }

                      return ListView.builder(
                        controller: _scrollController,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 100),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return _buildPropertyCard(
                            context,
                            snapshot.data![index],
                          );
                        },
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_property');
        },
        backgroundColor: _primaryColor,
        elevation: 4,
        child: const Icon(Icons.add, size: 32, color: Colors.white),
      ),
    );
  }
}

