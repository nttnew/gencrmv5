import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gen_crm/screens/form/widget/preview_image.dart';
import 'package:gen_crm/screens/widget/widget_label.dart';
import 'package:gen_crm/storages/share_local.dart';
import '../../../../src/models/model_generator/add_customer.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/pick_file_image.dart';

//done new ui
class FieldImage extends StatefulWidget {
  const FieldImage({
    Key? key,
    required this.data,
    required this.onChange,
    this.init,
  }) : super(key: key);

  final CustomerIndividualItemData data;
  final Function(List<File>) onChange;
  final List<dynamic>? init;
  @override
  State<FieldImage> createState() => _FieldImageState();
}

class _FieldImageState extends State<FieldImage> {
  List<File> _listFiled = [];

  @override
  void initState() {
    _listFiled = widget.init
            ?.map((e) => File(
                shareLocal.getString(PreferencesKey.URL_BASE) + e.toString()))
            .toList() ??
        [];
    widget.onChange(_listFiled);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isNoEdit = widget.data.field_read_only.toString() == '1';
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border:
            Border.all(color: isNoEdit ? COLORS.LIGHT_GREY : COLORS.COLOR_GRAY),
      ),
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(bottom: 20),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          WidgetLabelPo(data: widget.data),
          Column(
            children: [
              if (!isNoEdit) ...[
                SizedBox(
                  height: 8,
                ),
                GestureDetector(
                  onTap: () async {
                    await onDinhKemBase(context, isImage: true)
                        .then((listFile) {
                      if (listFile != []) {
                        _listFiled.addAll(listFile);
                        widget.onChange(_listFiled);
                        setState(() {});
                      }
                    });
                  },
                  child: Center(
                    child: Image.asset(
                      ICONS.IC_UPLOAD_IMAGE_PNG,
                      height: 50,
                      width: 50,
                    ),
                  ),
                ),
              ],
              GridView.builder(
                padding: EdgeInsets.all(16),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _listFiled.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                              file: _listFiled[index],
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
                          _listFiled[index],
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Image.network(
                            _listFiled[index].path,
                            errorBuilder: (_, __, ___) => SizedBox(),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    if (!isNoEdit)
                      Positioned(
                        child: InkWell(
                          onTap: () {
                            _listFiled.removeAt(index);
                            widget.onChange(_listFiled);
                            setState(() {});
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
                              size: 16,
                            ),
                          ),
                        ),
                        top: -1,
                        right: -1,
                      )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
