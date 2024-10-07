import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'cupertino_loading.dart';

class Loading {
  RxInt loading = RxInt(0);

  showLoading({isLogin = false}) {
    loading.value++;
    if (isLoading() && Get.isDialogOpen != true) {
      Get.dialog(GestureDetector(
        onDoubleTap: () {
          if (isLogin && Platform.isIOS) Get.back();
        },
        child: Container(
            color: Colors.transparent,
            child: Center(child: isLogin ? SizedBox() : CupertinoLoading())),
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
