// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompanyInfoModel _$CompanyInfoModelFromJson(Map<String, dynamic> json) =>
    CompanyInfoModel(
      id: (json['id'] as num?)?.toInt(),
      clientCode: json['client_code'] as String?,
      companyId: (json['company_id'] as num?)?.toInt(),
      countryId: (json['country_id'] as num?)?.toInt(),
      cityId: (json['city_id'] as num?)?.toInt(),
      companyType: json['company_type'] as String?,
      responsiblePersonName: json['responsible_person_name'] as String?,
      subscriptionId: (json['subscription_id'] as num?)?.toInt(),
      subscriptionExpireDate: json['subscription_expire_date'] as String?,
      dbName: json['db_name'] as String?,
      dbStatus: json['db_status'] as String?,
      username: json['username'] as String?,
      isoSystems: json['iso_systems'] as String?,
      companySeal: json['company_seal'] as String?,
      nameEn: json['name_en'] as String?,
      nameAr: json['name_ar'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      addressAr: json['address_ar'] as String?,
      addressEn: json['address_en'] as String?,
      status: json['status'] as bool?,
      setupStatus: json['setup_status'] as String?,
      setupProgress: (json['setup_progress'] as num?)?.toInt(),
      setupMessage: json['setup_message'] as String?,
      setupSteps: json['setup_steps'] as String?,
      setupStartedAt: json['setup_started_at'] as String?,
      setupCompletedAt: json['setup_completed_at'] as String?,
      setupError: json['setup_error'] as String?,
      avatar: json['avatar'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      deletedAt: json['deleted_at'] as String?,
      subscription: json['subscription'] == null
          ? null
          : SubscriptionModel.fromJson(
              json['subscription'] as Map<String, dynamic>,
            ),
      invoices: (json['invoices'] as List<dynamic>?)
          ?.map((e) => InvoiceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CompanyInfoModelToJson(CompanyInfoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'client_code': instance.clientCode,
      'company_id': instance.companyId,
      'country_id': instance.countryId,
      'city_id': instance.cityId,
      'company_type': instance.companyType,
      'responsible_person_name': instance.responsiblePersonName,
      'subscription_id': instance.subscriptionId,
      'subscription_expire_date': instance.subscriptionExpireDate,
      'db_name': instance.dbName,
      'db_status': instance.dbStatus,
      'username': instance.username,
      'iso_systems': instance.isoSystems,
      'company_seal': instance.companySeal,
      'name_en': instance.nameEn,
      'name_ar': instance.nameAr,
      'email': instance.email,
      'phone': instance.phone,
      'address_ar': instance.addressAr,
      'address_en': instance.addressEn,
      'status': instance.status,
      'setup_status': instance.setupStatus,
      'setup_progress': instance.setupProgress,
      'setup_message': instance.setupMessage,
      'setup_steps': instance.setupSteps,
      'setup_started_at': instance.setupStartedAt,
      'setup_completed_at': instance.setupCompletedAt,
      'setup_error': instance.setupError,
      'avatar': instance.avatar,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'deleted_at': instance.deletedAt,
      'subscription': instance.subscription,
      'invoices': instance.invoices,
    };

SubscriptionModel _$SubscriptionModelFromJson(Map<String, dynamic> json) =>
    SubscriptionModel(
      id: (json['id'] as num?)?.toInt(),
      companyId: (json['company_id'] as num?)?.toInt(),
      planId: (json['plan_id'] as num?)?.toInt(),
      planDetails: json['plan_details'] as String?,
      clientId: (json['client_id'] as num?)?.toInt(),
      consultantId: (json['consultant_id'] as num?)?.toInt(),
      startDate: json['start_date'] as String?,
      endDate: json['end_date'] as String?,
      status: json['status'] as String?,
      previousSubscriptionId: (json['previous_subscription_id'] as num?)
          ?.toInt(),
      changeType: json['change_type'] as String?,
      price: json['price'] as String?,
      maxUsers: (json['max_users'] as num?)?.toInt(),
      storageSize: json['storage_size'] as String?,
      paymentStatus: json['payment_status'] as String?,
      paymentMethod: json['payment_method'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      deletedAt: json['deleted_at'] as String?,
    );

Map<String, dynamic> _$SubscriptionModelToJson(SubscriptionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'company_id': instance.companyId,
      'plan_id': instance.planId,
      'plan_details': instance.planDetails,
      'client_id': instance.clientId,
      'consultant_id': instance.consultantId,
      'start_date': instance.startDate,
      'end_date': instance.endDate,
      'status': instance.status,
      'previous_subscription_id': instance.previousSubscriptionId,
      'change_type': instance.changeType,
      'price': instance.price,
      'max_users': instance.maxUsers,
      'storage_size': instance.storageSize,
      'payment_status': instance.paymentStatus,
      'payment_method': instance.paymentMethod,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'deleted_at': instance.deletedAt,
    };

InvoiceModel _$InvoiceModelFromJson(Map<String, dynamic> json) => InvoiceModel(
  id: (json['id'] as num?)?.toInt(),
  invoiceNumber: json['invoice_number'] as String?,
  clientId: (json['client_id'] as num?)?.toInt(),
  subscriptionId: (json['subscription_id'] as num?)?.toInt(),
  amount: json['amount'] as String?,
  totalPaid: json['total_paid'] as String?,
  dueAmount: json['due_amount'] as String?,
  status: json['status'] as String?,
  notes: json['notes'] as String?,
  dueDate: json['due_date'] as String?,
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
  deletedAt: json['deleted_at'] as String?,
);

Map<String, dynamic> _$InvoiceModelToJson(InvoiceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'invoice_number': instance.invoiceNumber,
      'client_id': instance.clientId,
      'subscription_id': instance.subscriptionId,
      'amount': instance.amount,
      'total_paid': instance.totalPaid,
      'due_amount': instance.dueAmount,
      'status': instance.status,
      'notes': instance.notes,
      'due_date': instance.dueDate,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'deleted_at': instance.deletedAt,
    };
