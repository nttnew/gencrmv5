import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/list_note/add_note_bloc.dart';
import 'package:gen_crm/screens/menu/home/customer/list_note.dart';
import 'package:gen_crm/widgets/appbar_base.dart';
import 'package:get/get.dart';
import '../../../../bloc/list_note/list_note_bloc.dart';
import '../../../../src/src_index.dart';

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
        appBar: AppbarBaseNormal('Thảo luận'),
        body: Container(
          padding: EdgeInsets.all(16),
          child: BlocListener<AddNoteBloc, AddNoteState>(
            listener: (context, state) async {
              if (state is SuccessAddNoteState) {
                _editingController.text = '';
                FocusManager.instance.primaryFocus?.unfocus();
                if (type == 1) {
                  ListNoteBloc.of(context).add(InitNoteCusEvent(id, "1"));
                } else if (type == 2) {
                  ListNoteBloc.of(context).add(InitNoteContactEvent(id, "1"));
                } else if (type == 3) {
                  ListNoteBloc.of(context).add(InitNoteOppEvent(id, "1"));
                } else if (type == 4) {
                  ListNoteBloc.of(context).add(InitNoteContractEvent(id, "1"));
                } else if (type == 5) {
                  ListNoteBloc.of(context).add(InitNoteJobEvent(id, "1"));
                } else if (type == 6) {
                  ListNoteBloc.of(context).add(InitNoteSupEvent(id, "1"));
                }
              } else if (state is ErrorAddNoteState) {
                ShowDialogCustom.showDialogBase(
                  title: MESSAGES.NOTIFICATION,
                  content: state.msg,
                  textButton1: "Quay lại",
                );
              } else if (state is ErrorDeleteNoteState) {
                ShowDialogCustom.showDialogBase(
                  title: MESSAGES.NOTIFICATION,
                  content: state.msg,
                  textButton1: "Quay lại",
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
                          textCapitalization: TextCapitalization.sentences,
                          textInputAction: TextInputAction.send,
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
                            image: ICONS.IC_SEND_PNG,
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
