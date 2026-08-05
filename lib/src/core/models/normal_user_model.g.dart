// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'normal_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NormalUserModel _$NormalUserModelFromJson(Map<String, dynamic> json) =>
    NormalUserModel(
      id: (json['id'] as num).toInt(),
      email: json['email'] as String,
      type: json['type'] as String,
      profile: json['profile'] as String?,
      phoneNumber: json['phone_number'] as String,
      lang: json['lang'] as String,
      subscription: json['subscription'] as String?,
      subscriptionExpireDate: json['subscription_expire_date'] as String?,
      parentId: (json['parent_id'] as num).toInt(),
      emailVerifiedAt: json['email_verified_at'] as String?,
      otpCode: json['otp_code'] as String?,
      otpExpiresAt: json['otp_expires_at'] as String?,
      otpAttempts: (json['otp_attempts'] as num).toInt(),
      twoFactorSecret: json['two_factor_secret'] as String?,
      twoFactorRecoveryCodes: json['two_factor_recovery_codes'] as String?,
      twoFactorConfirmedAt: json['two_factor_confirmed_at'] as String?,
      google2faEnabled: json['google2fa_enabled'] as bool,
      isActive: (json['is_active'] as num).toInt(),
      completedTours: json['completed_tours'] as String?,
      showTours: json['show_tours'] as bool,
      lastTourAt: json['last_tour_at'] as String?,
      sessionId: json['session_id'] as String,
      lastLoginAt: json['last_login_at'] as String?,
      lastLoginIp: json['last_login_ip'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      name: json['name'] as String,
      employee: json['employee'] == null
          ? null
          : EmployeeModel.fromJson(json['employee'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NormalUserModelToJson(NormalUserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'type': instance.type,
      'profile': instance.profile,
      'phone_number': instance.phoneNumber,
      'lang': instance.lang,
      'subscription': instance.subscription,
      'subscription_expire_date': instance.subscriptionExpireDate,
      'parent_id': instance.parentId,
      'email_verified_at': instance.emailVerifiedAt,
      'otp_code': instance.otpCode,
      'otp_expires_at': instance.otpExpiresAt,
      'otp_attempts': instance.otpAttempts,
      'two_factor_secret': instance.twoFactorSecret,
      'two_factor_recovery_codes': instance.twoFactorRecoveryCodes,
      'two_factor_confirmed_at': instance.twoFactorConfirmedAt,
      'google2fa_enabled': instance.google2faEnabled,
      'is_active': instance.isActive,
      'completed_tours': instance.completedTours,
      'show_tours': instance.showTours,
      'last_tour_at': instance.lastTourAt,
      'session_id': instance.sessionId,
      'last_login_at': instance.lastLoginAt,
      'last_login_ip': instance.lastLoginIp,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'name': instance.name,
      'employee': instance.employee?.toJson(),
    };
