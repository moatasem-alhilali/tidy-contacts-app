// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:hive_manager/design-system-package/siolla_design_system.dart';
// import 'package:hive_manager/src/core/services/services_location.dart';
// import 'package:hive_manager/src/core/utils/logger.dart';

// /// Enhanced map location picker widget with advanced features
// class DisplayMapLocationWidget extends StatefulWidget {
//   const DisplayMapLocationWidget({
//     required this.onLocationSelected,
//     super.key,
//     this.initialLocation,
//     this.showSearchBar = true,
//     this.showConfirmButton = true,
//     this.confirmButtonText = 'تأكيد الموقع',
//     this.searchHintText = 'البحث عن مكان...',
//     this.zoomLevel = 15.0,
//     this.mapType = MapType.normal,
//     this.enableMyLocation = true,
//     this.enableIndoorView = true,
//     this.enableTraffic = false,
//     this.enableBuildings = true,
//     this.enable3D = false,
//     this.onConfirm,
//   });

//   /// Initial location to display on the map
//   final LatLng? initialLocation;

//   /// Callback when location is selected
//   final ValueChanged<LocationData> onLocationSelected;

//   /// Whether to show the search bar
//   final bool showSearchBar;

//   /// Whether to show the confirm button
//   final bool showConfirmButton;

//   /// Text for the confirm button
//   final String confirmButtonText;

//   /// Hint text for the search field
//   final String searchHintText;

//   /// Initial zoom level for the map
//   final double zoomLevel;

//   /// Type of map to display
//   final MapType mapType;

//   /// Whether to enable my location button
//   final bool enableMyLocation;

//   /// Whether to enable indoor view
//   final bool enableIndoorView;

//   /// Whether to show traffic information
//   final bool enableTraffic;

//   /// Whether to show 3D buildings
//   final bool enableBuildings;

//   /// Whether to enable 3D view
//   final bool enable3D;

//   /// Optional callback when confirm button is pressed
//   /// If not provided, will call onLocationSelected and pop navigator
//   final VoidCallback? onConfirm;

//   @override
//   State<DisplayMapLocationWidget> createState() =>
//       _DisplayMapLocationWidgetState();
// }

// class _DisplayMapLocationWidgetState extends State<DisplayMapLocationWidget>
//     with TickerProviderStateMixin {
//   late final MapController _mapController;
//   late final SearchController _searchController;
//   late final FocusNode _searchFocusNode;
//   late final AnimationController _animationController;
//   late final Animation<double> _slideAnimation;

//   GoogleMapController? _googleMapController;
//   CameraPosition? _cameraPosition;
//   Set<Marker> _markers = {};
//   Placemark? _currentPlacemark;
//   String _currentAddress = '';
//   bool _isLoading = false;
//   bool _isSearching = false;
//   String _searchQuery = '';
//   Timer? _debounceTimer;

//   // Animation values
//   final double _bottomSheetHeight = 0;
//   bool _isBottomSheetExpanded = false;

//   @override
//   void initState() {
//     super.initState();
//     _mapController = MapController();
//     _searchController = SearchController();
//     _searchFocusNode = FocusNode();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//     _slideAnimation = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );

//     _searchFocusNode.addListener(_handleSearchFocusChange);

//     _initializeMap();
//   }

//   @override
//   void dispose() {
//     _searchFocusNode.removeListener(_handleSearchFocusChange);
//     _searchFocusNode.dispose();
//     _animationController.dispose();
//     _debounceTimer?.cancel();
//     _googleMapController?.dispose();
//     super.dispose();
//   }

//   void _handleSearchFocusChange() {
//     if (!mounted) return;
//     setState(() {});
//   }

//   /// Initialize the map with initial position
//   Future<void> _initializeMap() async {
//     if (!mounted) return;
//     setState(() => _isLoading = true);

//     try {
//       var initialPosition = const LatLng(15.3694, 44.1910); // Default fallback

//       if (widget.initialLocation != null) {
//         initialPosition = widget.initialLocation!;
//       } else {
//         // Get current location
//         final locationResult = await ServicesLocation.instance
//             .determinePosition();
//         locationResult.fold(
//           (error) {
//             _showErrorSnackBar('فشل في الحصول على الموقع: ${error.message}');
//             // Keep default fallback location
//           },
//           (position) {
//             initialPosition = LatLng(position.latitude, position.longitude);
//           },
//         );
//       }

//       _cameraPosition = CameraPosition(
//         target: initialPosition,
//         zoom: widget.zoomLevel,
//         tilt: widget.enable3D ? 45.0 : 0.0,
//       );

//       _updateMarker(initialPosition);
//       await _getAddressFromCoordinates(initialPosition);
//     } catch (e) {
//       logger.e('Error initializing map: $e');
//       _showErrorSnackBar('خطأ في تهيئة الخريطة');
//       // Set fallback camera position
//       _cameraPosition = CameraPosition(
//         target: const LatLng(15.3694, 44.1910),
//         zoom: widget.zoomLevel,
//         tilt: widget.enable3D ? 45.0 : 0.0,
//       );
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }

//   /// Update marker on the map
//   void _updateMarker(LatLng position) {
//     setState(() {
//       _markers = {
//         Marker(
//           markerId: const MarkerId('selected_location'),
//           position: position,
//           draggable: true,
//           onDragEnd: _onMarkerDragEnd,
//           icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//           infoWindow: InfoWindow(
//             title: 'الموقع المحدد',
//             snippet: _currentAddress.isNotEmpty
//                 ? _currentAddress
//                 : 'جاري تحديد العنوان...',
//           ),
//           onTap: _expandBottomSheet,
//         ),
//       };
//     });
//   }

//   /// Handle marker drag end
//   Future<void> _onMarkerDragEnd(LatLng newPosition) async {
//     await _updateLocation(newPosition);
//   }

//   /// Update location and get address
//   Future<void> _updateLocation(LatLng position) async {
//     if (!mounted) return;
//     setState(() => _isLoading = true);

//     try {
//       await _getAddressFromCoordinates(position);

//       // Animate camera to new position
//       if (_googleMapController != null) {
//         await _googleMapController!.animateCamera(
//           CameraUpdate.newLatLng(position),
//         );
//       }
//     } catch (e) {
//       logger.e('Error updating location: $e');
//       _showErrorSnackBar('خطأ في تحديث الموقع');
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }

//   /// Get address from coordinates using reverse geocoding
//   Future<void> _getAddressFromCoordinates(LatLng position) async {
//     try {
//       final placemarks = await placemarkFromCoordinates(
//         position.latitude,
//         position.longitude,
//       );

//       if (placemarks.isNotEmpty) {
//         final placemark = placemarks.first;
//         setState(() {
//           _currentPlacemark = placemark;
//           _currentAddress = _formatAddress(placemark);
//         });
//       }
//     } catch (e) {
//       logger.e('Error getting address: $e');
//       setState(() {
//         _currentPlacemark = null;
//         _currentAddress = 'غير متوفر';
//       });
//     }
//   }

//   /// Format address from placemark
//   String _formatAddress(Placemark placemark) {
//     final parts = <String>[];

//     if ((placemark.street?.isNotEmpty ?? false) == true) {
//       parts.add(placemark.street!);
//     }
//     if ((placemark.subLocality?.isNotEmpty ?? false) == true) {
//       parts.add(placemark.subLocality!);
//     }
//     if ((placemark.locality?.isNotEmpty ?? false) == true) {
//       parts.add(placemark.locality!);
//     }
//     if ((placemark.administrativeArea?.isNotEmpty ?? false) == true) {
//       parts.add(placemark.administrativeArea!);
//     }
//     if ((placemark.country?.isNotEmpty ?? false) == true) {
//       parts.add(placemark.country!);
//     }

//     return parts.join(', ');
//   }

//   /// Handle map tap
//   void _onMapTap(LatLng position) {
//     _updateLocation(position);
//   }

//   /// Handle search suggestions
//   Future<List<Map<String, dynamic>>> _getSearchSuggestions(String query) async {
//     if (query.isEmpty) return [];

//     try {
//       if (mounted) {
//         setState(() => _isSearching = true);
//       }

//       final locations = await locationFromAddress(query);
//       final suggestions = <Map<String, dynamic>>[];

//       for (final location in locations.take(5)) {
//         final placemarks = await placemarkFromCoordinates(
//           location.latitude,
//           location.longitude,
//         );

//         if (placemarks.isNotEmpty) {
//           final placemark = placemarks.first;
//           final title = _formatAddress(placemark);

//           suggestions.add({
//             'title': title,
//             'latitude': location.latitude,
//             'longitude': location.longitude,
//             'placemark': placemark,
//           });
//         }
//       }

//       return suggestions;
//     } catch (e) {
//       logger.e('Error getting search suggestions: $e');
//       return [];
//     } finally {
//       if (mounted) {
//         setState(() => _isSearching = false);
//       }
//     }
//   }

//   /// Handle search suggestion selection
//   Future<void> _onSuggestionSelected(Map<String, dynamic> suggestion) async {
//     final position = LatLng(
//       suggestion['latitude'] as double,
//       suggestion['longitude'] as double,
//     );

//     await _updateLocation(position);

//     // Animate camera to selected location
//     if (_googleMapController != null) {
//       await _googleMapController!.animateCamera(
//         CameraUpdate.newLatLngZoom(position, widget.zoomLevel),
//       );
//     }

//     _searchFocusNode.unfocus();
//   }

//   /// Expand bottom sheet
//   void _expandBottomSheet() {
//     setState(() => _isBottomSheetExpanded = true);
//     _animationController.forward();
//   }

//   /// Collapse bottom sheet
//   void _collapseBottomSheet() {
//     setState(() => _isBottomSheetExpanded = false);
//     _animationController.reverse();
//   }

//   /// Confirm location selection
//   void _confirmLocation() {
//     if (_currentPlacemark != null) {
//       final locationData = LocationData(
//         latitude: _markers.first.position.latitude,
//         longitude: _markers.first.position.longitude,
//         address: _currentAddress,
//         placemark: _currentPlacemark!,
//       );

//       widget.onLocationSelected(locationData);

//       // If custom confirm callback is provided, use it; otherwise pop navigator
//       if (widget.onConfirm != null) {
//         widget.onConfirm!();
//       } else {
//         Navigator.of(context).pop();
//       }
//     }
//   }

//   /// Show error snackbar
//   void _showErrorSnackBar(String message) {
//     if (!mounted) return;

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: TextWidget(message),
//         backgroundColor: Colors.red,
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }

//   /// Get current location
//   Future<void> _getCurrentLocation() async {
//     if (!mounted) return;
//     setState(() => _isLoading = true);

//     try {
//       final locationResult = await ServicesLocation.instance
//           .determinePosition();
//       await locationResult.fold(
//         (error) {
//           _showErrorSnackBar(
//             'فشل في الحصول على الموقع الحالي: ${error.message}',
//           );
//         },
//         (position) async {
//           final newPosition = LatLng(position.latitude, position.longitude);
//           await _updateLocation(newPosition);

//           if (_googleMapController != null) {
//             await _googleMapController!.animateCamera(
//               CameraUpdate.newLatLngZoom(newPosition, widget.zoomLevel),
//             );
//           }
//         },
//       );
//     } catch (e) {
//       logger.e('Error getting current location: $e');
//       _showErrorSnackBar('خطأ في الحصول على الموقع الحالي');
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_cameraPosition == null) {
//       return Scaffold(
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const CircularProgressIndicator(),
//               const SizedBox(height: 16),
//               TextWidget(
//                 'جاري تحميل الخريطة...',
//                 style: context.textStyles.bodyMedium.copyWith(
//                   color: context.colors.onPrimary,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     return Scaffold(
//       body: Stack(
//         children: [
//           // Google Map
//           GoogleMap(
//             initialCameraPosition: _cameraPosition!,
//             onMapCreated: (controller) {
//               _googleMapController = controller;
//             },
//             markers: _markers,
//             onTap: _onMapTap,
//             myLocationEnabled: widget.enableMyLocation,
//             myLocationButtonEnabled: widget.enableMyLocation,
//             indoorViewEnabled: widget.enableIndoorView,
//             trafficEnabled: widget.enableTraffic,
//             buildingsEnabled: widget.enableBuildings,
//             mapType: widget.mapType,
//             zoomControlsEnabled: false,
//             mapToolbarEnabled: false,
//             onCameraMove: (position) {
//               // Update camera position
//               _cameraPosition = position;
//             },
//           ),

//           // Top App Bar
//           _buildTopAppBar(),

//           // Bottom Sheet
//           _buildBottomSheet(),

//           // Loading Overlay
//           if (_isLoading)
//             ColoredBox(
//               color: Colors.black26,
//               child: Center(
//                 child: Card(
//                   child: Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         CircularProgressIndicator(
//                           color: context.colors.onPrimary,
//                         ),
//                         const SizedBox(height: 16),
//                         TextWidget(
//                           'جاري تحديث الموقع...',
//                           style: context.textStyles.bodyMedium.copyWith(
//                             color: context.colors.onPrimary,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   /// Build top app bar with search and actions
//   Widget _buildTopAppBar() {
//     return Positioned(
//       top: MediaQuery.of(context).padding.top + 10,
//       left: 16,
//       right: 16,
//       child: Container(
//         decoration: BoxDecoration(
//           color: context.colors.primaryContainer,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: context.colors.onSecondary.withOpacity(0.1),
//               blurRadius: 10,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             // Search Bar
//             if (widget.showSearchBar) ...[
//               Expanded(
//                 child: TypeAheadField<Map<String, dynamic>>(
//                   controller: _searchController,
//                   focusNode: _searchFocusNode,
//                   builder: (context, controller, focusNode) {
//                     return TextField(
//                       controller: controller,
//                       focusNode: focusNode,
//                       style: context.textStyles.bodyMedium.copyWith(
//                         color: context.colors.onPrimary,
//                       ),

//                       decoration: InputDecoration(
//                         hintText: widget.searchHintText,
//                         border: InputBorder.none,
//                         hintStyle: context.textStyles.bodyMedium.copyWith(
//                           color: context.colors.onPrimary,
//                         ),
//                         // prefix: const CircleWidget(),
//                         // prefixIcon: const CircleWidget(),
//                         contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 12,
//                         ),
//                       ),
//                       onChanged: (value) {
//                         _searchQuery = value;
//                         _debounceTimer?.cancel();
//                         _debounceTimer = Timer(
//                           const Duration(milliseconds: 500),
//                           () => setState(() {}),
//                         );
//                       },
//                     );
//                   },
//                   loadingBuilder: (context) => Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Center(
//                       child: CircularProgressIndicator(
//                         color: context.colors.onPrimary,
//                       ),
//                     ),
//                   ),
//                   errorBuilder: (context, error) => Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: TextWidget(
//                       'خطأ في البحث',
//                       style: context.textStyles.bodyMedium.copyWith(
//                         color: context.colors.onPrimary,
//                       ),
//                     ),
//                   ),
//                   emptyBuilder: (context) => Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: TextWidget(
//                       'لا توجد نتائج',
//                       style: context.textStyles.bodyMedium.copyWith(
//                         color: context.colors.onPrimary,
//                       ),
//                     ),
//                   ),
//                   suggestionsCallback: _getSearchSuggestions,
//                   itemBuilder: (context, suggestion) {
//                     return ListTile(
//                       leading: const Icon(Icons.location_on),
//                       title: TextWidget(
//                         suggestion['title'] as String,
//                         style: context.textStyles.bodyMedium.copyWith(
//                           color: context.colors.onPrimary,
//                         ),
//                       ),
//                       subtitle: TextWidget(
//                         '${suggestion['latitude'].toStringAsFixed(4)}, '
//                         '${suggestion['longitude'].toStringAsFixed(4)}',
//                         style: context.textStyles.bodyMedium.copyWith(
//                           color: context.colors.onPrimary,
//                         ),
//                       ),
//                     );
//                   },
//                   onSelected: _onSuggestionSelected,
//                 ),
//               ),
//             ],

//             // Current Location Button
//             if (widget.enableMyLocation)
//               IconButton(
//                 onPressed: _getCurrentLocation,
//                 icon: Icon(
//                   Icons.my_location,
//                   color: context.colors.onSecondary,
//                 ),
//                 tooltip: 'موقعي الحالي',
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// Build bottom sheet with location details
//   Widget _buildBottomSheet() {
//     final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

//     if (_searchFocusNode.hasFocus || keyboardVisible) {
//       return const SizedBox.shrink();
//     }

//     return Positioned(
//       bottom: 0,
//       left: 0,
//       right: 0,
//       child: AnimatedBuilder(
//         animation: _slideAnimation,
//         builder: (context, child) {
//           return Transform.translate(
//             offset: Offset(0, 100 * (1 - _slideAnimation.value)),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: context.colors.primaryContainer,
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(20),
//                   topRight: Radius.circular(20),
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: context.colors.onSecondary.withOpacity(0.1),
//                     blurRadius: 10,
//                     offset: const Offset(0, -2),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // Drag Handle
//                   Container(
//                     margin: const EdgeInsets.only(top: 8),
//                     width: 40,
//                     height: 4,
//                     decoration: BoxDecoration(
//                       color: context.colors.onSecondary.withOpacity(0.3),
//                       borderRadius: BorderRadius.circular(2),
//                     ),
//                   ),

//                   // Location Details
//                   Padding(
//                     padding: const EdgeInsets.all(20),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Title
//                         Row(
//                           children: [
//                             const Icon(Icons.location_on, color: Colors.red),
//                             const SizedBox(width: 8),
//                             Expanded(
//                               child: Text(
//                                 'الموقع المحدد',
//                                 style: context.textStyles.titleLarge.copyWith(
//                                   color: context.colors.onPrimary,
//                                 ),
//                               ),
//                             ),
//                             IconButton(
//                               onPressed: _isBottomSheetExpanded
//                                   ? _collapseBottomSheet
//                                   : _expandBottomSheet,
//                               icon: Icon(
//                                 _isBottomSheetExpanded
//                                     ? Icons.keyboard_arrow_down
//                                     : Icons.keyboard_arrow_up,
//                               ),
//                             ),
//                           ],
//                         ),

//                         const SizedBox(height: 16),

//                         // Address
//                         if (_currentAddress.isNotEmpty) ...[
//                           TextWidget(
//                             'العنوان:',
//                             style: context.textStyles.titleMedium.copyWith(
//                               color: context.colors.onPrimary,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Container(
//                             padding: const EdgeInsets.all(12),
//                             decoration: BoxDecoration(
//                               color: context.colors.onSecondary.withOpacity(
//                                 0.1,
//                               ),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Row(
//                               children: [
//                                 Expanded(
//                                   child: Text(
//                                     _currentAddress,
//                                     style: context.textStyles.bodyMedium
//                                         .copyWith(
//                                           color: context.colors.onPrimary,
//                                         ),
//                                   ),
//                                 ),
//                                 IconButton(
//                                   onPressed: () {
//                                     Clipboard.setData(
//                                       ClipboardData(text: _currentAddress),
//                                     );
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       const SnackBar(
//                                         content: Text('تم نسخ العنوان'),
//                                         duration: Duration(seconds: 1),
//                                       ),
//                                     );
//                                   },
//                                   icon: const Icon(Icons.copy),
//                                   tooltip: 'نسخ العنوان',
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],

//                         // Coordinates
//                         const SizedBox(height: 16),
//                         TextWidget(
//                           'الإحداثيات:',
//                           style: context.textStyles.titleMedium.copyWith(
//                             color: context.colors.onPrimary,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Container(
//                           padding: const EdgeInsets.all(12),
//                           decoration: BoxDecoration(
//                             color: context.colors.onSecondary.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     TextWidget(
//                                       'خط العرض: ${_markers.first.position.latitude.toStringAsFixed(6)}',
//                                       style: context.textStyles.bodyMedium
//                                           .copyWith(
//                                             color: context.colors.onPrimary,
//                                           ),
//                                     ),
//                                     TextWidget(
//                                       'خط الطول: ${_markers.first.position.longitude.toStringAsFixed(6)}',
//                                       style: context.textStyles.bodyMedium
//                                           .copyWith(
//                                             color: context.colors.onPrimary,
//                                           ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               IconButton(
//                                 onPressed: () {
//                                   final coords =
//                                       '${_markers.first.position.latitude}, ${_markers.first.position.longitude}';
//                                   Clipboard.setData(
//                                     ClipboardData(text: coords),
//                                   );
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(
//                                       content: Text('تم نسخ الإحداثيات'),
//                                       duration: Duration(seconds: 1),
//                                     ),
//                                   );
//                                 },
//                                 icon: const Icon(Icons.copy),
//                                 tooltip: 'نسخ الإحداثيات',
//                               ),
//                             ],
//                           ),
//                         ),

//                         // Confirm Button
//                         if (widget.showConfirmButton) ...[
//                           const SizedBox(height: 24),
//                           SizedBox(
//                             width: double.infinity,
//                             child: ButtonProgressStateWidget(
//                               text: widget.confirmButtonText,
//                               onPressed: _currentPlacemark != null
//                                   ? _confirmLocation
//                                   : null,
//                               width: 90.w,
//                             ),
//                           ),
//                         ],
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// /// Controller for map operations
// class MapController {
//   void dispose() {
//     // Cleanup resources if needed
//   }
// }

// /// Controller for search operations
// class SearchController extends TextEditingController {}

// /// Data class for location information
// class LocationData {
//   const LocationData({
//     required this.latitude,
//     required this.longitude,
//     required this.address,
//     required this.placemark,
//   });

//   final double latitude;
//   final double longitude;
//   final String address;
//   final Placemark placemark;

//   LatLng get latLng => LatLng(latitude, longitude);

//   @override
//   String toString() {
//     return 'LocationData(lat: $latitude, lng: $longitude, address: $address)';
//   }
// }
