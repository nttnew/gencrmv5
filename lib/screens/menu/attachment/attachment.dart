import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gen_crm/src/app_const.dart';
import 'package:gen_crm/widgets/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../../src/src_index.dart';
import '../../../bloc/contract/detail_contract_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../src/models/model_generator/file_response.dart';
import '../../../widgets/appbar_base.dart';
import '../../../widgets/cupertino_loading.dart';
import '../../../widgets/item_file.dart';
import '../../add_service_voucher/preview_image.dart';

class Attachment extends StatefulWidget {
  Attachment({
    Key? key,
    required this.id,
    required this.typeModule,
  }) : super(key: key);
  final String id;
  final String typeModule;

  @override
  State<Attachment> createState() => _AttachmentState();
}

class _AttachmentState extends State<Attachment> {
  late final String id;
  late final String typeModule;
  static final List<String> pickOptions = [
    AppLocalizations.of(Get.context!)?.begin??'',
    AppLocalizations.of(Get.context!)?.after??''
  ];

  @override
  void initState() {
    id = widget.id;
    typeModule = widget.typeModule;
    DetailContractBloc.of(context).getFile(int.parse(id), typeModule);
    super.initState();
  }

  @override
  void deactivate() {
    DetailContractBloc.of(context).listFileStream.add(null);
    super.deactivate();
  }

  @override
  void dispose() {
    DetailContractBloc.of(context).listFileStream.close();
    super.dispose();
  }

  Future<void> _onDinhKem({bool? isAfter}) async {
    if (await Permission.storage.request().isGranted) {
      if (Platform.isAndroid) {
        ShowDialogCustom.showDialogBase(
          title: AppLocalizations.of(Get.context!)?.notification,
          content: AppLocalizations.of(Get.context!)?.you_have_not_granted_permission_to_access_the_photo,
          textButton2: AppLocalizations.of(Get.context!)?.go_to_setting,
          onTap2: () {
            openAppSettings();
            Get.back();
          },
        );
      } else {
        _pickFileDialog(isAfter: isAfter);
      }
    } else {
      _pickFileDialog(isAfter: isAfter);
    }
  }

  void _pickFile({bool? isAfter}) async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null && result.files.isNotEmpty) {
      List<File> listFilePiker = _handelListFile(result.files);
      await _saveFile(list: listFilePiker, isAfter: isAfter);
    }
  }

  List<File> _handelListFile(List<PlatformFile> files) {
    final List<File> list = [];
    for (final value in files) {
      list.add(File(value.path!));
    }
    return list;
  }

  List<File> _handelListImage(List<XFile> files) {
    final List<File> list = [];
    for (final value in files) {
      list.add(File(value.path));
    }
    return list;
  }

  void _pickFileDialog({bool? isAfter}) {
    showCupertinoModalPopup(
        context: Get.context!,
        builder: (context) => CupertinoActionSheet(
                cancelButton: CupertinoActionSheetAction(
                  child: Text(AppLocalizations.of(Get.context!)?.cancel??''),
                  onPressed: () {
                    AppNavigator.navigateBack();
                  },
                ),
                actions: [
                  CupertinoActionSheetAction(
                    onPressed: () async {
                      Get.back();
                      _getImageCamera(isAfter: isAfter);
                    },
                    child: Text(AppLocalizations.of(Get.context!)?.new_photo_shoot??''),
                  ),
                  CupertinoActionSheetAction(
                    onPressed: () async {
                      Get.back();
                      _getImageVideo(isAfter: isAfter);
                    },
                    child: Text(AppLocalizations.of(Get.context!)?.new_video_recoding??''),
                  ),
                  CupertinoActionSheetAction(
                    onPressed: () async {
                      Get.back();
                      _pickFile(isAfter: isAfter);
                    },
                    child: Text(AppLocalizations.of(Get.context!)?.pick_file??''),
                  ),
                  CupertinoActionSheetAction(
                    onPressed: () async {
                      Get.back();
                      _getImage(isAfter: isAfter);
                    },
                    child: Text(AppLocalizations.of(Get.context!)?.pick_photo??''),
                  ),
                ]));
  }

  Future _getImage({bool? isAfter}) async {
    try {
      final result = await ImagePicker().pickMultiImage();
      if (result.isNotEmpty) {
        List<File> listFilePiker = _handelListImage(result);
        await _saveFile(list: listFilePiker, isAfter: isAfter);
      }
    } on PlatformException catch (e) {
      throw e;
    }
  }

  List<FileDataResponse> _checkListImageApi({
    required bool isImage,
    required List<FileDataResponse> list,
    required int isAfter,
  }) {
    final List<FileDataResponse> listImage = [];
    final List<FileDataResponse> listFile = [];
    for (final value in list) {
      if ((value.is_after ?? IS_BEFORE) == isAfter) {
        if (AppValue.checkTypeImage(value.loaiFile.toString())) {
          listImage.add(value);
        } else {
          listFile.add(value);
        }
      }
    }
    if (isImage) {
      return listImage;
    } else {
      return listFile;
    }
  }

  Future<void> _saveFile({required List<File> list, bool? isAfter}) async {
    await DetailContractBloc.of(context)
        .uploadFile(
            id: widget.id,
            listFile: list,
            module: getURLModule(widget.typeModule),
            isAfter: isAfter)
        .then((value) {
      if (value) {
        DetailContractBloc.of(context)
            .getFile(int.parse(widget.id), widget.typeModule);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                '${AppLocalizations.of(Get.context!)?.add_attachment} '
                    '${value == true ?
                AppLocalizations.of(Get.context!)?.success.toLowerCase()
                    :
                AppLocalizations.of(Get.context!)?.fail.toLowerCase()}!')),
      );
    });
  }

  Future _getImageCamera({bool? isAfter}) async {
    try {
      final XFile? camera =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (camera != null) {
        await _saveFile(list: [File(camera.path)], isAfter: isAfter);
      }
    } on PlatformException catch (e) {
      throw e;
    }
  }

  Future _getImageVideo({bool? isAfter}) async {
    try {
      final XFile? cameraVideo =
          await ImagePicker().pickVideo(source: ImageSource.camera);
      if (cameraVideo != null) {
        await _saveFile(list: [File(cameraVideo.path)], isAfter: isAfter);
      }
    } on PlatformException catch (e) {
      throw e;
    }
  }

  Future<void> _removeFilePick(FileDataResponse file) async {
    await DetailContractBloc.of(context).deleteFileOnly(file).then((value) {
      if (value) {
        DetailContractBloc.of(context)
            .getFile(int.parse(widget.id), widget.typeModule);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                '${AppLocalizations.of(Get.context!)?.delete_attachment} '
                    '${value == true ?
                AppLocalizations.of(Get.context!)?.success.toLowerCase()
                    :
                AppLocalizations.of(Get.context!)?.fail.toLowerCase()}!')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
      appBar: AppbarBaseNormal(AppLocalizations.of(Get.context!)?.see_attachment),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WidgetText(
                title: AppLocalizations.of(Get.context!)?.select_attachment,
                style: AppStyle.DEFAULT_16.copyWith(
                    fontWeight: FontWeight.w700, color: Color(0xff006CB1))),
            GridView.builder(
              padding: EdgeInsets.only(top: 16),
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: pickOptions.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 25,
                mainAxisSpacing: 25,
                mainAxisExtent: 90,
              ),
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  _onDinhKem(isAfter: index == 1 ? true : null);
                },
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.publish_sharp,
                      ),
                      WidgetText(
                          title: pickOptions[index],
                          style: AppStyle.DEFAULT_16
                              .copyWith(fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Expanded(
              child: StreamBuilder<List<FileDataResponse>?>(
                  stream: DetailContractBloc.of(context).listFileStream,
                  builder: (context, snapshot) {
                    final list = snapshot.data;
                    if (list == null) {
                      return Container(
                        margin: EdgeInsets.only(top: 60),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: CupertinoLoading(),
                        ),
                      );
                    } else if (list == []) {
                      return Container(
                        margin: EdgeInsets.only(top: 60),
                        child: Align(
                            alignment: Alignment.topCenter,
                            child: WidgetText(
                                title: AppLocalizations.of(Get.context!)?.no_data??'',
                                style: AppStyle.DEFAULT_16.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ))),
                      );
                    }
                    return RefreshIndicator(
                      onRefresh: () async {
                        await DetailContractBloc.of(context)
                            .getFile(int.parse(widget.id), widget.typeModule);
                      },
                      child: Container(
                        height: double.maxFinite,
                        child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: Container(
                            margin: EdgeInsets.only(bottom: 36),
                            child: Column(
                              children: [
                                viewPickFile(list, AppLocalizations.of(Get.context!)?.begin??'', IS_BEFORE),
                                viewPickFile(list, AppLocalizations.of(Get.context!)?.after??'', IS_AFTER),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget viewPickFile(List<FileDataResponse> list, String title, int isAfter) {
    return Column(
      children: [
        if (_checkListImageApi(isImage: false, list: list, isAfter: isAfter)
                .isNotEmpty ||
            _checkListImageApi(isImage: true, list: list, isAfter: isAfter)
                .isNotEmpty) ...[
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: WidgetText(
                    title: title,
                    style: AppStyle.DEFAULT_16.copyWith(
                        fontWeight: FontWeight.w700, color: Color(0xff006CB1))),
              )
            ],
          ),
          Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              width: Get.width,
              child: Column(
                children: [
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _checkListImageApi(
                            isImage: false, list: list, isAfter: isAfter)
                        .length,
                    itemBuilder: (context, index) => ItemFile(
                      file: _checkListImageApi(
                          isImage: false, list: list, isAfter: isAfter)[index],
                      functionMy: () {
                        _removeFilePick(_checkListImageApi(
                            isImage: false,
                            list: list,
                            isAfter: isAfter)[index]);
                      },
                    ),
                  ),
                  if (_checkListImageApi(
                          isImage: true, list: list, isAfter: isAfter)
                      .isNotEmpty)
                    GridView.builder(
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _checkListImageApi(
                              isImage: true, list: list, isAfter: isAfter)
                          .length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                                        isNetwork: true,
                                        file: File(_checkListImageApi(
                                                    isImage: true,
                                                    list: list,
                                                    isAfter: isAfter)[index]
                                                .link ??
                                            ''),
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
                              child: Image.network(
                                _checkListImageApi(
                                            isImage: true,
                                            list: list,
                                            isAfter: isAfter)[index]
                                        .link ??
                                    '',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            child: InkWell(
                              onTap: () {
                                _removeFilePick(_checkListImageApi(
                                    isImage: true,
                                    list: list,
                                    isAfter: isAfter)[index]);
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.black, width: 0.1),
                                  ),
                                  height: 24,
                                  width: 24,
                                  child: Icon(
                                    Icons.close,
                                    size: 16,
                                  )),
                            ),
                            top: -1,
                            right: -1,
                          )
                        ],
                      ),
                    )
                ],
              )),
        ]
      ],
    );
  }
}
