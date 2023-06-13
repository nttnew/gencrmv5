import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/list_note/add_note_bloc.dart';
import 'package:gen_crm/bloc/list_note/list_note_bloc.dart';
import '../../../src/app_const.dart';
import '../../../src/src_index.dart';
import 'package:rxdart/rxdart.dart';
import 'package:gen_crm/widgets/appbar_base.dart';
import 'package:get/get.dart';
import '../../../widgets/loading_api.dart';
import '../home/customer/widget/item_note.dart';

class AddNote extends StatefulWidget {
  AddNote({Key? key}) : super(key: key);

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  String id = Get.arguments[1];
  String module = Get.arguments[0];
  TextEditingController _editingController = TextEditingController();
  bool isEdit = false;
  late FocusNode _focusNode;
  String noteId = "";
  late final LoadMoreControllerReverse _controllerNote;

  @override
  void initState() {
    _controllerNote = LoadMoreControllerReverse();
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
          child: BlocListener<AddNoteBloc, AddNoteState>(
            listener: (context, state) async {
              if (state is SuccessAddNoteState) {
                isEdit = false;
                _editingController.text = '';
                FocusManager.instance.primaryFocus?.unfocus();
                _controllerNote.reloadData();
              } else if (state is ErrorAddNoteState) {
                LoadingApi().popLoading();
                ShowDialogCustom.showDialogBase(
                  title: MESSAGES.NOTIFICATION,
                  content: state.msg,
                  textButton1: "ok",
                );
              } else if (state is ErrorDeleteNoteState) {
                LoadingApi().popLoading();
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
                  child: ListNote(
                    module: module,
                    id: id,
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
                    controllerNote: _controllerNote,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: COLORS.BLACK.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                      )
                    ],
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: COLORS.GREY),
                        borderRadius: BorderRadius.circular(15)),
                    padding: EdgeInsets.only(
                      left: 8,
                    ),
                    margin: EdgeInsets.only(
                      left: 25,
                      right: 25,
                      bottom: 25,
                      top: 15,
                    ),
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
          .add(InitAddNoteEvent(id, _editingController.text, module));
    } else {
      AddNoteBloc.of(context)
          .add(EditNoteEvent(id, _editingController.text, noteId, module));
    }
  }

  void onDeleteNote(nid) {
    AddNoteBloc.of(context).add(DeleteNoteEvent(id, nid, module));
  }
}

class ListNote extends StatefulWidget {
  ListNote({
    Key? key,
    required this.module,
    required this.id,
    this.size = 40,
    this.isAdd = false,
    required this.onEdit,
    required this.onDelete,
    required this.controllerNote,
  }) : super(key: key);

  final LoadMoreControllerReverse controllerNote;
  final String module;
  final String id;
  final double size;
  final bool isAdd;
  Function onEdit;
  Function onDelete;

  @override
  State<ListNote> createState() => _ListNoteState();
}

class _ListNoteState extends State<ListNote> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListViewLoadMoreReverseBase(
      isInit: true,
      controller: widget.controllerNote,
      functionInit: (page, isInit) {
        return ListNoteBloc.of(context).getListNote(
          id: widget.id,
          module: widget.module,
          page: page.toString(),
          isAdd: widget.isAdd,
          isInit: isInit,
        );
      },
      itemWidget: (int index, data) {
        return ItemNote(
          data: data,
          size: widget.size,
          isAdd: widget.isAdd,
          onDelete: widget.onDelete,
          onEdit: widget.onEdit,
        );
      },
    );
  }
}

class ListViewLoadMoreReverseBase extends StatefulWidget {
  const ListViewLoadMoreReverseBase({
    Key? key,
    required this.functionInit,
    required this.itemWidget,
    required this.controller,
    this.isInit = false,
  }) : super(key: key);
  final Future<dynamic> Function(int page, bool isInit) functionInit;
  final Function(int index, dynamic data) itemWidget;
  final LoadMoreControllerReverse controller;
  final bool isInit;

  @override
  State<ListViewLoadMoreReverseBase> createState() =>
      _ListViewLoadMoreReverseBaseState();
}

class _ListViewLoadMoreReverseBaseState
    extends State<ListViewLoadMoreReverseBase>
    with AutomaticKeepAliveClientMixin {
  late final LoadMoreControllerReverse _controller;

  @override
  void initState() {
    _controller = widget.controller;
    _controller.functionInit = widget.functionInit;
    super.initState();
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (widget.isInit) _controller.loadData(_controller.page);
        _controller.handelLoadMore();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder<List<dynamic>>(
        stream: _controller.streamList,
        builder: (context, snapshot) {
          final list = snapshot.data ?? [];
          if (list.isNotEmpty) {
            return ListView.builder(
                reverse: true,
                padding: EdgeInsets.only(top: 8, bottom: 8),
                controller: _controller.controller,
                shrinkWrap: true,
                itemCount: list.length,
                itemBuilder: (context, index) =>
                    widget.itemWidget(index, list[index]));
          } else {
            return noData();
          }
        });
  }

  @override
  bool get wantKeepAlive => true;
}

class LoadMoreControllerReverse<T> {
  final BehaviorSubject<List<dynamic>> streamList = BehaviorSubject();
  final ScrollController controller = ScrollController();
  bool isLoadMore = true;
  int page = BASE_URL.PAGE_DEFAULT;
  Future<dynamic> Function(int page, bool isInit)? functionInit;

  reloadData() {
    page = BASE_URL.PAGE_DEFAULT;
    loadData(page);
    isLoadMore = true;
  }

  initData(List<dynamic> list) {
    streamList.add(list);
  }

  handelLoadMore() {
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset &&
          isLoadMore) {
        page = page + 1;
        loadData(page);
      }
    });
  }

  dispose() {
    streamList.add([]);
    isLoadMore = true;
    page = BASE_URL.PAGE_DEFAULT;
    functionInit = null;
  }

  loadData(int page, {bool isInit = true}) async {
    if (functionInit != null) {
      final result = await functionInit!(page, isInit);
      if (result.runtimeType == String) {
        ShowDialogCustom.showDialogBase(
          title: MESSAGES.NOTIFICATION,
          content: result,
        );
      } else {
        if (result != null) {
          isLoadMore = result.length == BASE_URL.SIZE_DEFAULT;
        } else {
          isLoadMore = false;
        }
        if (page == BASE_URL.PAGE_DEFAULT) {
          isLoadMore = true;
          streamList.add(result.reversed.toList());
        } else {
          streamList.add([
            ...streamList.value,
            ...result.reversed.toList(),
          ]);
        }
      }
    }
  }
}
