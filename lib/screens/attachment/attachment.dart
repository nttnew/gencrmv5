import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gen_crm/src/app_const.dart';
import 'package:gen_crm/widgets/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../src/src_index.dart';
import '../../../bloc/contract/detail_contract_bloc.dart';
import '../../../l10n/key_text.dart';
import '../../../src/models/model_generator/file_response.dart';
import '../../../widgets/appbar_base.dart';
import '../../../widgets/cupertino_loading.dart';
import '../../../widgets/item_file.dart';
import '../../../widgets/pick_file_image.dart';
import '../form/widget/preview_image.dart';

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
  static final List<String> pickOptions = [getT(KeyT.begin), getT(KeyT.after)];
  late final DetailContractBloc _bloc;

  @override
  void initState() {
    _bloc = DetailContractBloc.of(context);
    id = widget.id;
    typeModule = widget.typeModule;
    _bloc.getFile(int.parse(id), typeModule);
    super.initState();
  }

  @override
  void dispose() {
    _bloc.listFileStream.add(null);
    super.dispose();
  }

  Future<void> _onDinhKem({bool? isAfter}) async {
    _pickFileDialog(isAfter: isAfter);
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
                  child: Text(getT(KeyT.cancel)),
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
                    child: Text(getT(KeyT.new_photo_shoot)),
                  ),
                  CupertinoActionSheetAction(
                    onPressed: () async {
                      Get.back();
                      _getImageVideo(isAfter: isAfter);
                    },
                    child: Text(getT(KeyT.new_video_recoding)),
                  ),
                  CupertinoActionSheetAction(
                    onPressed: () async {
                      Get.back();
                      _pickFile(isAfter: isAfter);
                    },
                    child: Text(getT(KeyT.pick_file)),
                  ),
                  CupertinoActionSheetAction(
                    onPressed: () async {
                      Get.back();
                      _getImage(isAfter: isAfter);
                    },
                    child: Text(getT(KeyT.pick_photo)),
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

  List<FileDataResponse> _checkListImageOrFileApi({
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

  Future<void> _saveFile({
    required List<File> list,
    bool? isAfter,
  }) async {
    await _bloc
        .uploadFile(
            id: widget.id,
            listFile: list,
            module: getURLModule(widget.typeModule),
            isAfter: isAfter)
        .then((value) {
      if (value == SUCCESS) {
        _bloc.getFile(int.parse(widget.id), widget.typeModule);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${getT(KeyT.add_attachment)} '
            '${value == SUCCESS ? getT(KeyT.success.toLowerCase()) : '${getT(KeyT.fail.toLowerCase())}: ${value}'}!',
          ),
        ),
      );
    });
  }

  Future _getImageCamera({bool? isAfter}) async {
    try {
      final XFile? camera =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (camera != null) {
        final File duoi2MB = await compressImage(File(camera.path));
        await _saveFile(list: [duoi2MB], isAfter: isAfter);
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
        await _saveFile(
          list: [File(cameraVideo.path)],
          isAfter: isAfter,
        );
      }
    } on PlatformException catch (e) {
      throw e;
    }
  }

  Future<void> _removeFilePick(FileDataResponse file) async {
    // Xoá file trên UI
    final List<FileDataResponse> _listData = _bloc.listFileStream.value ?? [];
    _listData.remove(file);
    _bloc.listFileStream.add(_listData);
    // Xoá file trên BE
    await _bloc.deleteFileOnly(file).then((value) {
      if (value == '') {
        _bloc.getFile(int.parse(widget.id), widget.typeModule);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${value == '' ? '${getT(KeyT.delete_attachment)} '
                  '${getT(KeyT.success.toLowerCase()).toLowerCase()}' : value}!',
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLORS.WHITE,
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
      appBar: AppbarBaseNormal(getT(KeyT.see_attachment)),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WidgetText(
              title: getT(KeyT.select_attachment),
              style: AppStyle.DEFAULT_16.copyWith(
                fontWeight: FontWeight.w700,
                color: COLORS.TEXT_COLOR,
              ),
            ),
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
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        8,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.publish_sharp,
                      ),
                      WidgetText(
                        title: pickOptions[index],
                        style: AppStyle.DEFAULT_16.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
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
                  stream: _bloc.listFileStream,
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
                            title: getT(KeyT.no_data),
                            style: AppStyle.DEFAULT_16.copyWith(
                              fontWeight: FontWeight.w700,
                              color: COLORS.BLACK,
                            ),
                          ),
                        ),
                      );
                    }
                    return RefreshIndicator(
                      color: getBackgroundWithIsCar(),
                      onRefresh: () async {
                        await _bloc.getFile(
                            int.parse(widget.id), widget.typeModule);
                      },
                      child: Container(
                        height: double.maxFinite,
                        child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: Container(
                            margin: EdgeInsets.only(bottom: 36),
                            child: Column(
                              children: [
                                viewPickFile(list, getT(KeyT.begin), IS_BEFORE),
                                viewPickFile(list, getT(KeyT.after), IS_AFTER),
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
    final listImage =
        _checkListImageOrFileApi(isImage: true, list: list, isAfter: isAfter);
    final listFile =
        _checkListImageOrFileApi(isImage: false, list: list, isAfter: isAfter);
    return Column(
      children: [
        if (listImage.isNotEmpty || listFile.isNotEmpty) ...[
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: WidgetText(
                  title: title,
                  style: AppStyle.DEFAULT_16.copyWith(
                    fontWeight: FontWeight.w700,
                    color: COLORS.TEXT_COLOR,
                  ),
                ),
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
                  itemCount: listFile.length,
                  itemBuilder: (context, index) => ItemFile(
                    file: listFile[index],
                    functionMy: () {
                      _removeFilePick(listFile[index]);
                    },
                  ),
                ),
                if (listImage.isNotEmpty)
                  GridView.builder(
                    padding: EdgeInsets.zero,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: listImage.length,
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
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => PreviewImage(
                                  isNetwork: true,
                                  file: File(listImage[index].link ?? ''),
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
                                Radius.circular(8),
                              ),
                            ),
                            child: Image.network(
                              listImage[index].link ?? '',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          child: InkWell(
                            onTap: () {
                              _removeFilePick(listImage[index]);
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: COLORS.WHITE,
                                  border: Border.all(
                                    color: COLORS.BLACK,
                                    width: 0.1,
                                  ),
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
            ),
          ),
        ]
      ],
    );
  }
}
