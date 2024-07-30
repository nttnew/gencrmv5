import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../../../src/src_index.dart';
import '../../../../../storages/share_local.dart';
import '../../../../../widgets/widget_text.dart';

class ItemNote extends StatefulWidget {
  const ItemNote({
    Key? key,
    required this.data,
    required this.size,
    required this.isAdd,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);
  final dynamic data;
  final double size;
  final bool isAdd;
  final Function onDelete;
  final Function onEdit;

  @override
  State<ItemNote> createState() => _ItemNoteState();
}

class _ItemNoteState extends State<ItemNote> {
  late final bool isOwner;
  @override
  void initState() {
    final String idUser =
        shareLocal.getString(PreferencesKey.ID_USER).toString();
    isOwner = idUser == widget.data.uid.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      width: MediaQuery.of(context).size.width,
      child: Row(
        textDirection: isOwner ? TextDirection.rtl : null,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: COLORS.WHITE,
              shape: BoxShape.circle,
              boxShadow: boxShadowVip,
            ),
            child: WidgetNetworkImage(
              isAvatar: true,
              image: widget.data.avatar ?? '',
              width: widget.size,
              height: widget.size,
              borderRadius: widget.size,
            ),
          ),
          AppValue.hSpaceTiny,
          Column(
            crossAxisAlignment:
                !isOwner ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: isOwner ? COLORS.SECONDS_COLOR : COLORS.WHITE,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: boxShadowVipPro,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          WidgetText(
                            title: widget.data.uname ?? '',
                            style: AppStyle.DEFAULT_14.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          WidgetText(
                            title: widget.data.passedtime ?? '',
                            style: AppStyle.DEFAULT_14
                                .copyWith(color: Color(0xff838A91)),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: double.maxFinite,
                          maxWidth: MediaQuery.of(context).size.width - 130,
                          minHeight: 0,
                          minWidth: 0,
                        ),
                        child: Html(
                          data: widget.data.content ?? '',
                          shrinkWrap: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.isAdd)
                Column(
                  children: [
                    SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            widget.onEdit(
                              widget.data.noteid,
                              widget.data.content,
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              border: Border.all(color: COLORS.BLACK),
                              shape: BoxShape.circle,
                              boxShadow: boxShadowVipPro,
                              color: COLORS.WHITE,
                            ),
                            child: Icon(
                              Icons.edit_outlined,
                              size: 14,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.onDelete(
                              widget.data.noteid,
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              border: Border.all(color: COLORS.BLACK),
                              shape: BoxShape.circle,
                              boxShadow: boxShadowVipPro,
                              color: COLORS.WHITE,
                            ),
                            child: Icon(
                              Icons.delete_outline_outlined,
                              size: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
            ],
          ),
        ],
      ),
    );
  }
}

Widget htmlBase(data) => Html(shrinkWrap: true, data: data);
