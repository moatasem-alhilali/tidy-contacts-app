// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:hive_manager/design-system-package/siolla_design_system.dart';
// import 'package:hive_manager/src/core/services/services_location.dart';

// /// Enhanced map location picker widget with advanced search and selection features
// class GetLocationFromMapWidget extends StatefulWidget {
//   const GetLocationFromMapWidget({
//     super.key,
//     this.initialLocation,
//     this.onLocationSelected,
//     this.showSearchBar = true,
//     this.showConfirmButton = true,
//     this.confirmButtonText = 'حفظ الموقع',
//     this.searchHintText = 'البحث عن مكان...',
//     this.zoomLevel = 15.0,
//     this.mapType = MapType.normal,
//     this.enableMyLocation = true,
//     this.enableIndoorView = true,
//     this.enableTraffic = false,
//     this.enableBuildings = true,
//     this.enable3D = false,
//     this.height = 0.6,
//     this.width = 0.8,
//     this.showLocationDetails = true,
//     this.enableDraggableMarker = true,
//     this.markerColor = BitmapDescriptor.hueRed,
//     this.showCoordinates = true,
//     this.showAddress = true,
//   });

//   /// Initial location to display on the map
//   final LatLng? initialLocation;

//   /// Callback when location is selected
//   final Function(LocationResult)? onLocationSelected;

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

//   /// Height as a fraction of screen height
//   final double height;

//   /// Width as a fraction of screen width
//   final double width;

//   /// Whether to show location details
//   final bool showLocationDetails;

//   /// Whether to enable draggable marker
//   final bool enableDraggableMarker;

//   /// Color of the marker
//   final double markerColor;

//   /// Whether to show coordinates
//   final bool showCoordinates;

//   /// Whether to show address
//   final bool showAddress;

//   @override
//   State<GetLocationFromMapWidget> createState() =>
//       _GetLocationFromMapWidgetState();
// }

// class _GetLocationFromMapWidgetState extends State<GetLocationFromMapWidget>
//     with TickerProviderStateMixin {
//   late final AnimationController _animationController;
//   late final Animation<double> _fadeAnimation;
//   late final AnimationController _searchAnimationController;
//   late final Animation<double> _searchSlideAnimation;

//   GoogleMapController? _googleMapController;
//   CameraPosition? _cameraPosition;
//   Set<Marker> _markers = {};
//   Placemark? _currentPlacemark;
//   String _currentAddress = '';
//   bool _isLoading = false;
//   bool _isSearching = false;
//   String _searchQuery = '';
//   Timer? _debounceTimer;
//   bool _isSearchBarVisible = true;

//   // Current selected location
//   LatLng _selectedLocation = const LatLng(15.3361449, 44.2212541);

//   // Search controller
//   final TextEditingController _searchController = TextEditingController();
//   final FocusNode _searchFocusNode = FocusNode();

//   @override
//   void initState() {
//     super.initState();
//     _initializeAnimations();
//     _initializeMap();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     _searchAnimationController.dispose();
//     _debounceTimer?.cancel();
//     _searchController.dispose();
//     _searchFocusNode.dispose();
//     _googleMapController?.dispose();
//     super.dispose();
//   }

//   /// Initialize animations
//   void _initializeAnimations() {
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 500),
//       vsync: this,
//     );

//     _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );

//     _searchAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );

//     _searchSlideAnimation = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(
//         parent: _searchAnimationController,
//         curve: Curves.easeInOut,
//       ),
//     );

//     _animationController.forward();
//   }

//   /// Initialize the map with initial position
//   Future<void> _initializeMap() async {
//     setState(() => _isLoading = true);

//     try {
//       var initialPosition = const LatLng(
//         15.3361449,
//         44.2212541,
//       ); // Default fallback

//       if (widget.initialLocation != null) {
//         initialPosition = widget.initialLocation!;
//       } else {
//         // Try to get current location
//         final locationResult = await ServicesLocation.instance
//             .determinePosition();
//         locationResult.fold(
//           (error) {
//             logger.w('Failed to get current location: ${error.message}');
//             // Keep default fallback location
//           },
//           (position) {
//             initialPosition = LatLng(position.latitude, position.longitude);
//           },
//         );
//       }

//       _selectedLocation = initialPosition;
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
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   /// Update marker on the map
//   void _updateMarker(LatLng position) {
//     setState(() {
//       _markers = {
//         Marker(
//           markerId: const MarkerId('selected_location'),
//           position: position,
//           draggable: widget.enableDraggableMarker,
//           onDragEnd: widget.enableDraggableMarker ? _onMarkerDragEnd : null,
//           icon: BitmapDescriptor.defaultMarkerWithHue(widget.markerColor),
//           infoWindow: InfoWindow(
//             title: 'الموقع المحدد',
//             snippet: _currentAddress.isNotEmpty
//                 ? _currentAddress
//                 : 'جاري تحديد العنوان...',
//           ),
//           onTap: _showLocationDetails,
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
//     setState(() => _isLoading = true);

//     try {
//       _selectedLocation = position;
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
//       setState(() => _isLoading = false);
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

//     if (placemark.street?.isNotEmpty ?? false) {
//       parts.add(placemark.street!);
//     }
//     if (placemark.subLocality?.isNotEmpty ?? false) {
//       parts.add(placemark.subLocality!);
//     }
//     if (placemark.locality?.isNotEmpty ?? false) {
//       parts.add(placemark.locality!);
//     }
//     if (placemark.administrativeArea?.isNotEmpty ?? false) {
//       parts.add(placemark.administrativeArea!);
//     }
//     if (placemark.country?.isNotEmpty ?? false) {
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
//       setState(() => _isSearching = true);

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
//       setState(() => _isSearching = false);
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

//     // Hide search bar after selection
//     _hideSearchBar();
//   }

//   /// Show search bar
//   void _showSearchBar() {
//     setState(() => _isSearchBarVisible = true);
//     _searchAnimationController.forward();
//     _searchFocusNode.requestFocus();
//   }

//   /// Hide search bar
//   void _hideSearchBar() {
//     _searchAnimationController.reverse().then((_) {
//       setState(() => _isSearchBarVisible = false);
//     });
//     _searchFocusNode.unfocus();
//   }

//   /// Toggle search bar visibility
//   void _toggleSearchBar() {
//     if (_isSearchBarVisible) {
//       _hideSearchBar();
//     } else {
//       _showSearchBar();
//     }
//   }

//   /// Show location details
//   void _showLocationDetails() {
//     if (widget.showLocationDetails) {
//       showModalBottomSheet(
//         context: context,
//         builder: (context) => _buildLocationDetailsSheet(),
//         isScrollControlled: true,
//         backgroundColor: Colors.transparent,
//       );
//     }
//   }

//   /// Confirm location selection
//   void _confirmLocation() {
//     final locationResult = LocationResult(
//       latitude: _selectedLocation.latitude,
//       longitude: _selectedLocation.longitude,
//       address: _currentAddress,
//       placemark: _currentPlacemark,
//     );

//     if (widget.onLocationSelected != null) {
//       widget.onLocationSelected!(locationResult);
//     } else {
//       Navigator.of(context).pop(locationResult);
//     }
//   }

//   /// Show error snackbar
//   void _showErrorSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.red,
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }

//   /// Get current location
//   Future<void> _getCurrentLocation() async {
//     setState(() => _isLoading = true);

//     try {
//       final locationResult = await ServicesLocation.instance
//           .determinePosition();
//       locationResult.fold(
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
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;

//     return FadeTransition(
//       opacity: _fadeAnimation,
//       child: SizedBox(
//         height: screenHeight * widget.height,
//         width: screenWidth * widget.width,
//         child: Column(
//           children: [
//             // Map Container
//             Expanded(
//               child: Stack(
//                 children: [
//                   // Google Map
//                   _buildGoogleMap(),

//                   // Search Bar
//                   if (widget.showSearchBar) _buildSearchBar(),

//                   // Map Controls
//                   _buildMapControls(),

//                   // Loading Overlay
//                   if (_isLoading) _buildLoadingOverlay(),
//                 ],
//               ),
//             ),

//             // Action Buttons
//             if (widget.showConfirmButton) _buildActionButtons(),
//           ],
//         ),
//       ),
//     );
//   }

//   /// Build Google Map widget
//   Widget _buildGoogleMap() {
//     if (_cameraPosition == null) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     return GoogleMap(
//       initialCameraPosition: _cameraPosition!,
//       onMapCreated: (controller) {
//         _googleMapController = controller;
//       },
//       markers: _markers,
//       onTap: _onMapTap,
//       myLocationEnabled: widget.enableMyLocation,
//       myLocationButtonEnabled: false, // We'll add custom button
//       indoorViewEnabled: widget.enableIndoorView,
//       trafficEnabled: widget.enableTraffic,
//       buildingsEnabled: widget.enableBuildings,
//       mapType: widget.mapType,
//       zoomControlsEnabled: false,
//       mapToolbarEnabled: false,
//       onCameraMove: (position) {
//         // Update camera position
//         _cameraPosition = position;
//       },
//     );
//   }

//   /// Build search bar
//   Widget _buildSearchBar() {
//     return AnimatedBuilder(
//       animation: _searchSlideAnimation,
//       builder: (context, child) {
//         return Positioned(
//           top: 16,
//           left: 16,
//           right: 16,
//           child: Transform.translate(
//             offset: Offset(0, -50 * (1 - _searchSlideAnimation.value)),
//             child: AnimatedOpacity(
//               opacity: _isSearchBarVisible ? 1.0 : 0.0,
//               duration: const Duration(milliseconds: 200),
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 10,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: TypeAheadField<Map<String, dynamic>>(
//                   controller: _searchController,
//                   focusNode: _searchFocusNode,
//                   builder: (context, controller, focusNode) {
//                     return TextField(
//                       controller: controller,
//                       focusNode: focusNode,
//                       decoration: InputDecoration(
//                         hintText: widget.searchHintText,
//                         border: InputBorder.none,
//                         contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 12,
//                         ),
//                         suffixIcon: IconButton(
//                           onPressed: _toggleSearchBar,
//                           icon: const Icon(Icons.close),
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
//                   loadingBuilder: (context) => const Padding(
//                     padding: EdgeInsets.all(16),
//                     child: Center(child: CircularProgressIndicator()),
//                   ),
//                   errorBuilder: (context, error) => const Padding(
//                     padding: EdgeInsets.all(16),
//                     child: Text('خطأ في البحث'),
//                   ),
//                   emptyBuilder: (context) => const Padding(
//                     padding: EdgeInsets.all(16),
//                     child: Text('لا توجد نتائج'),
//                   ),
//                   suggestionsCallback: _getSearchSuggestions,
//                   itemBuilder: (context, suggestion) {
//                     return ListTile(
//                       leading: const Icon(Icons.location_on),
//                       title: Text(suggestion['title'] as String),
//                       subtitle: Text(
//                         '${suggestion['latitude'].toStringAsFixed(4)}, '
//                         '${suggestion['longitude'].toStringAsFixed(4)}',
//                       ),
//                     );
//                   },
//                   onSelected: _onSuggestionSelected,
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   /// Build map controls
//   Widget _buildMapControls() {
//     return Positioned(
//       top: 16,
//       right: 16,
//       child: Column(
//         children: [
//           // Search Toggle Button
//           if (widget.showSearchBar)
//             FloatingActionButton.small(
//               onPressed: _toggleSearchBar,
//               backgroundColor: Colors.white,
//               child: Icon(
//                 _isSearchBarVisible ? Icons.search : Icons.search_off,
//                 color: Colors.grey[700],
//               ),
//             ),

//           const SizedBox(height: 8),

//           // Current Location Button
//           if (widget.enableMyLocation)
//             FloatingActionButton.small(
//               onPressed: _getCurrentLocation,
//               backgroundColor: Colors.white,
//               child: Icon(Icons.my_location, color: Colors.grey[700]),
//             ),
//         ],
//       ),
//     );
//   }

//   /// Build loading overlay
//   Widget _buildLoadingOverlay() {
//     return const ColoredBox(
//       color: Colors.black26,
//       child: Center(
//         child: Card(
//           child: Padding(
//             padding: EdgeInsets.all(16),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 CircularProgressIndicator(),
//                 SizedBox(height: 16),
//                 Text('جاري تحديث الموقع...'),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   /// Build action buttons
//   Widget _buildActionButtons() {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Row(
//         children: [
//           // Location Info Button
//           if (widget.showLocationDetails)
//             Expanded(
//               child: OutlinedButton.icon(
//                 onPressed: _showLocationDetails,
//                 icon: const Icon(Icons.info_outline),
//                 label: const Text('تفاصيل الموقع'),
//               ),
//             ),

//           if (widget.showLocationDetails) const SizedBox(width: 16),

//           // Confirm Button
//           Expanded(
//             child: ButtonProgressStateWidget(
//               text: widget.confirmButtonText,
//               onPressed: _confirmLocation,
//               height: 5.h,
//               width: 90.w,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   /// Build location details bottom sheet
//   Widget _buildLocationDetailsSheet() {
//     return Container(
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(20),
//           topRight: Radius.circular(20),
//         ),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // Drag Handle
//           Container(
//             margin: const EdgeInsets.only(top: 8),
//             width: 40,
//             height: 4,
//             decoration: BoxDecoration(
//               color: Colors.grey[300],
//               borderRadius: BorderRadius.circular(2),
//             ),
//           ),

//           // Location Details
//           Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Title
//                 Row(
//                   children: [
//                     const Icon(Icons.location_on, color: Colors.red),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: Text(
//                         'تفاصيل الموقع',
//                         style: Theme.of(context).textTheme.titleLarge,
//                       ),
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 16),

//                 // Address
//                 if (widget.showAddress && _currentAddress.isNotEmpty) ...[
//                   Text(
//                     'العنوان:',
//                     style: Theme.of(context).textTheme.titleMedium,
//                   ),
//                   const SizedBox(height: 8),
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.grey[100],
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: Text(
//                             _currentAddress,
//                             style: Theme.of(context).textTheme.bodyMedium,
//                           ),
//                         ),
//                         IconButton(
//                           onPressed: () {
//                             Clipboard.setData(
//                               ClipboardData(text: _currentAddress),
//                             );
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content: Text('تم نسخ العنوان'),
//                                 duration: Duration(seconds: 1),
//                               ),
//                             );
//                           },
//                           icon: const Icon(Icons.copy),
//                           tooltip: 'نسخ العنوان',
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],

//                 // Coordinates
//                 if (widget.showCoordinates) ...[
//                   const SizedBox(height: 16),
//                   Text(
//                     'الإحداثيات:',
//                     style: Theme.of(context).textTheme.titleMedium,
//                   ),
//                   const SizedBox(height: 8),
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.grey[100],
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'خط العرض: ${_selectedLocation.latitude.toStringAsFixed(6)}',
//                                 style: Theme.of(context).textTheme.bodyMedium,
//                               ),
//                               Text(
//                                 'خط الطول: ${_selectedLocation.longitude.toStringAsFixed(6)}',
//                                 style: Theme.of(context).textTheme.bodyMedium,
//                               ),
//                             ],
//                           ),
//                         ),
//                         IconButton(
//                           onPressed: () {
//                             final coords =
//                                 '${_selectedLocation.latitude}, ${_selectedLocation.longitude}';
//                             Clipboard.setData(ClipboardData(text: coords));
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content: Text('تم نسخ الإحداثيات'),
//                                 duration: Duration(seconds: 1),
//                               ),
//                             );
//                           },
//                           icon: const Icon(Icons.copy),
//                           tooltip: 'نسخ الإحداثيات',
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// /// Data class for location result
// class LocationResult {
//   const LocationResult({
//     required this.latitude,
//     required this.longitude,
//     this.address,
//     this.placemark,
//   });

//   final double latitude;
//   final double longitude;
//   final String? address;
//   final Placemark? placemark;

//   LatLng get latLng => LatLng(latitude, longitude);

//   @override
//   String toString() {
//     return 'LocationResult(lat: $latitude, lng: $longitude, address: $address)';
//   }
// }
