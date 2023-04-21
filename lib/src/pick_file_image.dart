import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gen_crm/widgets/widgets.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../../src/src_index.dart';
import '../bloc/contract/attack_bloc.dart';
import '../screens/add_service_voucher/preview_image.dart';

Widget FileDinhKemUiBase(
        {required BuildContext context,
        required Function() onTap,
        bool isSave = true}) =>
    Column(
      children: [
        BlocBuilder<AttackBloc, AttackState>(builder: (context, state) {
          if (state is SuccessAttackState) if (state.files != null)
            return Column(
              children: [
                Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    width: Get.width,
                    child: Column(
                      children: [
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount:
                              checkListImage(false, state.files ?? []).length,
                          itemBuilder: (context, index) => Container(
                            margin: EdgeInsets.only(bottom: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: WidgetText(
                                    title: checkListImage(
                                            false, state.files ?? [])[index]
                                        .path
                                        .split("/")
                                        .last,
                                    style: AppStyle.DEFAULT_14,
                                    maxLine: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    AttackBloc.of(context)
                                        .add(RemoveAttackEvent(
                                      file: checkListImage(
                                          false, state.files ?? [])[index],
                                    ));
                                  },
                                  child: WidgetContainerImage(
                                    image: 'assets/icons/icon_delete.png',
                                    width: 20,
                                    height: 20,
                                    fit: BoxFit.contain,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount:
                              checkListImage(true, state.files ?? []).length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 25,
                            mainAxisSpacing: 25,
                            mainAxisExtent: 90,
                          ),
                          itemBuilder: (context, index) => Stack(
                            clipBehavior: Clip.none,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => PreviewImage(
                                            file: checkListImage(
                                                true, state.files ?? [])[index],
                                          )));
                                },
                                child: Container(
                                  clipBehavior: Clip.hardEdge,
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  child: Image.file(
                                    checkListImage(
                                        true, state.files ?? [])[index],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                child: GestureDetector(
                                  onTap: () {
                                    AttackBloc.of(context)
                                        .add(RemoveAttackEvent(
                                      file: checkListImage(
                                          true, state.files ?? [])[index],
                                    ));
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Colors.black, width: 0.1),
                                      ),
                                      height: 16,
                                      width: 16,
                                      child: Icon(
                                        Icons.close,
                                        size: 9,
                                      )),
                                ),
                                top: 0,
                                right: 0,
                              )
                            ],
                          ),
                        )
                      ],
                    )),
              ],
            );
          else
            return Container();
          else
            return const SizedBox.shrink();
        }),
        if (isSave) FileLuuBase(context, onTap),
      ],
    );

Widget FileLuuBase(BuildContext context, Function() onTap) => Row(
      children: [
        GestureDetector(
            onTap: () async {
              await onDinhKemBase(context).then((listFile) {
                if (listFile != []) {
                  AttackBloc.of(context).add(InitAttackEvent(files: listFile));
                }
              });
            },
            child: SvgPicture.asset("assets/icons/attack.svg")),
        Spacer(),
        GestureDetector(
          onTap: () => onTap(),
          child: Material(
            child: Container(
              height: AppValue.widths * 0.1,
              width: AppValue.widths * 0.25,
              decoration: BoxDecoration(
                  color: HexColor("#F1A400"),
                  borderRadius: BorderRadius.circular(20.5)),
              child: Center(
                  child: Text(
                    "Lưu",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
          ),
        ),
      ],
    );
Future<List<File>> onDinhKemBase(BuildContext context) async {
  List<File> listPickFile = [];
  if (await Permission.storage.request().isGranted) {
    if (Platform.isAndroid) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return WidgetDialog(
            title: MESSAGES.NOTIFICATION,
            content: 'Bạn chưa cấp quyền truy cập vào ảnh?',
            textButton2: 'Đi đến cài đặt',
            textButton1: 'Ok',
            onTap2: () {
              openAppSettings();
              Get.back();
            },
            onTap1: () {
              Get.back();
            },
          );
        },
      );
    } else {
      listPickFile = await pickFileDialog();
    }
  } else {
    listPickFile = await pickFileDialog();
  }
  return listPickFile;
}

Future<List<File>> pickFileDialog() async {
  List<File> listFile = [];
  await showCupertinoModalPopup(
      context: Get.context!,
      builder: (context) => CupertinoActionSheet(
              cancelButton: CupertinoActionSheetAction(
                child: Text('Huỷ'),
                onPressed: () {
                  AppNavigator.navigateBack();
                },
              ),
              actions: [
                CupertinoActionSheetAction(
                  onPressed: () async {
                    final file = await getImageCamera();
                    if (file != null) listFile.add(file);
                    Get.back();
                  },
                  child: Text('Chụp ảnh mới'),
                ),
                CupertinoActionSheetAction(
                  onPressed: () async {
                    final file = await getImageVideo();
                    if (file != null) listFile.add(file);
                    Get.back();
                  },
                  child: Text('Quay video mới'),
                ),
                CupertinoActionSheetAction(
                  onPressed: () async {
                    final files = await pickFile();
                    if (files != null) listFile.addAll(files);
                    Get.back();
                  },
                  child: Text('Chọn file'),
                ),
                CupertinoActionSheetAction(
                  onPressed: () async {
                    final files = await getImage();
                    if (files != null) listFile.addAll(files);
                    Get.back();
                  },
                  child: Text('Chọn ảnh có sẵn'),
                ),
              ]));
  return listFile;
}

List<File> handelListFile(List<PlatformFile> files) {
  final List<File> list = [];
  for (final value in files) {
    list.add(File(value.path!));
  }
  return list;
}

List<File> handelListImage(List<XFile> files) {
  final List<File> list = [];
  for (final value in files) {
    list.add(File(value.path));
  }
  return list;
}

Future<List<File>?> getImage() async {
  try {
    final result = await ImagePicker().pickMultiImage();
    if (result.isNotEmpty) {
      List<File> listFilePiker = handelListImage(result);
      return listFilePiker;
    }
  } on PlatformException catch (e) {
    throw e;
  }
  return null;
}

Future<List<File>?> pickFile() async {
  List<File>? listFilePiker;
  FilePickerResult? result =
      await FilePicker.platform.pickFiles(allowMultiple: true);
  if (result != null && result.files.isNotEmpty) {
    listFilePiker = handelListFile(result.files);
  }
  return listFilePiker;
}

Future<File?> getImageCamera() async {
  try {
    final XFile? fileCamera =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (fileCamera != null) {
      return File(fileCamera.path);
    }
  } on PlatformException catch (e) {
    throw e;
  }
  return null;
}

Future<File?> getImageVideo() async {
  try {
    final XFile? cameraVideo =
        await ImagePicker().pickVideo(source: ImageSource.camera);
    if (cameraVideo != null) {
      return File(cameraVideo.path);
    }
  } on PlatformException catch (e) {
    throw e;
  }
  return null;
}

List<File> checkListImage(bool isImage, List<File> list) {
  List<File> listImage = [];
  List<File> listFile = [];
  for (final value in list) {
    final String fileExt = value.path.split("/").last.split('.').last;
    if (AppValue.checkTypeImage(fileExt)) {
      listImage.add(value);
    } else {
      listFile.add(value);
    }
  }
  if (isImage) {
    return listImage;
  } else {
    return listFile;
  }
}
