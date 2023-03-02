import 'package:gen_crm/src/models/model_generator/base_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'detail_customer.g.dart';

@JsonSerializable()
class CustomerInfoData {
  final String? group_name;
  final int? mup;
  final List<CustomerInfoItem>? data;


  CustomerInfoData(this.group_name, this.mup, this.data);

  factory CustomerInfoData.fromJson(Map<String, dynamic> json) =>
      _$CustomerInfoDataFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerInfoDataToJson(this);
}

@JsonSerializable()
class CustomerInfoItem{
  final String? label_field,id,value_field;
  final String? link;
  final int? action;
  final bool? is_call;


  CustomerInfoItem(this.label_field, this.id, this.value_field, this.link,
      this.action, this.is_call);

  factory CustomerInfoItem.fromJson(Map<String, dynamic> json) =>
      _$CustomerInfoItemFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerInfoItemToJson(this);
}

@JsonSerializable()
class CustomerSale {
  final String? sale;


  CustomerSale(this.sale);

  factory CustomerSale.fromJson(Map<String, dynamic> json) =>
      _$CustomerSaleFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerSaleToJson(this);
}

@JsonSerializable()
class CustomerNote {
  final String? sale;
  final int? is_admin,number_of_record_left;
  final List<CustomerNoteData>? data;


  CustomerNote(this.sale, this.is_admin, this.number_of_record_left, this.data);

  factory CustomerNote.fromJson(Map<String, dynamic> json) =>
      _$CustomerNoteFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerNoteToJson(this);
}

@JsonSerializable()
class CustomerNoteData {
  final String? id,user_create_name,avatar_user,content,time;
  final int? user_create_id;


  CustomerNoteData(this.id, this.user_create_name, this.avatar_user,
      this.content, this.time, this.user_create_id);

  factory CustomerNoteData.fromJson(Map<String, dynamic> json) =>
      _$CustomerNoteDataFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerNoteDataToJson(this);
}

@JsonSerializable()
class DetailCustomerData {
  final String? avatar;
  final List<CustomerInfoData>? customer_info;
  final CustomerSale? customer_sale;
  final CustomerNote? customer_note;


  DetailCustomerData(this.avatar, this.customer_info, this.customer_sale,this.customer_note);

  factory DetailCustomerData.fromJson(Map<String, dynamic> json) =>
      _$DetailCustomerDataFromJson(json);

  Map<String, dynamic> toJson() => _$DetailCustomerDataToJson(this);
}

@JsonSerializable()
class DetailCustomerResponse extends BaseResponse {
  final DetailCustomerData? data;


  DetailCustomerResponse(
      this.data);

  factory DetailCustomerResponse.fromJson(Map<String, dynamic> json) =>
      _$DetailCustomerResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DetailCustomerResponseToJson(this);
}







