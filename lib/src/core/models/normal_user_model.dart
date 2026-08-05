import 'package:hive_manager/src/core/models/employee_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'normal_user_model.g.dart';

@JsonSerializable(explicitToJson: true)
class NormalUserModel {
  const NormalUserModel({
    required this.id,
    required this.email,
    required this.type,
    this.profile,
    required this.phoneNumber,
    required this.lang,
    this.subscription,
    this.subscriptionExpireDate,
    required this.parentId,
    this.emailVerifiedAt,
    this.otpCode,
    this.otpExpiresAt,
    required this.otpAttempts,
    this.twoFactorSecret,
    this.twoFactorRecoveryCodes,
    this.twoFactorConfirmedAt,
    required this.google2faEnabled,
    required this.isActive,
    this.completedTours,
    required this.showTours,
    this.lastTourAt,
    required this.sessionId,
    this.lastLoginAt,
    this.lastLoginIp,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
    this.employee,
  });

  final int id;
  final String email;
  final String type;
  final String? profile;
  @JsonKey(name: 'phone_number')
  final String phoneNumber;
  final String lang;
  final String? subscription;
  @JsonKey(name: 'subscription_expire_date')
  final String? subscriptionExpireDate;
  @JsonKey(name: 'parent_id')
  final int parentId;
  @JsonKey(name: 'email_verified_at')
  final String? emailVerifiedAt;
  @JsonKey(name: 'otp_code')
  final String? otpCode;
  @JsonKey(name: 'otp_expires_at')
  final String? otpExpiresAt;
  @JsonKey(name: 'otp_attempts')
  final int otpAttempts;
  @JsonKey(name: 'two_factor_secret')
  final String? twoFactorSecret;
  @JsonKey(name: 'two_factor_recovery_codes')
  final String? twoFactorRecoveryCodes;
  @JsonKey(name: 'two_factor_confirmed_at')
  final String? twoFactorConfirmedAt;
  @JsonKey(name: 'google2fa_enabled')
  final bool google2faEnabled;
  @JsonKey(name: 'is_active')
  final int isActive;
  @JsonKey(name: 'completed_tours')
  final String? completedTours;
  @JsonKey(name: 'show_tours')
  final bool showTours;
  @JsonKey(name: 'last_tour_at')
  final String? lastTourAt;
  @JsonKey(name: 'session_id')
  final String sessionId;
  @JsonKey(name: 'last_login_at')
  final String? lastLoginAt;
  @JsonKey(name: 'last_login_ip')
  final String? lastLoginIp;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  final String name;
  final EmployeeModel? employee;

  factory NormalUserModel.fromJson(Map<String, dynamic> json) =>
      _$NormalUserModelFromJson(json);
  Map<String, dynamic> toJson() => _$NormalUserModelToJson(this);
}
