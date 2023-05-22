// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerIndividualItemData _$CustomerIndividualItemDataFromJson(
        Map<String, dynamic> json) =>
    CustomerIndividualItemData(
      json['field_id'] as String?,
      json['field_name'] as String?,
      json['field_label'] as String?,
      json['field_type'] as String?,
      json['field_validation'] as String?,
      json['field_validation_message'] as String?,
      json['field_maxlength'] as String?,
      json['field_hidden'] as String?,
      json['parent'] as String?,
      json['field_require'] as int?,
      json['field_set_value'],
      (json['field_datasource'] as List<dynamic>?)
          ?.map((e) => e as List<dynamic>)
          .toList(),
      json['field_special'] as String?,
      (json['field_set_value_datasource'] as List<dynamic>?)
          ?.map((e) => e as List<dynamic>)
          .toList(),
      json['field_value'] as String?,
      (json['products'] as List<dynamic>?)
          ?.map((e) => ProductItemContract.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CustomerIndividualItemDataToJson(
        CustomerIndividualItemData instance) =>
    <String, dynamic>{
      'field_id': instance.field_id,
      'field_name': instance.field_name,
      'field_label': instance.field_label,
      'field_type': instance.field_type,
      'field_validation': instance.field_validation,
      'field_validation_message': instance.field_validation_message,
      'field_maxlength': instance.field_maxlength,
      'field_hidden': instance.field_hidden,
      'parent': instance.parent,
      'field_require': instance.field_require,
      'field_set_value': instance.field_set_value,
      'field_datasource': instance.field_datasource,
      'field_set_value_datasource': instance.field_set_value_datasource,
      'field_special': instance.field_special,
      'field_value': instance.field_value,
      'products': instance.products,
    };

ChuKyResponse _$ChuKyResponseFromJson(Map<String, dynamic> json) =>
    ChuKyResponse(
      json['group_name'] as String?,
      (json['data'] as List<dynamic>?)
          ?.map((e) => ChuKyModelResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChuKyResponseToJson(ChuKyResponse instance) =>
    <String, dynamic>{
      'group_name': instance.group_name,
      'data': instance.data,
    };

ChuKyModelResponse _$ChuKyModelResponseFromJson(Map<String, dynamic> json) =>
    ChuKyModelResponse(
      json['doituongky'] as String?,
      json['nhanhienthi'] as String?,
      json['giatrimacdinh'] as String?,
      json['chuky'] as String?,
      json['id'] as String?,
    );

Map<String, dynamic> _$ChuKyModelResponseToJson(ChuKyModelResponse instance) =>
    <String, dynamic>{
      'doituongky': instance.doituongky,
      'nhanhienthi': instance.nhanhienthi,
      'giatrimacdinh': instance.giatrimacdinh,
      'chuky': instance.chuky,
      'id': instance.id,
    };

AddCustomerIndividualData _$AddCustomerIndividualDataFromJson(
        Map<String, dynamic> json) =>
    AddCustomerIndividualData(
      (json['data'] as List<dynamic>?)
          ?.map((e) =>
              CustomerIndividualItemData.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['group_name'] as String?,
      json['mup'] as int?,
    );

Map<String, dynamic> _$AddCustomerIndividualDataToJson(
        AddCustomerIndividualData instance) =>
    <String, dynamic>{
      'data': instance.data,
      'group_name': instance.group_name,
      'mup': instance.mup,
    };

ProductItemContract _$ProductItemContractFromJson(Map<String, dynamic> json) =>
    ProductItemContract(
      json['name_product'] as String?,
      json['price'] as String?,
      json['quantity'] as String?,
      json['vat'] as String?,
      json['vat_name'] as String?,
      json['unit'] as int?,
      json['unit_name'] as String?,
      json['id'] as int?,
      json['id_product'] as int?,
      SaleOff.fromJson(json['sale_off'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProductItemContractToJson(
        ProductItemContract instance) =>
    <String, dynamic>{
      'name_product': instance.name_product,
      'price': instance.price,
      'quantity': instance.quantity,
      'vat': instance.vat,
      'vat_name': instance.vat_name,
      'unit_name': instance.unit_name,
      'id': instance.id,
      'id_product': instance.id_product,
      'unit': instance.unit,
      'sale_off': instance.sale_off,
    };

SaleOff _$SaleOffFromJson(Map<String, dynamic> json) => SaleOff(
      json['value'] as String?,
      json['type'] as String?,
    );

Map<String, dynamic> _$SaleOffToJson(SaleOff instance) => <String, dynamic>{
      'value': instance.value,
      'type': instance.type,
    };

AddCustomerIndividual _$AddCustomerIndividualFromJson(
        Map<String, dynamic> json) =>
    AddCustomerIndividual(
      (json['data'] as List<dynamic>?)
          ?.map((e) =>
              AddCustomerIndividualData.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['chu_ky'] as List<dynamic>?)
          ?.map((e) => ChuKyResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['chuathanhtoan'] as num?)?.toDouble(),
    )
      ..success = json['success'] as bool?
      ..msg = json['msg'] as String?
      ..code = json['code'] as int?;

Map<String, dynamic> _$AddCustomerIndividualToJson(
        AddCustomerIndividual instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'code': instance.code,
      'data': instance.data,
      'chu_ky': instance.chu_ky,
      'chuathanhtoan': instance.chuathanhtoan,
    };
