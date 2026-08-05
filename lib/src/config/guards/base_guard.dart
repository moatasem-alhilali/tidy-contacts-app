import 'package:auto_route/auto_route.dart';


/// A base class that provides shared functionality for route guards.
abstract class BaseGuard extends AutoRouteGuard {
  // final onboardingRoutes = onboarding.Routes().routes.map((e) => e.name);

  Set<String> get commonUnprotectedRoutes => {
     
      };

  Set<String> get authUnprotectedRoutes => {
    
      };

  // final failureUnprotectedRoutes =
  //     onboarding.Routes().routes.map((e) => e.name).toList();

  /// Checks if a route is unprotected.
  bool isAuthUnprotectedRoute(String routeName) {
    return authUnprotectedRoutes.contains(routeName);
  }

  /// Checks if a route is unprotected for mandatory updates.
  bool isUnprotectedRouteForMandatoryUpdate(String routeName) {
    return commonUnprotectedRoutes.contains(routeName);
  }
}
