// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductItem _$ProductItemFromJson(Map<String, dynamic> json) => ProductItem(
      json['product_id'] as String?,
      json['product_code'] as String?,
      json['product_edit'] as String?,
      json['product_name'] as String?,
      json['dvt'] as String?,
      json['vat'] as String?,
      json['sell_price'] as String?,
      ten_combo: json['ten_combo'] as String?,
      combo_id: json['combo_id'] as String?,
    );

Map<String, dynamic> _$ProductItemToJson(ProductItem instance) =>
    <String, dynamic>{
      'product_id': instance.product_id,
      'product_code': instance.product_code,
      'product_edit': instance.product_edit,
      'product_name': instance.product_name,
      'dvt': instance.dvt,
      'vat': instance.vat,
      'sell_price': instance.sell_price,
      'ten_combo': instance.ten_combo,
      'combo_id': instance.combo_id,
    };

ProductData _$ProductDataFromJson(Map<String, dynamic> json) => ProductData(
      json['page'],
      json['limit'] as int?,
      json['total'] as int?,
      (json['product'] as List<dynamic>?)
          ?.map((e) => ProductItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['units'] as List<dynamic>?)
          ?.map((e) => e as List<dynamic>)
          .toList(),
      (json['vats'] as List<dynamic>?)?.map((e) => e as List<dynamic>).toList(),
    );

Map<String, dynamic> _$ProductDataToJson(ProductData instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
      'total': instance.total,
      'product': instance.product,
      'units': instance.units,
      'vats': instance.vats,
    };

ProductResponse _$ProductResponseFromJson(Map<String, dynamic> json) =>
    ProductResponse(
      json['data'] == null
          ? null
          : ProductData.fromJson(json['data'] as Map<String, dynamic>),
    )
      ..success = json['success'] as bool?
      ..msg = json['msg'] as String?
      ..code = json['code'] as int?;

Map<String, dynamic> _$ProductResponseToJson(ProductResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'code': instance.code,
      'data': instance.data,
    };
