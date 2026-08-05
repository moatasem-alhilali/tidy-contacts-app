import 'dart:async';
import 'dart:developer';

import 'package:hive_manager/src/core/services/monitoring/analytics_client.dart';

class LoggerAnalyticsClient implements AnalyticsClient {
  const LoggerAnalyticsClient();

  static const _name = 'Event';

  @override
  Future<void> trackNewAppHome() async {
    log('trackNewAppHome', name: _name);
  }

  @override
  Future<void> trackNewAppOnboarding() async {
    log('trackNewAppOnboarding', name: _name);
  }

  @override
  Future<void> trackAppCreated() async {
    log('trackAppCreated', name: _name);
  }

  @override
  Future<void> trackAppUpdated() async {
    log('trackAppUpdated', name: _name);
  }

  @override
  Future<void> trackAppDeleted() async {
    log('trackAppDeleted', name: _name);
  }

  @override
  Future<void> trackTaskCompleted(int completedCount) async {
    log('trackTaskCompleted(completedCount: $completedCount)', name: _name);
  }

  @override
  Future<void> trackUserOnboarding() async {
    log('trackUserOnboarding', name: _name);
  }

  @override
  Future<void> trackUserOnboardingStep(String step) async {
    log('trackUserOnboardingStep(step: $step)', name: _name);
  }

  @override
  Future<void> trackUserLogin() async {
    log('trackUserLogin', name: _name);
  }

  @override
  Future<void> trackUserLogout() async {
    log('trackUserLogout', name: _name);
  }

  @override
  Future<void> trackUserRegistration() async {
    log('trackUserRegistration', name: _name);
  }

  @override
  Future<void> trackInvestmentCreated() async {
    log('trackInvestmentCreated', name: _name);
  }

  @override
  Future<void> trackInvestmentUpdated() async {
    log('trackInvestmentUpdated', name: _name);
  }

  @override
  Future<void> trackInvestmentDeleted() async {
    log('trackInvestmentDeleted', name: _name);
  }

  @override
  Future<void> trackPortfolioViewed(String portfolioType) async {
    log('trackPortfolioViewed(portfolioType: $portfolioType)', name: _name);
  }

  @override
  Future<void> trackInvestmentCalculatorUsed(String portfolioType) async {
    log(
      'trackInvestmentCalculatorUsed(portfolioType: $portfolioType)',
      name: _name,
    );
  }

  @override
  Future<void> trackSmartBasketCreated() async {
    log('trackSmartBasketCreated', name: _name);
  }

  @override
  Future<void> trackSmartBasketUpdated() async {
    log('trackSmartBasketUpdated', name: _name);
  }

  @override
  Future<void> trackSmartBasketDeleted() async {
    log('trackSmartBasketDeleted', name: _name);
  }

  @override
  Future<void> trackSmartBasketPerformanceViewed(String basketId) async {
    log('trackSmartBasketPerformanceViewed(basketId: $basketId)', name: _name);
  }

  @override
  Future<void> trackScreenView(String screenName) async {
    log('trackScreenView(screenName: $screenName)', name: _name);
  }

  @override
  Future<void> trackFeatureUsed(String featureName) async {
    log('trackFeatureUsed(featureName: $featureName)', name: _name);
  }

  @override
  Future<void> trackNotificationReceived() async {
    log('trackNotificationReceived', name: _name);
  }

  @override
  Future<void> trackNotificationOpened() async {
    log('trackNotificationOpened', name: _name);
  }

  @override
  Future<void> trackNotificationPermissionChanged(bool granted) async {
    log('trackNotificationPermissionChanged(granted: $granted)', name: _name);
  }

  @override
  Future<void> trackError(String errorType, String errorMessage) async {
    log(
      'trackError(errorType: $errorType, errorMessage: $errorMessage)',
      name: _name,
    );
  }

  @override
  Future<void> trackCustomEvent(
    String eventName, {
    Map<String, dynamic>? parameters,
  }) async {
    log(
      'trackCustomEvent(eventName: $eventName, parameters: $parameters)',
      name: _name,
    );
  }
}
