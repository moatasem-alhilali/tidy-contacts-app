// --- Firebase disabled (not used currently) — entire file commented out ---
/*
import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_manager/src/core/services/monitoring/analytics_client.dart';

class FirebaseAnalyticsClient implements AnalyticsClient {
  const FirebaseAnalyticsClient(this._analytics);
  final FirebaseAnalytics _analytics;

  Future<void> track(
    String name, {
    Map<String, Object> params = const {},
  }) async {
    try {
      if (kReleaseMode) {
        await _analytics.logEvent(name: name, parameters: params);
      } else {
        log('$name $params', name: 'Event');
      }
    } catch (_) {}
  }

  @override
  Future<void> trackUserOnboarding() async {
    await track('user_onboarding');
  }

  @override
  Future<void> trackUserOnboardingStep(String step) async {
    await track('user_onboarding_step', params: {'step': step});
  }

  @override
  Future<void> trackUserLogin() async {
    await track('user_login');
  }

  @override
  Future<void> trackUserLogout() async {
    await track('user_logout');
  }

  @override
  Future<void> trackUserRegistration() async {
    await track('user_registration');
  }

  @override
  Future<void> trackInvestmentCreated() async {
    await track('investment_created');
  }

  @override
  Future<void> trackInvestmentUpdated() async {
    await track('investment_updated');
  }

  @override
  Future<void> trackInvestmentDeleted() async {
    await track('investment_deleted');
  }

  @override
  Future<void> trackPortfolioViewed(String portfolioType) async {
    await track('portfolio_viewed', params: {'portfolio_type': portfolioType});
  }

  @override
  Future<void> trackInvestmentCalculatorUsed(String portfolioType) async {
    await track(
      'investment_calculator_used',
      params: {'portfolio_type': portfolioType},
    );
  }

  @override
  Future<void> trackSmartBasketCreated() async {
    await track('smart_basket_created');
  }

  @override
  Future<void> trackSmartBasketUpdated() async {
    await track('smart_basket_updated');
  }

  @override
  Future<void> trackSmartBasketDeleted() async {
    await track('smart_basket_deleted');
  }

  @override
  Future<void> trackSmartBasketPerformanceViewed(String basketId) async {
    await track(
      'smart_basket_performance_viewed',
      params: {'basket_id': basketId},
    );
  }

  @override
  Future<void> trackScreenView(String screenName) async {
    await _analytics.logScreenView(screenName: screenName);
  }

  @override
  Future<void> trackFeatureUsed(String featureName) async {
    await track('feature_used', params: {'feature_name': featureName});
  }

  @override
  Future<void> trackNotificationReceived() async {
    await track('notification_received');
  }

  @override
  Future<void> trackNotificationOpened() async {
    await track('notification_opened');
  }

  @override
  Future<void> trackNotificationPermissionChanged(bool granted) async {
    await track(
      'notification_permission_changed',
      params: {'granted': granted},
    );
  }

  @override
  Future<void> trackError(String errorType, String errorMessage) async {
    await track(
      'error_occurred',
      params: {
        'error_type': errorType,
        'error_message': errorMessage,
      },
    );
  }

  @override
  Future<void> trackCustomEvent(
    String eventName, {
    Map<String, dynamic>? parameters,
  }) async {
    await track(eventName, params: parameters?.cast<String, Object>() ?? {});
  }
}
*/
