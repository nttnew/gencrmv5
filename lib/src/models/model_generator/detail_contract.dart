import 'package:gen_crm/src/models/model_generator/attach_file.dart';
import 'package:gen_crm/src/models/model_generator/base_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'detail_contract.g.dart';

@JsonSerializable()
class PaymentContractItem {
  final String? field_name, field_label, field_type, field_special;
  final dynamic field_value;
  final int? field_hidden;

  PaymentContractItem(this.field_name, this.field_label, this.field_value,
      this.field_type, this.field_hidden, this.field_special);

  factory PaymentContractItem.fromJson(Map<String, dynamic> json) =>
      _$PaymentContractItemFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentContractItemToJson(this);
}

@JsonSerializable()
class PaymentContractResponse extends BaseResponse {
  final List<List<PaymentContractItem>?>? data;

  PaymentContractResponse(this.data);

  factory PaymentContractResponse.fromJson(Map<String, dynamic> json) =>
      _$PaymentContractResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentContractResponseToJson(this);
}

@JsonSerializable()
class DetailContractItem {
  final String? label_field, id, value_field, field_type;
  final bool? is_link;

  DetailContractItem(this.label_field, this.id, this.value_field, this.is_link,
      this.field_type);

  factory DetailContractItem.fromJson(Map<String, dynamic> json) =>
      _$DetailContractItemFromJson(json);

  Map<String, dynamic> toJson() => _$DetailContractItemToJson(this);
}

@JsonSerializable()
class DetailContractData {
  final String? group_name;
  final int? mup;
  final List<DetailContractItem>? data;
  final List<AttachFile>? listFile;

  DetailContractData(this.group_name, this.mup, this.data, this.listFile);

  factory DetailContractData.fromJson(Map<String, dynamic> json) =>
      _$DetailContractDataFromJson(json);

  Map<String, dynamic> toJson() => _$DetailContractDataToJson(this);
}

@JsonSerializable()
class DetailContractResponse extends BaseResponse {
  final List<DetailContractData>? data;

  DetailContractResponse(this.data);

  factory DetailContractResponse.fromJson(Map<String, dynamic> json) =>
      _$DetailContractResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DetailContractResponseToJson(this);
}

@JsonSerializable()
class SupportContractData {
  final String? id,
      name,
      status,
      content,
      created_date,
      color,
      total_note,
      nguoi_tao,
      khach_hang;

  SupportContractData(
      this.id,
      this.name,
      this.status,
      this.content,
      this.created_date,
      this.color,
      this.total_note,
      this.nguoi_tao,
      this.khach_hang);

  factory SupportContractData.fromJson(Map<String, dynamic> json) =>
      _$SupportContractDataFromJson(json);

  Map<String, dynamic> toJson() => _$SupportContractDataToJson(this);
}

@JsonSerializable()
class SupportContractResponse extends BaseResponse {
  final List<SupportContractData>? data;

  SupportContractResponse(this.data);

  factory SupportContractResponse.fromJson(Map<String, dynamic> json) =>
      _$SupportContractResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SupportContractResponseToJson(this);
}
