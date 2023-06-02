import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../src/color.dart';
import 'cupertino_loading.dart';

class LoadingApi {
  RxInt loading = RxInt(0);

  pushLoading() {
    loading.value++;
    if (isLoading() && Get.isDialogOpen != true) {
      Get.dialog(Container(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: () {},
          child: Center(child: CupertinoLoading()),
        ),
      ));
    }
  }

  popLoading() {
    loading.value > 0 ? loading.value-- : loading.value = 0;
    if (!this.isLoading() && Get.isDialogOpen == true) {
      Get.back();
      for (int i = 0; i < loading.value; i++) {
        Get.back();
      }
    }
  }

  bool isLoading() {
    return loading.value > 0;
  }
}
