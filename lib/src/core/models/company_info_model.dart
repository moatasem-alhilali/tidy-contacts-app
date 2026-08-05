import 'package:json_annotation/json_annotation.dart';

part 'company_info_model.g.dart';

@JsonSerializable()
class CompanyInfoModel {
  const CompanyInfoModel({
    this.id,
    this.clientCode,
    this.companyId,
    this.countryId,
    this.cityId,
    this.companyType,
    this.responsiblePersonName,
    this.subscriptionId,
    this.subscriptionExpireDate,
    this.dbName,
    this.dbStatus,
    this.username,
    this.isoSystems,
    this.companySeal,
    this.nameEn,
    this.nameAr,
    this.email,
    this.phone,
    this.addressAr,
    this.addressEn,
    this.status,
    this.setupStatus,
    this.setupProgress,
    this.setupMessage,
    this.setupSteps,
    this.setupStartedAt,
    this.setupCompletedAt,
    this.setupError,
    this.avatar,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.subscription,
    this.invoices,
  });

  factory CompanyInfoModel.fromJson(Map<String, dynamic> json) =>
      _$CompanyInfoModelFromJson(json);

  final int? id;

  @JsonKey(name: 'client_code')
  final String? clientCode;

  @JsonKey(name: 'company_id')
  final int? companyId;

  @JsonKey(name: 'country_id')
  final int? countryId;

  @JsonKey(name: 'city_id')
  final int? cityId;

  @JsonKey(name: 'company_type')
  final String? companyType;

  @JsonKey(name: 'responsible_person_name')
  final String? responsiblePersonName;

  @JsonKey(name: 'subscription_id')
  final int? subscriptionId;

  @JsonKey(name: 'subscription_expire_date')
  final String? subscriptionExpireDate;

  @JsonKey(name: 'db_name')
  final String? dbName;

  @JsonKey(name: 'db_status')
  final String? dbStatus;

  final String? username;

  @JsonKey(name: 'iso_systems')
  final String? isoSystems;

  @JsonKey(name: 'company_seal')
  final String? companySeal;

  @JsonKey(name: 'name_en')
  final String? nameEn;

  @JsonKey(name: 'name_ar')
  final String? nameAr;

  final String? email;
  final String? phone;

  @JsonKey(name: 'address_ar')
  final String? addressAr;

  @JsonKey(name: 'address_en')
  final String? addressEn;

  final bool? status;

  @JsonKey(name: 'setup_status')
  final String? setupStatus;

  @JsonKey(name: 'setup_progress')
  final int? setupProgress;

  @JsonKey(name: 'setup_message')
  final String? setupMessage;

  @JsonKey(name: 'setup_steps')
  final String? setupSteps;

  @JsonKey(name: 'setup_started_at')
  final String? setupStartedAt;

  @JsonKey(name: 'setup_completed_at')
  final String? setupCompletedAt;

  @JsonKey(name: 'setup_error')
  final String? setupError;

  final String? avatar;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  @JsonKey(name: 'deleted_at')
  final String? deletedAt;

  final SubscriptionModel? subscription;
  final List<InvoiceModel>? invoices;

  Map<String, dynamic> toJson() => _$CompanyInfoModelToJson(this);
}

@JsonSerializable()
class SubscriptionModel {
  const SubscriptionModel({
    this.id,
    this.companyId,
    this.planId,
    this.planDetails,
    this.clientId,
    this.consultantId,
    this.startDate,
    this.endDate,
    this.status,
    this.previousSubscriptionId,
    this.changeType,
    this.price,
    this.maxUsers,
    this.storageSize,
    this.paymentStatus,
    this.paymentMethod,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionModelFromJson(json);

  final int? id;

  @JsonKey(name: 'company_id')
  final int? companyId;

  @JsonKey(name: 'plan_id')
  final int? planId;

  @JsonKey(name: 'plan_details')
  final String? planDetails;

  @JsonKey(name: 'client_id')
  final int? clientId;

  @JsonKey(name: 'consultant_id')
  final int? consultantId;

  @JsonKey(name: 'start_date')
  final String? startDate;

  @JsonKey(name: 'end_date')
  final String? endDate;

  final String? status;

  @JsonKey(name: 'previous_subscription_id')
  final int? previousSubscriptionId;

  @JsonKey(name: 'change_type')
  final String? changeType;

  final String? price;

  @JsonKey(name: 'max_users')
  final int? maxUsers;

  @JsonKey(name: 'storage_size')
  final String? storageSize;

  @JsonKey(name: 'payment_status')
  final String? paymentStatus;

  @JsonKey(name: 'payment_method')
  final String? paymentMethod;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  @JsonKey(name: 'deleted_at')
  final String? deletedAt;

  Map<String, dynamic> toJson() => _$SubscriptionModelToJson(this);
}

@JsonSerializable()
class InvoiceModel {
  const InvoiceModel({
    this.id,
    this.invoiceNumber,
    this.clientId,
    this.subscriptionId,
    this.amount,
    this.totalPaid,
    this.dueAmount,
    this.status,
    this.notes,
    this.dueDate,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) =>
      _$InvoiceModelFromJson(json);

  final int? id;

  @JsonKey(name: 'invoice_number')
  final String? invoiceNumber;

  @JsonKey(name: 'client_id')
  final int? clientId;

  @JsonKey(name: 'subscription_id')
  final int? subscriptionId;

  final String? amount;

  @JsonKey(name: 'total_paid')
  final String? totalPaid;

  @JsonKey(name: 'due_amount')
  final String? dueAmount;

  final String? status;
  final String? notes;

  @JsonKey(name: 'due_date')
  final String? dueDate;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  @JsonKey(name: 'deleted_at')
  final String? deletedAt;

  Map<String, dynamic> toJson() => _$InvoiceModelToJson(this);
}
