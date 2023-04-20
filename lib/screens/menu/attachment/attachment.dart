import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gen_crm/widgets/widgets.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../src/src_index.dart';
import '../../../bloc/contract/detail_contract_bloc.dart';
import '../../../src/models/model_generator/file_response.dart';
import '../../../widgets/item_file.dart';
import '../../add_service_voucher/preview_image.dart';

class Attachment extends StatefulWidget {
  Attachment({
    Key? key,
    required this.id,
    required this.name,
    required this.listFileResponse,
    required this.typeModule,
  }) : super(key: key);
  final String id;
  final String name;
  final String typeModule;
  final List<FileDataResponse> listFileResponse;

  @override
  State<Attachment> createState() => _AttachmentState();
}

class _AttachmentState extends State<Attachment> {
  late final List<File> listPickFile;
  late final List<FileDataResponse> listFileResponseRemove;
  late final String id;
  late final String name;
  late final String typeModule;
  late final List<FileDataResponse> listFileResponse;
  late final BehaviorSubject<bool?> status;

  @override
  void initState() {
    status = BehaviorSubject.seeded(true);
    id = widget.id;
    name = widget.name;
    typeModule = widget.typeModule;
    listFileResponse = widget.listFileResponse;
    listPickFile = [];
    listFileResponseRemove = [];
    super.initState();
  }

  @override
  void dispose() {
    listPickFile.clear();
    listFileResponseRemove.clear();
    status.close();
    super.dispose();
  }

  Future<void> onDinhKem() async {
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
        pickFileDialog();
      }
    } else {
      pickFileDialog();
    }
  }

  void pickFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null && result.files.isNotEmpty) {
      List<File> listFilePiker = handelListFile(result.files);
      listPickFile.addAll(listFilePiker);
      setState(() {});
    }
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

  void pickFileDialog() {
    showCupertinoModalPopup(
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
                      Get.back();
                      getImageCamera();
                    },
                    child: Text('Chụp ảnh mới'),
                  ),
                  CupertinoActionSheetAction(
                    onPressed: () async {
                      Get.back();
                      getImageVideo();
                    },
                    child: Text('Quay video mới'),
                  ),
                  CupertinoActionSheetAction(
                    onPressed: () async {
                      Get.back();
                      pickFile();
                    },
                    child: Text('Chọn file'),
                  ),
                  CupertinoActionSheetAction(
                    onPressed: () async {
                      Get.back();
                      getImage();
                    },
                    child: Text('Chọn ảnh có sẵn'),
                  ),
                ]));
  }

  Future getImage() async {
    try {
      final result = await ImagePicker().pickMultiImage();
      if (result.isNotEmpty) {
        List<File> listFilePiker = handelListImage(result);
        listPickFile.addAll(listFilePiker);
        setState(() {});
      }
    } on PlatformException catch (e) {
      throw e;
    }
  }

  Future getImageCamera() async {
    try {
      final XFile? cameraVideo =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (cameraVideo != null) {
        listPickFile.add(File(cameraVideo.path));
        setState(() {});
      }
    } on PlatformException catch (e) {
      throw e;
    }
  }

  Future getImageVideo() async {
    try {
      final XFile? cameraVideo =
          await ImagePicker().pickVideo(source: ImageSource.camera);
      if (cameraVideo != null) {
        listPickFile.add(File(cameraVideo.path));
        setState(() {});
      }
    } on PlatformException catch (e) {
      throw e;
    }
  }

  Future<void> onClickSave() async {
    bool check = false;
    status.add(check);

    if (listFileResponseRemove.isNotEmpty)
      check = (await DetailContractBloc.of(context)
          .deleteFile(listFileResponseRemove))!;
    if (listPickFile.isNotEmpty)
      check = (await DetailContractBloc.of(context).uploadFile(
          widget.id, listPickFile, getURLModule(widget.typeModule)))!;

    if (check) {
      status.add(check);
      AppNavigator.navigateBack();
    } else {
      status.add(true);
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const WidgetDialog(
              title: MESSAGES.NOTIFICATION,
              content: 'Thất bại',
            );
          });
    }
  }

  List<File> checkListImage(bool isImage, List<File> list) {
    final List<File> listImage = [];
    final List<File> listFile = [];
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

  List<FileDataResponse> checkListImageApi(
      bool isImage, List<FileDataResponse> list) {
    final List<FileDataResponse> listImage = [];
    final List<FileDataResponse> listFile = [];
    for (final value in list) {
      if (AppValue.checkTypeImage(value.loaiFile.toString())) {
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

  void removeFilePick(File file) {
    final int i = listPickFile.indexOf(file);
    listPickFile.removeAt(i);
    setState(() {});
  }

  void removeFileResponse(FileDataResponse file) {
    final int i = listFileResponse.indexOf(file);
    listFileResponseRemove.add(file);
    listFileResponse.removeAt(i);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
      appBar: AppBar(
        toolbarHeight: AppValue.heights * 0.1,
        backgroundColor: HexColor("#D0F1EB"),
        centerTitle: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            WidgetText(
                title: "Xem đính kèm",
                style:
                    AppStyle.DEFAULT_16.copyWith(fontWeight: FontWeight.w700))
          ],
        ),
        leading: Padding(
            padding: EdgeInsets.only(left: 30),
            child: InkWell(
                onTap: () => AppNavigator.navigateBack(),
                child: Icon(Icons.arrow_back, color: Colors.black))),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: listPickFile.isNotEmpty || listFileResponse.isNotEmpty
                ? StreamBuilder<bool?>(
                    stream: status,
                    builder: (context, snapshot) {
                      if (snapshot.data ?? false) {
                        return Container(
                            padding: EdgeInsets.all(16),
                            child: SingleChildScrollView(
                              child: Container(
                                margin: EdgeInsets.only(bottom: 60),
                                child: Column(
                                  children: [
                                    if (listFileResponse.isNotEmpty) ...[
                                      Row(
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5),
                                              child: WidgetText(
                                                title: "Tệp đã chọn",
                                                style: AppStyle.DEFAULT_16_BOLD,
                                              )),
                                        ],
                                      ),
                                      Container(
                                          margin:
                                              EdgeInsets.symmetric(vertical: 8),
                                          width: Get.width,
                                          child: Column(
                                            children: [
                                              ListView.builder(
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: checkListImageApi(
                                                        false, listFileResponse)
                                                    .length,
                                                itemBuilder: (context, index) =>
                                                    ItemFile(
                                                  file: checkListImageApi(false,
                                                      listFileResponse)[index],
                                                  functionMy: () {
                                                    removeFileResponse(
                                                        checkListImageApi(false,
                                                                listFileResponse)[
                                                            index]);
                                                  },
                                                ),
                                              ),
                                              GridView.builder(
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: checkListImageApi(
                                                        true, listFileResponse)
                                                    .length,
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  crossAxisSpacing: 25,
                                                  mainAxisSpacing: 25,
                                                  mainAxisExtent: 90,
                                                ),
                                                itemBuilder: (context, index) =>
                                                    Stack(
                                                  clipBehavior: Clip.none,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        PreviewImage(
                                                                          isNetwork:
                                                                              true,
                                                                          file: File(checkListImageApi(true, listFileResponse)[index]
                                                                              .link
                                                                              .toString()),
                                                                          module:
                                                                              widget.typeModule,
                                                                        )));
                                                      },
                                                      child: Container(
                                                        clipBehavior:
                                                            Clip.hardEdge,
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        height: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        decoration: BoxDecoration(
                                                            color: Colors.grey,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            8))),
                                                        child: Image.network(
                                                          checkListImageApi(
                                                                          true,
                                                                          listFileResponse)[
                                                                      index]
                                                                  .link ??
                                                              '',
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          removeFileResponse(
                                                              checkListImageApi(
                                                                      true,
                                                                      listFileResponse)[
                                                                  index]);
                                                        },
                                                        child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color:
                                                                  Colors.white,
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .black,
                                                                  width: 0.1),
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
                                    if (listPickFile.isNotEmpty) ...[
                                      Row(
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5),
                                              child: WidgetText(
                                                title: "Tệp vừa chọn",
                                                style: AppStyle.DEFAULT_16_BOLD,
                                              )),
                                        ],
                                      ),
                                      Container(
                                          margin:
                                              EdgeInsets.symmetric(vertical: 8),
                                          width: Get.width,
                                          child: Column(
                                            children: [
                                              ListView.builder(
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: checkListImage(
                                                        false, listPickFile)
                                                    .length,
                                                itemBuilder: (context, index) =>
                                                    Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 4),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: WidgetText(
                                                          title: checkListImage(
                                                                      false,
                                                                      listPickFile)[
                                                                  index]
                                                              .path
                                                              .split("/")
                                                              .last,
                                                          style: AppStyle
                                                              .DEFAULT_14,
                                                          maxLine: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          removeFilePick(
                                                              checkListImage(
                                                                      false,
                                                                      listPickFile)[
                                                                  index]);
                                                        },
                                                        child:
                                                            WidgetContainerImage(
                                                          image:
                                                              'assets/icons/icon_delete.png',
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
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: checkListImage(
                                                        true, listPickFile)
                                                    .length,
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  crossAxisSpacing: 25,
                                                  mainAxisSpacing: 25,
                                                  mainAxisExtent: 90,
                                                ),
                                                itemBuilder: (context, index) =>
                                                    Stack(
                                                  clipBehavior: Clip.none,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        PreviewImage(
                                                                          file: checkListImage(
                                                                              true,
                                                                              listPickFile)[index],
                                                                          module:
                                                                              widget.typeModule,
                                                                        )));
                                                      },
                                                      child: Container(
                                                        clipBehavior:
                                                            Clip.hardEdge,
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        height: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        decoration: BoxDecoration(
                                                            color: Colors.grey,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            8))),
                                                        child: Image.file(
                                                          checkListImage(true,
                                                                  listPickFile)[
                                                              index],
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          removeFilePick(
                                                              checkListImage(
                                                                      true,
                                                                      listPickFile)[
                                                                  index]);
                                                        },
                                                        child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color:
                                                                  Colors.white,
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .black,
                                                                  width: 0.1),
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
                                  ],
                                ),
                              ),
                            ));
                      } else {
                        return Container(
                            color: Colors.grey,
                            child: Center(child: CircularProgressIndicator()));
                      }
                    })
                : Center(
                    child: Text("Không có dữ liệu"),
                  ),
          ),
          StreamBuilder<bool?>(
              stream: status,
              builder: (context, snapshot) {
                return snapshot.data ?? false
                    ? Container(
                        color: Colors.white,
                        height: AppValue.widths * 0.1 + 10,
                        width: AppValue.widths,
                        padding: EdgeInsets.only(
                            left: AppValue.widths * 0.05,
                            right: AppValue.widths * 0.05,
                            bottom: 5),
                        child: Row(
                          children: [
                            GestureDetector(
                                onTap: this.onDinhKem,
                                child: SvgPicture.asset(
                                    "assets/icons/attack.svg")),
                            Spacer(),
                            GestureDetector(
                              onTap: () => onClickSave(),
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
                          ],
                        ),
                      )
                    : SizedBox();
              }),
        ],
      ),
    );
  }
}
