import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/widgets/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../../src/src_index.dart';
import '../bloc/contract/attack_bloc.dart';
import '../../l10n/key_text.dart';
import '../screens/form/widget/preview_image.dart';
import 'package:image/image.dart' as img;
import 'btn_save.dart';
import 'loading_api.dart';

Widget FileDinhKemUiBase({
  required BuildContext context,
}) =>
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
                          padding: EdgeInsets.zero,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount:
                              checkListImage(false, state.files ?? []).length,
                          itemBuilder: (context, index) => Container(
                            margin: EdgeInsets.only(bottom: 8),
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  4,
                                ),
                              ),
                              color: COLORS.LIGHT_GREY,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    right: 4,
                                  ),
                                  child: Icon(
                                    Icons.file_open,
                                    size: 20,
                                  ),
                                ),
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
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 4,
                                    ),
                                    child: Icon(
                                      Icons.delete,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GridView.builder(
                          padding: EdgeInsets.zero,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount:
                              checkListImage(true, state.files ?? []).length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            mainAxisExtent: 90,
                          ),
                          itemBuilder: (context, index) => Stack(
                            clipBehavior: Clip.none,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => PreviewImage(
                                        file: checkListImage(
                                            true, state.files ?? [])[index],
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  clipBehavior: Clip.hardEdge,
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        8,
                                      ),
                                    ),
                                  ),
                                  child: Image.file(
                                    checkListImage(
                                        true, state.files ?? [])[index],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                child: InkWell(
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
                                      color: COLORS.WHITE,
                                      border: Border.all(
                                        color: COLORS.BLACK,
                                        width: 0.5,
                                      ),
                                    ),
                                    height: 24,
                                    width: 24,
                                    child: Icon(
                                      Icons.close,
                                      size: 15,
                                    ),
                                  ),
                                ),
                                top: -1,
                                right: -1,
                              )
                            ],
                          ),
                        )
                      ],
                    )),
              ],
            );
          else
            return SizedBox.shrink();
          else
            return const SizedBox.shrink();
        }),
      ],
    );

Widget FileLuuBase(
  BuildContext context,
  Function() onTap, {
  bool isAttack = true,
  Widget? btn,
}) =>
    SizedBox(
      height: 40,
      child: Row(
        children: [
          if (isAttack)
            GestureDetector(
              onTap: () async {
                await onDinhKemBase(context).then((listFile) {
                  if (listFile != []) {
                    AttackBloc.of(context)
                        .add(InitAttackEvent(files: listFile));
                  }
                });
              },
              child: Image.asset(
                ICONS.IC_ATTACK_PNG,
                height: 24,
                width: 24,
              ),
            ),
          Spacer(),
          Row(
            children: [
              if (btn != null) btn,
              ButtonSave(onTap: () => onTap()),
            ],
          ),
        ],
      ),
    );

Future<List<File>> onDinhKemBase(
  BuildContext context, {
  bool isImage = false,
}) async {
  List<File> listPickFile = [];
  if (await Permission.storage.request().isGranted) {
    if (Platform.isAndroid) {
      ShowDialogCustom.showDialogBase(
        title: getT(KeyT.notification),
        content: getT(KeyT.you_have_not_granted_access_to_photos),
        textButton2: getT(KeyT.go_to_setting),
        onTap2: () {
          openAppSettings();
          Get.back();
        },
      );
    } else {
      listPickFile = await pickFileDialog(isImage: isImage);
    }
  } else {
    listPickFile = await pickFileDialog(isImage: isImage);
  }
  return listPickFile;
}

Future<List<File>> pickFileDialog({bool isImage = false}) async {
  List<File> listFile = [];
  await showCupertinoModalPopup(
      context: Get.context!,
      builder: (context) => CupertinoActionSheet(
              cancelButton: CupertinoActionSheetAction(
                child: Text(getT(KeyT.cancel)),
                onPressed: () {
                  AppNavigator.navigateBack();
                },
              ),
              actions: [
                CupertinoActionSheetAction(
                  onPressed: () async {
                    final file = await getImageCamera(is2mb: true);
                    if (file != null) listFile.add(file);
                    Get.back();
                  },
                  child: Text(
                    getT(KeyT.new_photo_shoot),
                  ),
                ),
                if (!isImage)
                  CupertinoActionSheetAction(
                    onPressed: () async {
                      final file = await getImageVideo();
                      if (file != null) listFile.add(file);
                      Get.back();
                    },
                    child: Text(
                      getT(KeyT.new_video_recoding),
                    ),
                  ),
                if (!isImage)
                  CupertinoActionSheetAction(
                    onPressed: () async {
                      final files = await pickFile();
                      if (files != null && files.length > 0)
                        listFile.addAll(files);
                      Get.back();
                    },
                    child: Text(
                      getT(KeyT.pick_file),
                    ),
                  ),
                CupertinoActionSheetAction(
                  onPressed: () async {
                    final files = await getImage();
                    if (files != null && files.length > 0)
                      listFile.addAll(files);
                    Get.back();
                  },
                  child: Text(
                    getT(KeyT.pick_photo),
                  ),
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

Future<File?> getImageOne() async {
  try {
    // Kiểm tra quyền truy cập thư viện ảnh
    var status = await Permission.photos.status;
    if (!status.isGranted) {
      // Yêu cầu quyền nếu chưa được cấp
      status = await Permission.photos.request();
    }

    // Nếu quyền đã được cấp, mở thư viện ảnh
    if (status.isGranted || Platform.isIOS || Platform.isMacOS) {
      //os k cần check quyền
      final result = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (result?.path != null) {
        return File(result?.path ?? '');
      }
    } else {
      ShowDialogCustom.showDialogBase(
        title: getT(KeyT.notification),
        content: getT(KeyT.you_have_not_granted_access_to_photos),
        textButton2: getT(KeyT.go_to_setting),
        onTap2: () {
          openAppSettings();
          Get.back();
        },
      );
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

Future<File> compressImage(
  File imageFile, {
  int maxSizeInBytes = 200000000000000, // bỏ resize
}) async {
  //done 2mb
  try {
    // Đọc dữ liệu của ảnh
    final bytes = await imageFile.readAsBytes();
    img.Image? image = img.decodeImage(bytes);

    // Nếu ảnh vượt quá kích thước tối đa đã đặt, nén ảnh
    if (image != null && image.length > maxSizeInBytes) {
      // Tính toán chất lượng nén cần thiết để giảm kích thước xuống dưới maxSizeInBytes
      int quality = ((maxSizeInBytes / image.length) * 100).floor();

      // Nén ảnh với chất lượng đã tính toán
      List<int> compressedBytes = img.encodeJpg(image, quality: quality);

      // Tạo một tệp mới với dữ liệu nén
      File compressedImage = File('${imageFile.path}.compressed.jpg');
      await compressedImage.writeAsBytes(compressedBytes);

      // Trả về tệp đã nén
      return compressedImage;
    } else {
      // Trả về tệp gốc nếu không cần nén
      return imageFile;
    }
  } catch (e) {
    return imageFile;
  }
}

Future<File?> getImageCamera({
  bool is2mb = true,
  bool isShowLoading = false,
}) async {
  try {
    if (isShowLoading) Loading().showLoading();
    final XFile? fileCamera = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (fileCamera != null) {
      if (is2mb) {
        final File duoi2MB = await compressImage(File(fileCamera.path));
        return duoi2MB;
      }
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
