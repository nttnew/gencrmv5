import 'dart:io';

import 'package:image_picker/image_picker.dart';

extension MyXfile on XFile {
  isFileNet() {
    if (this.path.contains('http')) {
      return true;
    }
    return false;
  }

  toFile() {
    return File(this.path);
  }
}
