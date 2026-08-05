class ApiKeys {
  ApiKeys._();

  static const String authorization = 'Authorization';
  static const String bearer = 'Bearer';
  static const String api = '/api/v1/';
  static const String contentType = 'Content-Type';
  static const String accept = 'Accept';
  static const String applicationJson = 'application/json';
  static const String acceptLanguage = 'Accept-Language';
  static const String acceptCurrency = 'X-Currency-Code';
  static const String companyName = 'X-Company-Name';

  /// services names

  /// for change to custom port
  static const String serviceNameHeader = 'service-name';
  static const String authService = 'auth.';
  static const String profileService = 'profile.';
  static const String kycService = 'kyc.';
}
