class TreeNodeData {
  String title;
  String id;
  String icon;
  bool expaned;
  bool checked;
  dynamic extra;
  List<TreeNodeData> children;

  TreeNodeData({
    required this.title,
    required this.expaned,
    required this.checked,
    required this.children,
    required this.id,
    required this.icon,
    this.extra,
  });
}
