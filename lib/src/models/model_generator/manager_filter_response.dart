import '../../../widgets/tree/tree_node_model.dart';
import 'package:gen_crm/src/models/model_generator/base_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'manager_filter_response.g.dart';

@JsonSerializable()
class ManagerFilterResponse extends BaseResponse {
  final DataResponse? data;

  ManagerFilterResponse({
    this.data,
  });

  factory ManagerFilterResponse.fromJson(Map<String, dynamic> json) =>
      _$ManagerFilterResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ManagerFilterResponseToJson(this);

  static List<TreeNodeData>? mapManagerToTree(List<ManagerResponse>? d) {
    List<TreeNodeData>? list;
    list = d
        ?.map((e) => TreeNodeData(
              title: e.data?.title ?? '',
              expaned: false,
              checked: false,
              children: mapManagerToTree(e.children) ?? [],
              id: e.attr?.id ?? '',
              icon: e.data?.icon ?? '',
            ))
        .toList();
    return list;
  }
}

@JsonSerializable()
class DataResponse extends BaseResponse {
  final List<ManagerResponse>? d;

  DataResponse(
    this.d,
  );

  factory DataResponse.fromJson(Map<String, dynamic> json) =>
      _$DataResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DataResponseToJson(this);
}

@JsonSerializable()
class ManagerResponse extends BaseResponse {
  final List<ManagerResponse>? children;
  final AttrResponse? attr;
  final DataTwoResponse? data;

  ManagerResponse(
    this.children,
    this.attr,
    this.data,
  );

  factory ManagerResponse.fromJson(Map<String, dynamic> json) =>
      _$ManagerResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ManagerResponseToJson(this);
}

@JsonSerializable()
class AttrResponse extends BaseResponse {
  final String? id;

  AttrResponse(
    this.id,
  );

  factory AttrResponse.fromJson(Map<String, dynamic> json) =>
      _$AttrResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AttrResponseToJson(this);
}

@JsonSerializable()
class DataTwoResponse extends BaseResponse {
  final String? icon;
  final String? title;

  DataTwoResponse(
    this.icon,
    this.title,
  );

  factory DataTwoResponse.fromJson(Map<String, dynamic> json) =>
      _$DataTwoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DataTwoResponseToJson(this);
}
