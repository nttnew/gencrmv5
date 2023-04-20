import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/list_note/list_note_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../src/src_index.dart';
import '../../../../widgets/widget_text.dart';

class ListNote extends StatefulWidget {
  ListNote(
      {Key? key,
      required this.type,
      required this.id,
      this.size = 40,
      this.isAdd = false,
      this.onEdit,
      this.onDelete})
      : super(key: key);

  final int type;
  final String id;
  final double size;
  final bool isAdd;
  Function? onEdit;
  Function? onDelete;

  @override
  State<ListNote> createState() => _ListNoteState();
}

class _ListNoteState extends State<ListNote> {
  String page = "1";

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (widget.type == 1) {
        ListNoteBloc.of(context).add(InitNoteCusEvent(widget.id, page));
      } else if (widget.type == 2) {
        ListNoteBloc.of(context).add(InitNoteContactEvent(widget.id, page));
      } else if (widget.type == 3) {
        ListNoteBloc.of(context).add(InitNoteOppEvent(widget.id, page));
      } else if (widget.type == 4) {
        ListNoteBloc.of(context).add(InitNoteContractEvent(widget.id, page));
      } else if (widget.type == 5) {
        ListNoteBloc.of(context).add(InitNoteJobEvent(widget.id, page));
      } else if (widget.type == 6) {
        ListNoteBloc.of(context).add(InitNoteSupEvent(widget.id, page));
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    page = "1";
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
              Column(
                children: [
                  SizedBox(
                    height: AppValue.heights * 0.02,
                  ),
                  WidgetText(
                    title: "Thảo luận",
                    style: TextStyle(
                        fontFamily: "Quicksand",
                        color: HexColor("#263238"),
                        fontWeight: FontWeight.w700,
                        fontSize: 14),
                  ),
                  SizedBox(
                    height: AppValue.heights * 0.02,
                  ),
                ],
              ),
            ...List.generate(
                state.data.length,
                (index) => Container(
                      padding: EdgeInsets.only(bottom: 8, top: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 6),
                            child: WidgetNetworkImage(
                              image: state.data[index].avatar ?? '',
                              width: widget.size,
                              height: widget.size,
                              borderRadius: widget.size,
                            ),
                          ),
                          AppValue.hSpaceTiny,
                          Expanded(
                            child: Container(
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
                                    style: AppStyle.DEFAULT_12
                                        .copyWith(color: Color(0xff838A91)),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  WidgetText(
                                    title: state.data[index].content ?? '',
                                    style: AppStyle.DEFAULT_14
                                        .copyWith(fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                            ),
                          ),
                          widget.isAdd == true
                              ? Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        widget.onEdit!(state.data[index].noteid,
                                            state.data[index].content);
                                      },
                                      child: WidgetContainerImage(
                                        image: ICONS.IC_EDIT_PNG,
                                        width: 25,
                                        height: 25,
                                        fit: BoxFit.contain,
                                        borderRadius: BorderRadius.circular(0),
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
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                    )
                                  ],
                                )
                              : Container()
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
