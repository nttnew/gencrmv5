import 'package:gen_crm/src/models/model_generator/base_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'note_clue.g.dart';

@JsonSerializable()
class NoteClueData {
  final int? uid;
  final String? uname, noteid, avatar, content, createdtime, passedtime;

  NoteClueData(this.uid, this.uname, this.noteid, this.avatar, this.content,
      this.createdtime, this.passedtime);

  factory NoteClueData.fromJson(Map<String, dynamic> json) =>
      _$NoteClueDataFromJson(json);

  Map<String, dynamic> toJson() => _$NoteClueDataToJson(this);
}

@JsonSerializable()
class ListNoteClue {
  final List<NoteClueData>? notes;
  final String? id;
  final int? remaining;

  ListNoteClue(this.notes, this.id, this.remaining);

  factory ListNoteClue.fromJson(Map<String, dynamic> json) =>
      _$ListNoteClueFromJson(json);

  Map<String, dynamic> toJson() => _$ListNoteClueToJson(this);
}

@JsonSerializable()
class ListNoteClueResponse extends BaseResponse {
  ListNoteClue? data;

  ListNoteClueResponse(this.data);
  factory ListNoteClueResponse.fromJson(Map<String, dynamic> json) =>
      _$ListNoteClueResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ListNoteClueResponseToJson(this);
}
