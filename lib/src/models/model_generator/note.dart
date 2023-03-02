import 'package:gen_crm/src/models/model_generator/base_response.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:gen_crm/src/models/index.dart';

part 'note.g.dart';

@JsonSerializable()
class NoteItem {
  final dynamic uid;
  final String? uname,noteid,avatar,content,createdtime,passedtime;


  NoteItem(this.uid, this.uname, this.noteid, this.avatar, this.content,
      this.createdtime, this.passedtime);

  factory NoteItem.fromJson(Map<String, dynamic> json) => _$NoteItemFromJson(json);

  Map<String, dynamic> toJson() => _$NoteItemToJson(this);
}

@JsonSerializable()
class NoteData {
  final List<NoteItem>? notes;
  final String? id;
  final int? remaining;


  NoteData(this.notes, this.id, this.remaining);

  factory NoteData.fromJson(Map<String, dynamic> json) => _$NoteDataFromJson(json);

  Map<String, dynamic> toJson() => _$NoteDataToJson(this);
}

@JsonSerializable()
class NoteResponse extends BaseResponse{
  final NoteData? data;


  NoteResponse(this.data);

  factory NoteResponse.fromJson(Map<String, dynamic> json) => _$NoteResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NoteResponseToJson(this);
}