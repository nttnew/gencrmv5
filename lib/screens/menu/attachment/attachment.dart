import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gen_crm/screens/menu/attachment/attachmentItem.dart';
import 'package:gen_crm/widgets/widgets.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../src/src_index.dart';
import '../../../../../widgets/widget_text.dart';
import '../../../src/models/model_generator/attach_file.dart';

class Attachment extends StatefulWidget {
  Attachment({Key? key}) : super(key: key);

  @override
  State<Attachment> createState() => _AttachmentState();
}

class _AttachmentState extends State<Attachment> {
  late final String id;
  late final String name;
  late final List<AttachFile> listFile;

  List<File> filePicked = [];
  @override
  void initState() {
    id = Get.arguments[0];
    name = Get.arguments[1];
    listFile = Get.arguments[2];
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  onDinhKem() async {
    ImagePicker picker = ImagePicker();
    XFile? result = await picker.pickImage(
        source: ImageSource.gallery, preferredCameraDevice: CameraDevice.rear);
    if (result != null) {
      bool fileExist = false;
      for (var element in filePicked) {
        if (element.path.split('/').last == result.path.split('/').last) {
          fileExist = true;
          break;
        }
      }
      if (fileExist == false) {
        setState(() {
          filePicked.add(File(result.path));
        });
      }
    } else {
      // User canceled the picker
    }
  }

  onClickSave() {
    AppNavigator.navigateBack();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.startDocked,
          // floatingActionButton: Column(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     if (filePicked.isNotEmpty) FloatingButton(widget: Icon(Icons.upload, size: 40), function: onClickSave),
          //     FloatingButton(function: onDinhKem),
          //   ],
          // ),
          appBar: AppBar(
            toolbarHeight: AppValue.heights * 0.1,
            backgroundColor: HexColor("#D0F1EB"),
            centerTitle: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                WidgetText(
                    title: "Xem đính kèm",
                    style: AppStyle.DEFAULT_16
                        .copyWith(fontWeight: FontWeight.w700))
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
          body: filePicked.isNotEmpty || listFile.isNotEmpty
              ? Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            if (listFile.isNotEmpty)
                              Row(
                                children: [
                                  Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5),
                                      child: WidgetText(
                                        title: "Tệp đã chọn",
                                        style: AppStyle.DEFAULT_16_BOLD,
                                      )),
                                ],
                              ),
                            if (listFile.isNotEmpty)
                              ...List<Widget>.generate(
                                  listFile.length,
                                  (i) => AttachmentItem(
                                        filePath: listFile[i]
                                            .fileName
                                            .split('/')
                                            .last,
                                        onDelete: () {
                                          setState(() {
                                            listFile.removeAt(i);
                                          });
                                        },
                                      )),
                            if (filePicked.isNotEmpty)
                              Row(
                                children: [
                                  Padding(
                                      padding: EdgeInsets.only(
                                          bottom: 5,
                                          top: AppValue.FONT_SIZE_14),
                                      child: WidgetText(
                                        title: "Tệp vừa chọn",
                                        style: AppStyle.DEFAULT_16_BOLD,
                                      )),
                                ],
                              ),
                            if (filePicked.isNotEmpty)
                              ...List.generate(
                                  filePicked.length,
                                  (i) => AttachmentItem(
                                        filePath:
                                            filePicked[i].path.split('/').last,
                                        onDelete: () {
                                          setState(() {
                                            filePicked.removeAt(i);
                                          });
                                        },
                                      )),
                          ],
                        ),
                      ),
                    ],
                  ))
              : Center(
                  child: Text("Không có dữ liệu"),
                ),
        ),
        Positioned(
          left: 0,
          bottom: 0,
          child: Container(
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
                    child: SvgPicture.asset("assets/icons/attack.svg")),
                Spacer(),
                GestureDetector(
                  onTap: this.onClickSave,
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
            ),
          ),
        )
      ],
    );
  }
}
