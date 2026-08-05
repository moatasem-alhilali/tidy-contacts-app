// --- Firebase disabled (not used currently) ---
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:hive_manager/src/core/services/monitoring/firebase_analytics_client.dart';
// ------------------------------------------------
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_manager/src/core/services/monitoring/analytics_client.dart';
import 'package:hive_manager/src/core/services/monitoring/logger_analytics_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analytics_facade.g.dart';

@Riverpod(keepAlive: true)
AnalyticsFacade analyticsFacade(Ref ref) {
  return AnalyticsFacade([
    if (!kReleaseMode) const LoggerAnalyticsClient(),
    // Firebase disabled: FirebaseAnalyticsClient(FirebaseAnalytics.instance),
  ]);
}

// https://refactoring.guru/design-patterns/facade
class AnalyticsFacade implements AnalyticsClient {
  const AnalyticsFacade(this.clients);
  final List<AnalyticsClient> clients;

  @override
  Future<void> trackUserOnboarding() {
    try {
      return _dispatch(
        (c) => c.trackUserOnboarding(),
      );
    } catch (_) {
      return Future.value();
    }
  }

  @override
  Future<void> trackUserOnboardingStep(String step) => _dispatch(
        (c) => c.trackUserOnboardingStep(step),
      );

  @override
  Future<void> trackUserLogin() => _dispatch(
        (c) => c.trackUserLogin(),
      );

  @override
  Future<void> trackUserLogout() => _dispatch(
        (c) => c.trackUserLogout(),
      );

  @override
  Future<void> trackUserRegistration() => _dispatch(
        (c) => c.trackUserRegistration(),
      );

  @override
  Future<void> trackInvestmentCreated() => _dispatch(
        (c) => c.trackInvestmentCreated(),
      );

  @override
  Future<void> trackInvestmentUpdated() => _dispatch(
        (c) => c.trackInvestmentUpdated(),
      );

  @override
  Future<void> trackInvestmentDeleted() => _dispatch(
        (c) => c.trackInvestmentDeleted(),
      );

  @override
  Future<void> trackPortfolioViewed(String portfolioType) => _dispatch(
        (c) => c.trackPortfolioViewed(portfolioType),
      );

  @override
  Future<void> trackInvestmentCalculatorUsed(String portfolioType) => _dispatch(
        (c) => c.trackInvestmentCalculatorUsed(portfolioType),
      );

  @override
  Future<void> trackSmartBasketCreated() => _dispatch(
        (c) => c.trackSmartBasketCreated(),
      );

  @override
  Future<void> trackSmartBasketUpdated() => _dispatch(
        (c) => c.trackSmartBasketUpdated(),
      );

  @override
  Future<void> trackSmartBasketDeleted() => _dispatch(
        (c) => c.trackSmartBasketDeleted(),
      );

  @override
  Future<void> trackSmartBasketPerformanceViewed(String basketId) => _dispatch(
        (c) => c.trackSmartBasketPerformanceViewed(basketId),
      );

  @override
  Future<void> trackScreenView(String screenName) => _dispatch(
        (c) => c.trackScreenView(screenName),
      );

  @override
  Future<void> trackFeatureUsed(String featureName) => _dispatch(
        (c) => c.trackFeatureUsed(featureName),
      );

  @override
  Future<void> trackNotificationReceived() => _dispatch(
        (c) => c.trackNotificationReceived(),
      );

  @override
  Future<void> trackNotificationOpened() => _dispatch(
        (c) => c.trackNotificationOpened(),
      );

  @override
  Future<void> trackNotificationPermissionChanged(bool granted) => _dispatch(
        (c) => c.trackNotificationPermissionChanged(granted),
      );

  @override
  Future<void> trackError(String errorType, String errorMessage) => _dispatch(
        (c) => c.trackError(errorType, errorMessage),
      );

  @override
  Future<void> trackCustomEvent(
    String eventName, {
    Map<String, dynamic>? parameters,
  }) =>
      _dispatch(
        (c) => c.trackCustomEvent(eventName, parameters: parameters),
      );

  Future<void> _dispatch(
    Future<void> Function(AnalyticsClient client) work,
  ) async {
    for (final client in clients) {
      await work(client);
    }
  }
}
