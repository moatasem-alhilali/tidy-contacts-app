class ProtectedRoutes {
  ProtectedRoutes._();

  /// List of protected routes that require authentication
  static const List<String> _protectedRoutes = [
    'api/v1/cart',
    // Add more protected routes here as needed
  ];

  /// Check if a given path requires authentication
  static bool isProtectedRoute(String path) {
    // Remove leading slash if present
    final cleanPath = path.startsWith('/') ? path.substring(1) : path;

    // print('🔍 Checking if route is protected: "$cleanPath"');
    // print('🔍 Protected routes: $_protectedRoutes');

    // Check if the path matches any protected route
    for (final protectedRoute in _protectedRoutes) {
      // Check both the full protected route and just the endpoint part
      final endpointOnly = protectedRoute.replaceFirst('api/v1/', '');

      // print('🔍 Checking against: "$protectedRoute" and "$endpointOnly"');

      if (cleanPath.startsWith(protectedRoute) ||
          cleanPath.startsWith(endpointOnly)) {
        // print('✅ Route "$cleanPath" is PROTECTED (matched: "$protectedRoute")');
        return true;
      }
    }

    // print('❌ Route "$cleanPath" is NOT protected');
    return false;
  }

  /// Add a new protected route
  static void addProtectedRoute(String route) {
    if (!_protectedRoutes.contains(route)) {
      _protectedRoutes.add(route);
    }
  }

  /// Get all protected routes
  static List<String> get protectedRoutes =>
      List.unmodifiable(_protectedRoutes);
}
