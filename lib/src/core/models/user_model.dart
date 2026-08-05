import 'package:hive_manager/env/env.dart';
import 'package:hive_manager/gen/assets.gen.dart';
import 'package:hive_manager/src/core/models/company_info_model.dart';
import 'package:hive_manager/src/core/models/employee_model.dart';
import 'package:hive_manager/src/core/models/iso_system_model.dart';

class UserModel {
  const UserModel({
    this.id,
    this.email,
    this.type,
    this.profile,
    this.phoneNumber,
    this.lang,
    this.subscription,
    this.subscriptionExpireDate,
    this.parentId,
    this.emailVerifiedAt,
    this.otpCode,
    this.otpExpiresAt,
    this.otpAttempts,
    this.twoFactorSecret,
    this.twoFactorRecoveryCodes,
    this.twoFactorConfirmedAt,
    this.google2faEnabled,
    this.isActive,
    this.completedTours,
    this.showTours,
    this.lastTourAt,
    this.sessionId,
    this.lastLoginAt,
    this.lastLoginIp,
    this.createdAt,
    this.updatedAt,
    this.employee,
    this.companyName,
    this.companyInfo,
    this.clientIsoSystems,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: (json['id'] as num?)?.toInt(),
    email: json['email'] as String?,
    type: json['type'] as String?,
    profile: json['profile'],
    phoneNumber: json['phone_number'] as String?,
    lang: json['lang'] as String?,
    subscription: json['subscription'],
    subscriptionExpireDate: json['subscription_expire_date'] as String?,
    parentId: (json['parent_id'] as num?)?.toInt(),
    emailVerifiedAt: json['email_verified_at'] as String?,
    otpCode: json['otp_code'] as String?,
    otpExpiresAt: json['otp_expires_at'] as String?,
    otpAttempts: (json['otp_attempts'] as num?)?.toInt(),
    twoFactorSecret: json['two_factor_secret'] as String?,
    twoFactorRecoveryCodes: json['two_factor_recovery_codes'] as String?,
    twoFactorConfirmedAt: json['two_factor_confirmed_at'] as String?,
    google2faEnabled: json['google2fa_enabled'] as bool?,
    isActive: (json['is_active'] as num?)?.toInt(),
    completedTours: json['completed_tours'] as String?,
    showTours: json['show_tours'] as bool?,
    lastTourAt: json['last_tour_at'] as String?,
    sessionId: json['session_id'] as String?,
    lastLoginAt: json['last_login_at'] as String?,
    lastLoginIp: json['last_login_ip'] as String?,
    createdAt: json['created_at'] as String?,
    updatedAt: json['updated_at'] as String?,
    employee: json['employee'] == null
        ? null
        : EmployeeModel.fromJson(json['employee'] as Map<String, dynamic>),
    companyName: json['company_name'] as String?,
    companyInfo: json['company_info'] == null
        ? null
        : CompanyInfoModel.fromJson(
            json['company_info'] as Map<String, dynamic>,
          ),
    clientIsoSystems: (json['client_iso_systems'] as List<dynamic>?)
        ?.map((e) => IsoSystemModel.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
  factory UserModel.fromJsonApi(
    Map<String, dynamic> json, {
    required Map<String, dynamic> nestedData,
  }) => UserModel(
    id: (json['id'] as num?)?.toInt(),
    email: json['email'] as String?,
    type: json['type'] as String?,
    profile: json['profile'],
    phoneNumber: json['phone_number'] as String?,
    lang: json['lang'] as String?,
    subscription: json['subscription'],
    subscriptionExpireDate: json['subscription_expire_date'] as String?,
    parentId: (json['parent_id'] as num?)?.toInt(),
    emailVerifiedAt: json['email_verified_at'] as String?,
    otpCode: json['otp_code'] as String?,
    otpExpiresAt: json['otp_expires_at'] as String?,
    otpAttempts: (json['otp_attempts'] as num?)?.toInt(),
    twoFactorSecret: json['two_factor_secret'] as String?,
    twoFactorRecoveryCodes: json['two_factor_recovery_codes'] as String?,
    twoFactorConfirmedAt: json['two_factor_confirmed_at'] as String?,
    google2faEnabled: json['google2fa_enabled'] as bool?,
    isActive: (json['is_active'] as num?)?.toInt(),
    completedTours: json['completed_tours'] as String?,
    showTours: json['show_tours'] as bool?,
    lastTourAt: json['last_tour_at'] as String?,
    sessionId: json['session_id'] as String?,
    lastLoginAt: json['last_login_at'] as String?,
    lastLoginIp: json['last_login_ip'] as String?,
    createdAt: json['created_at'] as String?,
    updatedAt: json['updated_at'] as String?,
    employee: json['employee'] == null
        ? null
        : EmployeeModel.fromJson(json['employee'] as Map<String, dynamic>),
    companyName: json['company_name'] as String?,
    companyInfo: nestedData['company_info'] == null
        ? null
        : CompanyInfoModel.fromJson(
            nestedData['company_info'] as Map<String, dynamic>,
          ),
    clientIsoSystems: (nestedData['client_iso_systems'] as List<dynamic>?)
        ?.map((e) => IsoSystemModel.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  final int? id;
  final String? email;
  final String? type;
  final dynamic profile; // Can be null or object

  final String? phoneNumber;

  final String? lang;
  final dynamic subscription; // Can be null or object

  final String? subscriptionExpireDate;

  final int? parentId;

  final String? emailVerifiedAt;

  final String? otpCode;

  final String? otpExpiresAt;

  final int? otpAttempts;

  final String? twoFactorSecret;

  final String? twoFactorRecoveryCodes;

  final String? twoFactorConfirmedAt;

  final bool? google2faEnabled;

  final int? isActive;

  final String? completedTours;

  final bool? showTours;

  final String? lastTourAt;

  final String? sessionId;

  final String? lastLoginAt;

  final String? lastLoginIp;

  final String? createdAt;

  final String? updatedAt;

  final EmployeeModel? employee;
  final String? companyName;

  final CompanyInfoModel? companyInfo;

  final List<IsoSystemModel>? clientIsoSystems;
  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'email': email,
    'type': type,
    'profile': profile,
    'phone_number': phoneNumber,
    'lang': lang,
    'subscription': subscription,
    'subscription_expire_date': subscriptionExpireDate,
    'parent_id': parentId,
    'email_verified_at': emailVerifiedAt,
    'otp_code': otpCode,
    'otp_expires_at': otpExpiresAt,
    'otp_attempts': otpAttempts,
    'two_factor_secret': twoFactorSecret,
    'two_factor_recovery_codes': twoFactorRecoveryCodes,
    'two_factor_confirmed_at': twoFactorConfirmedAt,
    'google2fa_enabled': google2faEnabled,
    'is_active': isActive,
    'completed_tours': completedTours,
    'show_tours': showTours,
    'last_tour_at': lastTourAt,
    'session_id': sessionId,
    'last_login_at': lastLoginAt,
    'last_login_ip': lastLoginIp,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'name': name,
    'employee': employee,
    'company_name': companyName,
    'company_info': companyInfo,
    'client_iso_systems': clientIsoSystems,
  };

  String? get profileImage {
    return companyInfo?.avatar;
  }

  String? get name {
    return employee?.nameAr;
  }

  String get imageUrl {
    var res = '';

    if (profileImage == null) res = Assets.images.logo.path;
    if (profileImage != null && profileImage!.startsWith('https')) {
      res = profileImage!;
    }

    if (profileImage != null && !profileImage!.startsWith('https')) {
      res = '${Env.BASE}/$profileImage';
    }

    return res;
  }

  String? get phone => companyInfo?.phone;
}
