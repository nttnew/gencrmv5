import 'package:gen_crm/src/models/model_generator/base_response.dart';
import 'package:json_annotation/json_annotation.dart';

import 'attach_file.dart';

part 'detail_customer.g.dart';

@JsonSerializable()
class InfoDataModel {
  final String? group_name, main_id, avatar;
  final int? mup;
  final List<InfoItem>? data;
  final List<AttachFile>? listFile;

  InfoDataModel(
    this.group_name,
    this.main_id,
    this.avatar,
    this.mup,
    this.data,
    this.listFile,
  );

  factory InfoDataModel.fromJson(Map<String, dynamic> json) =>
      _$InfoDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$InfoDataModelToJson(this);
}

@JsonSerializable()
class InfoItem {
  final String? label_field,
      id,
      field_type,
      link,
      name_field,
      field_name,
      is_type,
      data_type,
      color;
  final dynamic value_field;
  final int? action, is_image;
  final bool? is_call, is_link;
  final List<OptionModel>? options;
  final ApiUpdateModel? apiUpdate;

  InfoItem(
    this.label_field,
    this.id,
    this.value_field,
    this.field_type,
    this.link,
    this.name_field,
    this.field_name,
    this.is_type,
    this.data_type,
    this.color,
    this.action,
    this.is_image,
    this.is_call,
    this.is_link,
    this.options,
    this.apiUpdate,
  );

  factory InfoItem.fromJson(Map<String, dynamic> json) =>
      _$InfoItemFromJson(json);

  Map<String, dynamic> toJson() => _$InfoItemToJson(this);
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
  final int? is_admin, number_of_record_left;
  final List<CustomerNoteData>? data;

  CustomerNote(this.sale, this.is_admin, this.number_of_record_left, this.data);

  factory CustomerNote.fromJson(Map<String, dynamic> json) =>
      _$CustomerNoteFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerNoteToJson(this);
}

@JsonSerializable()
class CustomerNoteData {
  final String? id, user_create_name, avatar_user, content, time;
  final int? user_create_id;

  CustomerNoteData(
    this.id,
    this.user_create_name,
    this.avatar_user,
    this.content,
    this.time,
    this.user_create_id,
  );

  factory CustomerNoteData.fromJson(Map<String, dynamic> json) =>
      _$CustomerNoteDataFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerNoteDataToJson(this);
}

@JsonSerializable()
class DetailCustomerData {
  final String? avatar;
  final List<InfoDataModel>? customer_info;
  final CustomerSale? customer_sale;
  final CustomerNote? customer_note;

  DetailCustomerData(
    this.avatar,
    this.customer_info,
    this.customer_sale,
    this.customer_note,
  );

  factory DetailCustomerData.fromJson(Map<String, dynamic> json) =>
      _$DetailCustomerDataFromJson(json);

  Map<String, dynamic> toJson() => _$DetailCustomerDataToJson(this);
}

@JsonSerializable()
class DetailCustomerResponse extends BaseResponse {
  final DetailCustomerData? data;

  DetailCustomerResponse(
    this.data,
  );

  factory DetailCustomerResponse.fromJson(Map<String, dynamic> json) =>
      _$DetailCustomerResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DetailCustomerResponseToJson(this);
}

@JsonSerializable()
class OptionModel {
  final String? id, name, color;

  OptionModel(this.id, this.name, this.color);

  factory OptionModel.fromJson(Map<String, dynamic> json) =>
      _$OptionModelFromJson(json);

  Map<String, dynamic> toJson() => _$OptionModelToJson(this);
}

@JsonSerializable()
class ApiUpdateModel {
  final String? link;
  final dynamic params;

  ApiUpdateModel(
    this.link,
    this.params,
  );

  factory ApiUpdateModel.fromJson(Map<String, dynamic> json) =>
      _$ApiUpdateModelFromJson(json);

  Map<String, dynamic> toJson() => _$ApiUpdateModelToJson(this);
}
