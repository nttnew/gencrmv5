import 'package:flutter/material.dart';
import '../../../../src/src_index.dart';
import '../../../../storages/share_local.dart';
import '../../../../widgets/widget_text.dart';

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
      margin: EdgeInsets.symmetric(horizontal: 25, vertical: 8),
      width: MediaQuery.of(context).size.width,
      child: Row(
        textDirection: isOwner ? TextDirection.rtl : null,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: COLORS.BLACK.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                )
              ],
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
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: isOwner ? COLORS.SECONDS_COLOR : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: COLORS.BLACK.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                    )
                  ],
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
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: double.maxFinite,
                        maxWidth: MediaQuery.of(context).size.width - 130,
                        minHeight: 0,
                        minWidth: 0,
                      ),
                      child: WidgetText(
                        title: widget.data.content ?? '',
                        style: AppStyle.DEFAULT_14.copyWith(
                          fontWeight: FontWeight.w500,
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
                          child: WidgetContainerImage(
                            image: ICONS.IC_EDIT_PNG,
                            width: 20,
                            height: 20,
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.onDelete(
                              widget.data.noteid,
                            );
                          },
                          child: WidgetContainerImage(
                            image: ICONS.IC_DELETE_PNG,
                            width: 20,
                            height: 20,
                            fit: BoxFit.contain,
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
