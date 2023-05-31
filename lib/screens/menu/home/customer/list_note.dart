import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/list_note/list_note_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/widget_text.dart';

class ListNote extends StatefulWidget {
  ListNote(
      {Key? key,
      required this.module,
      required this.id,
      this.size = 40,
      this.isAdd = false,
      this.onEdit,
      this.onDelete})
      : super(key: key);

  final String module;
  final String id;
  final double size;
  final bool isAdd;
  Function? onEdit;
  Function? onDelete;

  @override
  State<ListNote> createState() => _ListNoteState();
}

class _ListNoteState extends State<ListNote> {
  String page = BASE_URL.PAGE_DEFAULT.toString();
  Timer? _debounce;

  @override
  void initState() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    int millisecondsMy = 350;
    if (widget.module == Module.CO_HOI_BH) {
      millisecondsMy = 700;
    } else if (widget.module == Module.HOP_DONG ||
        widget.module == Module.HO_TRO) {
      millisecondsMy = 0;
    }
    if (widget.isAdd) millisecondsMy = 0;
    _debounce = Timer(Duration(milliseconds: millisecondsMy), () {
      ListNoteBloc.of(context)
          .add(InitNoteEvent(widget.id, page, widget.module, widget.isAdd));
    });
    super.initState();
  }

  @override
  void deactivate() {
    if (!widget.isAdd) ListNoteBloc.of(context).add(ReloadEvent());
    super.deactivate();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    page = BASE_URL.PAGE_DEFAULT.toString();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListNoteBloc, ListNoteState>(builder: (context, state) {
      if (state is SuccessGetNoteOppState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (state.data.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(25),
                child: WidgetText(
                  title: "Thảo luận",
                  style: TextStyle(
                      fontFamily: "Quicksand",
                      color: HexColor("#263238"),
                      fontWeight: FontWeight.w700,
                      fontSize: 14),
                ),
              ),
            ...List.generate(
                state.data.length,
                (index) => Container(
                      margin: EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
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
                              image: state.data[index].avatar ?? '',
                              width: widget.size,
                              height: widget.size,
                              borderRadius: widget.size,
                            ),
                          ),
                          AppValue.hSpaceTiny,
                          Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white,
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
                                  title: state.data[index].uname ?? '',
                                  style: AppStyle.DEFAULT_14
                                      .copyWith(fontWeight: FontWeight.w600),
                                ),
                                WidgetText(
                                  title: state.data[index].passedtime ?? '',
                                  style: AppStyle.DEFAULT_14
                                      .copyWith(color: Color(0xff838A91)),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxHeight: double.maxFinite,
                                        maxWidth:
                                            MediaQuery.of(context).size.width -
                                                130,
                                        minHeight: 0,
                                        minWidth: 0,
                                      ),
                                      child: WidgetText(
                                        title: state.data[index].content ?? '',
                                        style: AppStyle.DEFAULT_14.copyWith(
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    if (widget.isAdd)
                                      Column(
                                        children: [
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  widget.onEdit!(
                                                      state.data[index].noteid,
                                                      state
                                                          .data[index].content);
                                                },
                                                child: WidgetContainerImage(
                                                  image: ICONS.IC_EDIT_PNG,
                                                  width: 25,
                                                  height: 25,
                                                  fit: BoxFit.contain,
                                                  borderRadius:
                                                      BorderRadius.circular(0),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  widget.onDelete!(
                                                      state.data[index].noteid);
                                                },
                                                child: WidgetContainerImage(
                                                  image: ICONS.IC_DELETE_PNG,
                                                  width: 25,
                                                  height: 25,
                                                  fit: BoxFit.contain,
                                                  borderRadius:
                                                      BorderRadius.circular(0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ))
          ],
        );
      } else
        return Container();
    });
  }
}
