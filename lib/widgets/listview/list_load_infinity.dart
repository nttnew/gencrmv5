import 'package:flutter/material.dart';
import 'package:gen_crm/l10n/key_text.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:rxdart/rxdart.dart';

class ViewLoadMoreBase extends StatefulWidget {
  const ViewLoadMoreBase({
    Key? key,
    required this.functionInit,
    required this.itemWidget,
    required this.controller,
    this.isInit = false,
    this.isGrid = false,
    this.notFoundData,
    this.child,
    this.isCustom,
    this.isShowAll,
    this.isDispose = true,
  }) : super(key: key);
  final Future<dynamic> Function(int page, bool isInit) functionInit;
  final Function(int index, dynamic data) itemWidget;
  final LoadMoreController controller;
  final bool isInit;
  final bool isGrid;
  final bool? isCustom;
  final bool isDispose;
  final Widget? notFoundData;
  final Widget? child;
  final BehaviorSubject<List<dynamic>>? isShowAll;

  @override
  State<ViewLoadMoreBase> createState() => _ViewLoadMoreBaseState();
}

class _ViewLoadMoreBaseState extends State<ViewLoadMoreBase>
    with AutomaticKeepAliveClientMixin {
  late final LoadMoreController _controller;

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
  void dispose() {
    if (widget.isDispose) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.child != null) {
      return RefreshIndicator(
        onRefresh: () async {
          if (_controller.isRefresh) {
            _controller.page = BASE_URL.PAGE_DEFAULT;
            _controller.isLoadMore = false;
            await _controller.loadData(_controller.page);
          }
        },
        child: CustomScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          controller: _controller.controller,
          slivers: <Widget>[
            if (widget.isShowAll != null)
              // SliverApps
              StreamBuilder<List<dynamic>>(
                  stream: widget.isShowAll,
                  builder: (context, snapshot) {
                    return SliverAppBar(
                      backgroundColor: Colors.transparent,
                      automaticallyImplyLeading: false,
                      snap: true,
                      floating: true,
                      expandedHeight:
                          (snapshot.data ?? []).length > 0 ? 135 : 75,
                      flexibleSpace: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xff333333).withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                        child: widget.child,
                      ),
                    );
                  }),
            if (widget.isShowAll == null)
              SliverAppBar(
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                snap: true,
                floating: true,
                expandedHeight: 75,
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xff333333).withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: widget.child,
                ),
              ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return StreamBuilder<List<dynamic>?>(
                      stream: _controller.streamList,
                      builder: (context, snapshot) {
                        final list = snapshot.data;
                        if (list?.isNotEmpty ?? false) {
                          return _childL(
                            list,
                            isController: false,
                            physics: NeverScrollableScrollPhysics(),
                            isWarp: true,
                          );
                        } else if (list == null) {
                          return SizedBox.shrink();
                        } else {
                          return SingleChildScrollView(
                            child: Center(
                              child: widget.notFoundData ?? notFound(),
                            ),
                          );
                        }
                      });
                },
                childCount: 1,
              ),
            ),
          ],
        ),
      );
    } else if (widget.isCustom == true) {
      return StreamBuilder<List<dynamic>?>(
          stream: _controller.streamList,
          builder: (context, snapshot) {
            final list = snapshot.data;
            if (list?.isNotEmpty ?? false) {
              return _childL(
                list,
                isWarp: true,
                physics: NeverScrollableScrollPhysics(),
                isController: false,
              );
            } else if (list == null) {
              return SizedBox.shrink();
            } else {
              return SingleChildScrollView(
                  child: Center(
                child: widget.notFoundData ?? notFound(),
              ));
            }
          });
    } else {
      return StreamBuilder<List<dynamic>?>(
          stream: _controller.streamList,
          builder: (context, snapshot) {
            final list = snapshot.data;
            if (list?.isNotEmpty ?? false) {
              return RefreshIndicator(
                onRefresh: () async {
                  if (_controller.isRefresh) {
                    _controller.page = BASE_URL.PAGE_DEFAULT;
                    _controller.isLoadMore = false;
                    await _controller.loadData(_controller.page);
                  }
                },
                child: _childL(
                  list,
                ),
              );
            } else if (list == null) {
              return SizedBox.shrink();
            } else {
              return SingleChildScrollView(
                  child: Center(
                child: widget.notFoundData ?? notFound(),
              ));
            }
          });
    }
  }

  @override
  bool get wantKeepAlive => true;

  _childL(
    list, {
    bool isController = true,
    ScrollPhysics? physics,
    bool isWarp = false,
  }) =>
      widget.isGrid
          ? GridView.builder(
              shrinkWrap: isWarp,
              physics: physics ?? AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 16,
                top: 12,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 157 / 251,
              ),
              controller: isController ? _controller.controller : null,
              itemCount: list?.length,
              itemBuilder: (context, index) =>
                  widget.itemWidget(index, list?[index]),
            )
          : ListView.builder(
              shrinkWrap: isWarp,
              physics: physics ?? AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(
                top: 16,
              ),
              controller: isController ? _controller.controller : null,
              itemCount: list?.length,
              itemBuilder: (context, index) =>
                  widget.itemWidget(index, list?[index]),
            );
}

class LoadMoreController<T> {
  //tpdp
  final BehaviorSubject<List<dynamic>?> streamList = BehaviorSubject();
  final ScrollController controller = ScrollController();
  bool isLoadMore = false;
  bool isRefresh = true;
  int page = BASE_URL.PAGE_DEFAULT;
  Future<dynamic> Function(int page, bool isInit)? functionInit;

  reloadData() {
    isRefresh = true;
    page = BASE_URL.PAGE_DEFAULT;
    loadData(page);
  }

  initData(List<dynamic> list) {
    streamList.add(list);
  }

  _loadMore() {
    if (controller.position.maxScrollExtent == controller.offset &&
        isLoadMore) {
      page = page + 1;
      loadData(page);
    }
  }

  handelLoadMore() {
    controller.addListener(_loadMore);
  }

  dispose() {
    streamList.add(null);
    isLoadMore = true;
    page = BASE_URL.PAGE_DEFAULT;
    functionInit = null;
    controller.removeListener(_loadMore);
  }

  Future<void> loadData(int page, {bool isInit = true}) async {
    if (functionInit != null) {
      final result = await functionInit!(page, isInit);
      if (result != null) {
        isLoadMore = result.length == BASE_URL.SIZE_DEFAULT;
      } else {
        isLoadMore = false;
      }
      if (page == BASE_URL.PAGE_DEFAULT) {
        streamList.add(result);
      } else {
        streamList.add([...streamList.value ?? [], ...result]);
      }
    }
  }
}

notFound() => Container(
      padding: EdgeInsets.only(
        top: 200,
      ),
      child: Text(
        getT(KeyT.no_data),
        style: AppStyle.DEFAULT_18_BOLD,
      ),
    );
