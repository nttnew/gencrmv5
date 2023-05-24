import 'package:flutter/material.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:rxdart/rxdart.dart';
import '../src/src_index.dart';

class ListViewLoadMoreBase extends StatefulWidget {
  const ListViewLoadMoreBase({
    Key? key,
    required this.functionInit,
    required this.itemWidget,
    required this.controller,
  }) : super(key: key);
  final Future<dynamic> Function(int page, bool isInit) functionInit;
  final Function(int index, dynamic data) itemWidget;
  final LoadMoreController controller;

  @override
  State<ListViewLoadMoreBase> createState() => _ListViewLoadMoreBaseState();
}

class _ListViewLoadMoreBaseState extends State<ListViewLoadMoreBase>
    with AutomaticKeepAliveClientMixin {
  late final LoadMoreController _controller;
  @override
  void initState() {
    _controller = widget.controller;
    _controller.functionInit = widget.functionInit;
    super.initState();
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _controller.initData(_controller.page, isInit: false);
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
            return RefreshIndicator(
              onRefresh: () async {
                _controller.page = BASE_URL.PAGE_DEFAULT;
                await _controller.initData(_controller.page);
              },
              child: ListView.builder(
                  padding: EdgeInsets.only(top: 8, bottom: 8),
                  controller: _controller.controller,
                  shrinkWrap: true,
                  itemCount: list.length,
                  itemBuilder: (context, index) =>
                      widget.itemWidget(index, list[index])),
            );
          } else {
            return Center(
              child: WidgetText(
                title: 'Không có dữ liệu',
                style: AppStyle.DEFAULT_16_BOLD,
              ),
            );
          }
        });
  }

  @override
  bool get wantKeepAlive => true;
}

class LoadMoreController<T> {
  final BehaviorSubject<List<dynamic>> streamList = BehaviorSubject();
  final ScrollController controller = ScrollController();
  bool isLoadMore = true;
  int page = BASE_URL.PAGE_DEFAULT;
  Future<dynamic> Function(int page, bool isInit)? functionInit;

  reloadData() {
    int page = BASE_URL.PAGE_DEFAULT;
    initData(page);
  }

  handelLoadMore() {
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset &&
          isLoadMore) {
        page = page + 1;
        initData(page);
      }
    });
  }

  dispose() {
    streamList.add([]);
    isLoadMore = true;
    page = BASE_URL.PAGE_DEFAULT;
    functionInit = null;
  }

  initData(int page, {bool isInit = true}) async {
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
          streamList.add(result);
        } else {
          streamList.add([...streamList.value, ...result]);
        }
      }
    }
  }
}
