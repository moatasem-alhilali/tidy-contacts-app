enum FailureCode {
  /// Funding is blocked
  FND_001,

  /// Withdraw blocked because there is pending funding
  FND_002,

  /// KYC is not verified
  KYC_001,

  /// Identity is expired
  KYC_002,

  /// User KYC not found
  KYC_003,

  /// Email is required
  USR_001,

  /// Phone is used by another identity
  USR_002,

  /// Account is in removed status processing
  ACC_001,

  /// Wallet locked
  WLT_001,

  /// Withdraw amount is greater than balance
  WTHD_001,

  /// Session expired
  SEC_001,

  /// Access is denied
  SEC_002,

  /// Investment account is closed
  INV_001,

  /// Investment account requires KYC document upload
  INV_002,

  /// Unauthorized
  SEC_003,

  /// Forbidden
  SEC_004,

  /// Not found
  SEC_005,

  /// Internal server error
  SEC_006,

  /// Investment account is not eligible
  INV_003,

  /// Insufficient amount to fund
  FND_004,

  /// Funding is temporarily blocked
  FND_005,

  /// Smart basket does not have investment account
  INV_004,

  /// Delete smart basket not enable if has investment amount
  INV_005,

  /// Exceed smartbasket number limit
  INV_006,

  /// Exceed wallet number limit
  WLT_002,

  /// Exceed device number limit
  DEV_001,

  /// Withdraw amount is greater than balance
  WTHD_002,

  /// Investments are blocked for users associated with a public company
  INV_007,

  /// Investments are blocked for users with disallowed affiliations
  INV_008,

  /// Investments are blocked for politically exposed persons
  INV_009,

  /// You dont have enough balance
  BAL_001,

  /// Phone number conflict with identity
  KYC_004,

  /// Identity not linked with phone number
  KYC_005,

  /// Withdraw blocked because it required at least 2 days from last funding
  WTHD_003,

  /// User account is blocked
  ACC_002,  
  
  /// User account deletion is not allowed if has money
  ACC_003,

  /// Unknown failure code
  UNKNOWN,
}
