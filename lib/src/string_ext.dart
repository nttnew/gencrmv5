extension StringExt on String {
  double toDoubleTry() {
    if (this != 'null' && this != '')
      return double.tryParse(this) ?? 0;
    else
      return 0;
  }
}
