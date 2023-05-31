import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/list_note/list_note_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/widget_text.dart';
import 'item_note.dart';

class ListNote extends StatefulWidget {
  ListNote({
    Key? key,
    required this.module,
    required this.id,
    this.size = 40,
    this.isAdd = false,
  }) : super(key: key);

  final String module;
  final String id;
  final double size;
  final bool isAdd;

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
              (index) => ItemNote(
                data: state.data[index],
                size: widget.size,
                isAdd: widget.isAdd,
                onDelete: () {},
                onEdit: () {},
              ),
            )
          ],
        );
      } else
        return Container();
    });
  }
}
