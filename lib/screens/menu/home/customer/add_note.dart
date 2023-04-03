import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/list_note/add_note_bloc.dart';
import 'package:gen_crm/screens/menu/home/customer/list_note.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../bloc/list_note/list_note_bloc.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/widget_dialog.dart';
import '../../../../widgets/widget_text.dart';

class AddNote extends StatefulWidget {
  AddNote({Key? key}) : super(key: key);

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  String id = Get.arguments[1];
  int type = Get.arguments[0];
  TextEditingController _editingController = TextEditingController();
  bool isEdit = false;
  late FocusNode _focusNode;
  String noteId = "";

  @override
  void initState() {
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: AppValue.heights * 0.1,
          backgroundColor: HexColor("#D0F1EB"),
          centerTitle: false,
          title: WidgetText(
              title: "Thảo luận",
              style: AppStyle.DEFAULT_16.copyWith(fontWeight: FontWeight.w700)),
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
        body: Container(
          padding: EdgeInsets.all(16),
          child: BlocListener<AddNoteBloc, AddNoteState>(
            listener: (context, state) async {
              if (state is SuccessAddNoteState) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return WidgetDialog(
                      title: MESSAGES.NOTIFICATION,
                      content: "Thành công",
                      textButton1: "OK",
                      backgroundButton1: COLORS.PRIMARY_COLOR,
                      onTap1: () {
                        _editingController.text = "";
                        isEdit = false;
                        noteId = "";
                        Get.back();
                        if (type == 1) {
                          ListNoteBloc.of(context)
                              .add(InitNoteCusEvent(id, "1"));
                        } else if (type == 2) {
                          ListNoteBloc.of(context)
                              .add(InitNoteContactEvent(id, "1"));
                        } else if (type == 3) {
                          ListNoteBloc.of(context)
                              .add(InitNoteOppEvent(id, "1"));
                        } else if (type == 4) {
                          ListNoteBloc.of(context)
                              .add(InitNoteContractEvent(id, "1"));
                        } else if (type == 5) {
                          ListNoteBloc.of(context)
                              .add(InitNoteJobEvent(id, "1"));
                        } else if (type == 6) {
                          ListNoteBloc.of(context)
                              .add(InitNoteSupEvent(id, "1"));
                        }
                      },
                    );
                  },
                );
              } else if (state is ErrorAddNoteState) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return WidgetDialog(
                      title: MESSAGES.NOTIFICATION,
                      content: state.msg,
                      textButton1: "Quay lại",
                      onTap1: () {
                        Get.back();
                      },
                    );
                  },
                );
              } else if (state is ErrorDeleteNoteState) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return WidgetDialog(
                      title: MESSAGES.NOTIFICATION,
                      content: state.msg,
                      textButton1: "Quay lại",
                      onTap1: () {
                        Get.back();
                      },
                    );
                  },
                );
              }
            },
            child: Column(
              children: [
                Expanded(
                    child: SingleChildScrollView(
                        child: ListNote(
                  type: type,
                  id: id,
                  size: 55,
                  isAdd: true,
                  onEdit: (uid, content) {
                    _editingController.text = content;
                    noteId = uid.toString();
                    _focusNode.requestFocus();
                    isEdit = true;
                  },
                  onDelete: (id) {
                    this.onDeleteNote(id);
                  },
                ))),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: COLORS.GREY),
                      borderRadius: BorderRadius.circular(15)),
                  padding: EdgeInsets.only(left: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _editingController,
                          focusNode: _focusNode,
                          decoration: InputDecoration(
                              hintText: "Nhập nội dung",
                              contentPadding: EdgeInsets.zero,
                              enabledBorder: InputBorder.none,
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              errorBorder: InputBorder.none),
                        ),
                      ),
                      GestureDetector(
                        onTap: this.onSend,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          child: WidgetContainerImage(
                            image: 'assets/icons/send.png',
                            width: 25,
                            height: 25,
                            fit: BoxFit.contain,
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  void onSend() {
    if (isEdit == false) {
      AddNoteBloc.of(context)
          .add(InitAddNoteEvent(id, _editingController.text, type));
    } else {
      AddNoteBloc.of(context)
          .add(InitEditNoteEvent(id, _editingController.text, noteId, type));
    }
  }

  void onDeleteNote(nid) {
    AddNoteBloc.of(context).add(InitDeleteNoteEvent(id, type, nid));
  }
}
