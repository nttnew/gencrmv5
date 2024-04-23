class ModelDataAdd {
  String? label;
  dynamic value;
  int? required;
  String? parent;
  String? txtValidate;
  String? type;
  bool? isCK;//data = 'CK'


  ModelDataAdd({
    this.label,
    this.value,
    this.required,
    this.parent,
    this.txtValidate,
    this.type,
    this.isCK,
  });
}
