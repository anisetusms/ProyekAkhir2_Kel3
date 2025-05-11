// import 'package:flutter/material.dart';
// import 'package:front/core/network/api_client.dart';
// import 'package:front/core/utils/constants.dart';
// import 'package:front/features/property/presentation/widgets/property_card.dart';
// import 'package:front/features/property/presentation/screens/property_detail.dart';
// import 'package:front/features/property/presentation/screens/edit_property_screen.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
// import 'dart:developer';

// class PropertyListScreen extends StatefulWidget {
//   static const routeName = '/properties';
//   @override
//   _PropertyListScreenState createState() => _PropertyListScreenState();
// }

// class _PropertyListScreenState extends State {
//   late Future<List> _propertiesFuture;
//   bool _isLoading = false;
//   String? _errorMessage;
//   final ScrollController _scrollController = ScrollController();
//   // Color Scheme
//   final Color _primaryColor = const Color(0xFF2F9F20); 
//   final Color _primaryDarkColor = const Color(0xFF247F17);
//   final Color _backgroundColor = const Color(0xFFF8F9FA);
//   final Color _textPrimaryColor = const Color(0xFF212529);
//   final Color _textSecondaryColor = const Color(0xFF495057);
//   final Color _textHintColor = const Color(0xFF6C757D);
//   // Text Styles
//   TextStyle get _appBarTitleStyle => const TextStyle(
//         fontSize: 22,
//         fontWeight: FontWeight.w600,
//         color: Colors.white,
//       );
//   TextStyle get _headlineSmallStyle => TextStyle(
//         fontSize: 20,
//         fontWeight: FontWeight.w600,
//         color: _textPrimaryColor,
//       );
//   TextStyle get _bodyMediumStyle => TextStyle(
//         fontSize: 16,
//         fontWeight: FontWeight.w400,
//         color: _textSecondaryColor,
//       );
//   TextStyle get _buttonStyle => const TextStyle(
//         fontSize: 16,
//         fontWeight: FontWeight.w600,
//         color: Colors.white,
//       );
//   @override
//   void initState() {
//     super.initState();
//     _loadProperties();
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   Future _loadProperties() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });

//     try {
//       final response =
//           await ApiClient().get('${Constants.baseUrl}/properties');
//       log('API Response: ${response.toString()}');

//       if (response == null || response['data'] == null) {
//         throw Exception('Invalid API response');
//       }

//       if (response['data'] is! List) {
//         throw Exception('Invalid data format');
//       }

//       setState(() {
//         _propertiesFuture = Future.value(response['data'] as List<dynamic>);
//       });
//     } catch (e) {
//       log('Error loading properties: $e');
//       setState(() {
//         _errorMessage = 'Failed to load property data. Please try again.';
//       });
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   Map<String, dynamic> _parseProperty(dynamic propertyData) {
//     final Map<String, dynamic> property = {};
//     if (propertyData is Map) {
//       propertyData.forEach((key, value) {
//         property[key.toString()] = value;
//       });
//       property['status'] =
//           propertyData['isDeleted'] == false ? 'active' : 'inactive';
//     }
//     property['price'] =
//         double.tryParse(property['price']?.toString() ?? '0') ?? 0.0;
//     return property;
//   }

//   // Fungsi untuk mengaktifkan/menonaktifkan properti
//   Future<void> _togglePropertyStatus(int propertyId, bool isActive) async {
//     try {
//       setState(() => _isLoading = true);
      
//       final String endpoint = isActive 
//           ? '${Constants.baseUrl}/properties/$propertyId/deactivate'
//           : '${Constants.baseUrl}/properties/$propertyId/reactivate';
      
//       final response = await ApiClient().post(endpoint);
      
//       if (response != null && response['message'] != null) {
//         // Tampilkan snackbar sukses
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(response['message']),
//             backgroundColor: Colors.green,
//             behavior: SnackBarBehavior.floating,
//           ),
//         );
        
//         // Reload data
//         _loadProperties();
//       } else {
//         throw Exception('Failed to update property status');
//       }
//     } catch (e) {
//       log('Error toggling property status: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error: ${e.toString()}'),
//           backgroundColor: Colors.red,
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   // Tampilkan dialog konfirmasi
//   Future<void> _showToggleStatusConfirmation(int propertyId, bool isActive) async {
//     final result = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(isActive ? 'Nonaktifkan Properti' : 'Aktifkan Properti'),
//         content: Text(
//           isActive 
//               ? 'Apakah Anda yakin ingin menonaktifkan properti ini? Properti tidak akan muncul di pencarian.'
//               : 'Apakah Anda yakin ingin mengaktifkan kembali properti ini?'
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(false),
//             child: const Text('Batal'),
//           ),
//           ElevatedButton(
//             onPressed: () => Navigator.of(context).pop(true),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: isActive ? Colors.red : Colors.green,
//             ),
//             child: Text(isActive ? 'Nonaktifkan' : 'Aktifkan'),
//           ),
//         ],
//       ),
//     );
    
//     if (result == true) {
//       await _togglePropertyStatus(propertyId, isActive);
//     }
//   }

//   Widget _buildPropertyCard(BuildContext context, dynamic propertyData) {
//     final property = _parseProperty(propertyData);
//     final bool isActive = property['status'] == 'active';
    
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: PropertyCard(
//         property: property,
//         onTap: () {
//           Navigator.pushNamed(
//             context,
//             PropertyDetailScreen.routeName,
//             arguments: property['id'],
//           );
//         },
//         onManageRooms: () {
//           Navigator.pushNamed(
//             context,
//             '/manage_rooms',
//             arguments: property['id'],
//           );
//         },
//         onEdit: () {
//           Navigator.pushNamed(
//             context,
//             EditPropertyScreen.routeName,
//             arguments: property,
//           );
//         },
//         // Tambahkan callback untuk toggle status
//         onToggleStatus: () {
//           _showToggleStatusConfirmation(property['id'], isActive);
//         },
//       ),
//     );
//   }

//   Widget _buildShimmerLoading() {
//     return ListView.builder(
//       padding: const EdgeInsets.symmetric(vertical: 16),
//       itemCount: 6,
//       itemBuilder: (context, index) {
//         return Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           child: Shimmer.fromColors(
//             baseColor: Colors.grey[300]!,
//             highlightColor: Colors.grey[100]!,
//             child: Container(
//               height: 180,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.home_work_outlined,
//             size: 100,
//             color: _textHintColor.withOpacity(0.5),
//           ),
//           const SizedBox(height: 24),
//           Text(
//             'No Properties Added Yet',
//             style: _headlineSmallStyle.copyWith(
//               color: _textSecondaryColor,
//             ),
//           ),
//           const SizedBox(height: 16),
//           Text(
//             'Start by adding your first property',
//             style: _bodyMediumStyle.copyWith(
//               color: _textHintColor,
//             ),
//           ),
//           const SizedBox(height: 24),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: _primaryColor,
//               padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               elevation: 4,
//             ),
//             onPressed: () {
//               Navigator.pushNamed(context, '/add_property');
//             },
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Icon(Icons.add, size: 24, color: Colors.white),
//                 const SizedBox(width: 8),
//                 Text(
//                   'Add New Property',
//                   style: _buttonStyle,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _backgroundColor,
//       appBar: AppBar(
//         title: Text(
//           'Property Management',
//           style: _appBarTitleStyle,
//         ),
//         centerTitle: false,
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [_primaryColor, _primaryDarkColor],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.search, size: 28, color: Colors.white),
//             onPressed: () {
//               // Implement search functionality
//             },
//             tooltip: 'Search',
//           ),
//           IconButton(
//             icon: const Icon(Icons.filter_list, size: 28, color: Colors.white),
//             onPressed: () {
//               // Implement filter functionality
//             },
//             tooltip: 'Filters',
//           ),
//           IconButton(
//             icon: const Icon(Icons.refresh, size: 28, color: Colors.white),
//             onPressed: _loadProperties,
//             tooltip: 'Refresh',
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? _buildShimmerLoading()
//           : _errorMessage != null
//               ? Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.error_outline,
//                         size: 48,
//                         color: Colors.red[400],
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         _errorMessage!,
//                         style: _bodyMediumStyle,
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 24),
//                       ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: _primaryColor,
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 32, vertical: 16),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         onPressed: _loadProperties,
//                         child: Text(
//                           'Try Again',
//                           style: _buttonStyle,
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               : LiquidPullToRefresh(
//                   color: _primaryColor,
//                   height: 150,
//                   backgroundColor: _backgroundColor,
//                   animSpeedFactor: 2,
//                   showChildOpacityTransition: false,
//                   onRefresh: _loadProperties,
//                   child: FutureBuilder<List>(
//                     future: _propertiesFuture,
//                     builder: (context, snapshot) {
//                       if (snapshot.hasError) {
//                         return Center(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(
//                                 Icons.error_outline,
//                                 size: 48,
//                                 color: Colors.red[400],
//                               ),
//                               const SizedBox(height: 16),
//                               Text(
//                                 'Error occurred: ${snapshot.error}',
//                                 style: _bodyMediumStyle,
//                                 textAlign: TextAlign.center,
//                               ),
//                               const SizedBox(height: 24),
//                               ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: _primaryColor,
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 32, vertical: 16),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                 ),
//                                 onPressed: _loadProperties,
//                                 child: Text(
//                                   'Retry',
//                                   style: _buttonStyle,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       }

//                       if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                         return _buildEmptyState();
//                       }

//                       return ListView.builder(
//                         controller: _scrollController,
//                         physics: const BouncingScrollPhysics(),
//                         padding: const EdgeInsets.only(bottom: 100),
//                         itemCount: snapshot.data!.length,
//                         itemBuilder: (context, index) {
//                           return _buildPropertyCard(
//                             context,
//                             snapshot.data![index],
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.pushNamed(context, '/add_property');
//         },
//         backgroundColor: _primaryColor,
//         elevation: 4,
//         child: const Icon(Icons.add, size: 32, color: Colors.white),
//       ),
//     );
//   }
// }





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
  String _filterStatus = 'semua'; // 'semua', 'aktif', 'nonaktif'
  
  // Skema Warna
  final Color _primaryColor = const Color(0xFF2F9F20); 
  final Color _primaryDarkColor = const Color(0xFF247F17);
  final Color _backgroundColor = const Color(0xFFF8F9FA);
  final Color _textPrimaryColor = const Color(0xFF212529);
  final Color _textSecondaryColor = const Color(0xFF495057);
  final Color _textHintColor = const Color(0xFF6C757D);
  
  // Gaya Teks
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
      final response = await ApiClient().get('${Constants.baseUrl}/properties/all');
      log('Response API: ${response.toString()}');

      if (response == null || response['data'] == null) {
        throw Exception('Respon API tidak valid');
      }

      if (response['data'] is! List) {
        throw Exception('Format data tidak valid');
      }

      setState(() {
        _propertiesFuture = Future.value(response['data'] as List<dynamic>);
      });
    } catch (e) {
      log('Error memuat properti: $e');
      setState(() {
        _errorMessage = 'Gagal memuat data properti. Silakan coba lagi.';
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
      property['status'] = propertyData['isDeleted'] == false ? 'aktif' : 'nonaktif';
    }
    property['price'] = double.tryParse(property['price']?.toString() ?? '0') ?? 0.0;
    return property;
  }

  Future<void> _togglePropertyStatus(int propertyId, bool isActive) async {
    try {
      setState(() => _isLoading = true);
      
      final String endpoint = isActive 
          ? '${Constants.baseUrl}/properties/$propertyId/deactivate'
          : '${Constants.baseUrl}/properties/$propertyId/reactivate';
      
      final response = await ApiClient().post(endpoint);
      
      if (response != null && response['message'] != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message']),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        
        _loadProperties();
      } else {
        throw Exception('Gagal memperbarui status properti');
      }
    } catch (e) {
      log('Error mengubah status properti: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _showToggleStatusConfirmation(int propertyId, bool isActive) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isActive ? 'Nonaktifkan Properti' : 'Aktifkan Properti'),
        content: Text(
          isActive 
              ? 'Apakah Anda yakin ingin menonaktifkan properti ini? Properti tidak akan muncul di pencarian.'
              : 'Apakah Anda yakin ingin mengaktifkan kembali properti ini?'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: isActive ? Colors.red : Colors.green,
            ),
            child: Text(isActive ? 'Nonaktifkan' : 'Aktifkan'),
          ),
        ],
      ),
    );
    
    if (result == true) {
      await _togglePropertyStatus(propertyId, isActive);
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Properti'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Semua Properti'),
              value: 'semua',
              groupValue: _filterStatus,
              onChanged: (value) {
                setState(() {
                  _filterStatus = value!;
                });
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Properti Aktif'),
              value: 'aktif',
              groupValue: _filterStatus,
              onChanged: (value) {
                setState(() {
                  _filterStatus = value!;
                });
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Properti Nonaktif'),
              value: 'nonaktif',
              groupValue: _filterStatus,
              onChanged: (value) {
                setState(() {
                  _filterStatus = value!;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  List<dynamic> _filterProperties(List<dynamic> properties) {
    if (_filterStatus == 'semua') {
      return properties;
    }
    
    return properties.where((property) {
      final bool isActive = property['isDeleted'] == false;
      return _filterStatus == 'aktif' ? isActive : !isActive;
    }).toList();
  }

  Widget _buildPropertyCard(BuildContext context, dynamic propertyData) {
    final property = _parseProperty(propertyData);
    final bool isActive = property['status'] == 'aktif';
    
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
        onToggleStatus: () {
          _showToggleStatusConfirmation(property['id'], isActive);
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
            'Belum Ada Properti',
            style: _headlineSmallStyle.copyWith(
              color: _textSecondaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Mulai dengan menambahkan properti pertama Anda',
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
                  'Tambah Properti Baru',
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
          'Manajemen Properti',
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
              // Implementasi fungsi pencarian
            },
            tooltip: 'Cari',
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, size: 28, color: Colors.white),
            onPressed: _showFilterDialog,
            tooltip: 'Filter',
          ),
          IconButton(
            icon: const Icon(Icons.refresh, size: 28, color: Colors.white),
            onPressed: _loadProperties,
            tooltip: 'Segarkan',
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
                          'Coba Lagi',
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
                                'Terjadi kesalahan: ${snapshot.error}',
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
                                  'Ulangi',
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

                      final filteredProperties = _filterProperties(snapshot.data!);

                      if (filteredProperties.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.filter_alt_off,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Tidak ada properti ${_filterStatus == "aktif" ? "aktif" : "nonaktif"} yang ditemukan',
                                style: _bodyMediumStyle,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        controller: _scrollController,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 100),
                        itemCount: filteredProperties.length,
                        itemBuilder: (context, index) {
                          return _buildPropertyCard(
                            context,
                            filteredProperties[index],
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