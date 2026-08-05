abstract class AnalyticsClient {
  //User onboarding
  Future<void> trackUserOnboarding();
  Future<void> trackUserOnboardingStep(String step);
  
  // User Authentication Events
  Future<void> trackUserLogin();
  Future<void> trackUserLogout();
  Future<void> trackUserRegistration();

  // Investment Related Events
  Future<void> trackInvestmentCreated();
  Future<void> trackInvestmentUpdated();
  Future<void> trackInvestmentDeleted();
  Future<void> trackPortfolioViewed(String portfolioType);
  Future<void> trackInvestmentCalculatorUsed(String portfolioType);

  // Smart Basket Events
  Future<void> trackSmartBasketCreated();
  Future<void> trackSmartBasketUpdated();
  Future<void> trackSmartBasketDeleted();
  Future<void> trackSmartBasketPerformanceViewed(String basketId);

  // Navigation Events
  Future<void> trackScreenView(String screenName);
  Future<void> trackFeatureUsed(String featureName);

  // Notification Events
  Future<void> trackNotificationReceived();
  Future<void> trackNotificationOpened();
  Future<void> trackNotificationPermissionChanged(bool granted);

  // Error Events
  Future<void> trackError(String errorType, String errorMessage);

  // Custom Event
  Future<void> trackCustomEvent(
    String eventName, {
    Map<String, dynamic>? parameters,
  });
}
