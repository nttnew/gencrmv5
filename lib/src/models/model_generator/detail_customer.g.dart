// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail_customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerInfoData _$CustomerInfoDataFromJson(Map<String, dynamic> json) =>
    CustomerInfoData(
      json['group_name'] as String?,
      json['mup'] as int?,
      (json['data'] as List<dynamic>?)
          ?.map((e) => CustomerInfoItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CustomerInfoDataToJson(CustomerInfoData instance) =>
    <String, dynamic>{
      'group_name': instance.group_name,
      'mup': instance.mup,
      'data': instance.data,
    };

CustomerInfoItem _$CustomerInfoItemFromJson(Map<String, dynamic> json) =>
    CustomerInfoItem(
      json['label_field'] as String?,
      json['id'] as String?,
      json['value_field'] as String?,
      json['link'] as String?,
      json['action'] as int?,
      json['is_call'] as bool?,
    );

Map<String, dynamic> _$CustomerInfoItemToJson(CustomerInfoItem instance) =>
    <String, dynamic>{
      'label_field': instance.label_field,
      'id': instance.id,
      'value_field': instance.value_field,
      'link': instance.link,
      'action': instance.action,
      'is_call': instance.is_call,
    };

CustomerSale _$CustomerSaleFromJson(Map<String, dynamic> json) => CustomerSale(
      json['sale'] as int?,
    );

Map<String, dynamic> _$CustomerSaleToJson(CustomerSale instance) =>
    <String, dynamic>{
      'sale': instance.sale,
    };

CustomerNote _$CustomerNoteFromJson(Map<String, dynamic> json) => CustomerNote(
      json['sale'] as String?,
      json['is_admin'] as int?,
      json['number_of_record_left'] as int?,
      (json['data'] as List<dynamic>?)
          ?.map((e) => CustomerNoteData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CustomerNoteToJson(CustomerNote instance) =>
    <String, dynamic>{
      'sale': instance.sale,
      'is_admin': instance.is_admin,
      'number_of_record_left': instance.number_of_record_left,
      'data': instance.data,
    };

CustomerNoteData _$CustomerNoteDataFromJson(Map<String, dynamic> json) =>
    CustomerNoteData(
      json['id'] as String?,
      json['user_create_name'] as String?,
      json['avatar_user'] as String?,
      json['content'] as String?,
      json['time'] as String?,
      json['user_create_id'] as int?,
    );

Map<String, dynamic> _$CustomerNoteDataToJson(CustomerNoteData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_create_name': instance.user_create_name,
      'avatar_user': instance.avatar_user,
      'content': instance.content,
      'time': instance.time,
      'user_create_id': instance.user_create_id,
    };

DetailCustomerData _$DetailCustomerDataFromJson(Map<String, dynamic> json) =>
    DetailCustomerData(
      json['avatar'] as String?,
      (json['customer_info'] as List<dynamic>?)
          ?.map((e) => CustomerInfoData.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['customer_sale'] == null
          ? null
          : CustomerSale.fromJson(
              json['customer_sale'] as Map<String, dynamic>),
      json['customer_note'] == null
          ? null
          : CustomerNote.fromJson(
              json['customer_note'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DetailCustomerDataToJson(DetailCustomerData instance) =>
    <String, dynamic>{
      'avatar': instance.avatar,
      'customer_info': instance.customer_info,
      'customer_sale': instance.customer_sale,
      'customer_note': instance.customer_note,
    };

DetailCustomerResponse _$DetailCustomerResponseFromJson(
        Map<String, dynamic> json) =>
    DetailCustomerResponse(
      json['data'] == null
          ? null
          : DetailCustomerData.fromJson(json['data'] as Map<String, dynamic>),
    )
      ..success = json['success'] as bool?
      ..msg = json['msg'] as String?
      ..code = json['code'] as int?;

Map<String, dynamic> _$DetailCustomerResponseToJson(
        DetailCustomerResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'code': instance.code,
      'data': instance.data,
    };
