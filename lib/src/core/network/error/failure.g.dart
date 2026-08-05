// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'failure.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Failure _$FailureFromJson(Map<String, dynamic> json) => Failure(
  (json['statusCode'] as num).toInt(),
  json['message'] as String,
  $enumDecodeNullable(
        _$FailureCodeEnumMap,
        json['code'],
        unknownValue: FailureCode.UNKNOWN,
      ) ??
      FailureCode.UNKNOWN,
);

Map<String, dynamic> _$FailureToJson(Failure instance) => <String, dynamic>{
  'statusCode': instance.statusCode,
  'message': instance.message,
  'code': _$FailureCodeEnumMap[instance.code]!,
};

const _$FailureCodeEnumMap = {
  FailureCode.FND_001: 'FND_001',
  FailureCode.FND_002: 'FND_002',
  FailureCode.KYC_001: 'KYC_001',
  FailureCode.KYC_002: 'KYC_002',
  FailureCode.KYC_003: 'KYC_003',
  FailureCode.USR_001: 'USR_001',
  FailureCode.USR_002: 'USR_002',
  FailureCode.ACC_001: 'ACC_001',
  FailureCode.WLT_001: 'WLT_001',
  FailureCode.WTHD_001: 'WTHD_001',
  FailureCode.SEC_001: 'SEC_001',
  FailureCode.SEC_002: 'SEC_002',
  FailureCode.INV_001: 'INV_001',
  FailureCode.INV_002: 'INV_002',
  FailureCode.SEC_003: 'SEC_003',
  FailureCode.SEC_004: 'SEC_004',
  FailureCode.SEC_005: 'SEC_005',
  FailureCode.SEC_006: 'SEC_006',
  FailureCode.INV_003: 'INV_003',
  FailureCode.FND_004: 'FND_004',
  FailureCode.FND_005: 'FND_005',
  FailureCode.INV_004: 'INV_004',
  FailureCode.INV_005: 'INV_005',
  FailureCode.INV_006: 'INV_006',
  FailureCode.WLT_002: 'WLT_002',
  FailureCode.DEV_001: 'DEV_001',
  FailureCode.WTHD_002: 'WTHD_002',
  FailureCode.INV_007: 'INV_007',
  FailureCode.INV_008: 'INV_008',
  FailureCode.INV_009: 'INV_009',
  FailureCode.BAL_001: 'BAL_001',
  FailureCode.KYC_004: 'KYC_004',
  FailureCode.KYC_005: 'KYC_005',
  FailureCode.WTHD_003: 'WTHD_003',
  FailureCode.ACC_002: 'ACC_002',
  FailureCode.ACC_003: 'ACC_003',
  FailureCode.UNKNOWN: 'UNKNOWN',
};
