extension StringExt on String {
  double toDoubleTry() {
    return double.tryParse(this) ?? 0;
  }
}
