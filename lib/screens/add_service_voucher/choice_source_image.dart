import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../src/messages.dart';
import '../../src/show_dialog.dart';

class ChoiceSourceImage extends StatefulWidget {
  const ChoiceSourceImage({Key? key}) : super(key: key);

  @override
  State<ChoiceSourceImage> createState() => _ChoiceSourceImageState();
}

class _ChoiceSourceImageState extends State<ChoiceSourceImage> {
  void showSettingDialog() {
     ShowDialogCustom.showDialogBase(
          title: MESSAGES.NOTIFICATION,
          content: "Đi đến cài đặt",
          textButton1: "Đi",
          onTap1: () {
            openAppSettings();
            Get.back();
          },
          textButton2: "Huỷ",
          onTap2: () {
            Get.back();
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 9, bottom: 29),
              height: 5,
              width: 40,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    10,
                  ),
                ),
                color: Colors.cyan,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buttonWidget(
                content: 'S.current.camera',
                imageUrl: 'ImageAssets.img_camera',
                onTap: () async {
                  final nav = Navigator.of(context);
                  final permissionCamera = await Permission.camera.request();
                  if (permissionCamera == PermissionStatus.granted) {
                    nav.pop(true);
                  } else {
                    showSettingDialog();
                  }
                },
              ),
              buttonWidget(
                content: 'S.current.gallery',
                imageUrl: 'ImageAssets.img_gallery',
                onTap: () async {
                  final nav = Navigator.of(context);
                  final PermissionStatus permission;
                  permission = await Permission.storage.request();
                  if (permission == PermissionStatus.granted ||
                      permission == PermissionStatus.limited) {
                    nav.pop(false);
                  } else {
                    showSettingDialog();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buttonWidget({
    required String content,
    required String imageUrl,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              height: 88,
              width: 88,
              child: Image.asset(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              child: Text(
                content,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
