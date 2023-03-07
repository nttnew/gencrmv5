class AttachFile {
  AttachFile({required this.id, required this.fileName});
  String id;
  String fileName;

  /// A necessary factory constructor for creating a new Event instance
  /// from a map. Pass the map to the generated `_$EventFromJson()` constructor.
  /// The constructor is named after the source class Event.
  factory AttachFile.fromJson(Map<String, dynamic> json) =>
      AttachFile(id: json['id'], fileName: json['filename']);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$EventToJson`.
  Map<String, dynamic> toJson() => {"id": this.id, "filename": this.fileName};
}
