import 'package:flutter/material.dart';
import 'package:gen_crm/l10n/key_text.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/widgets/showToastM.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shimmer/shimmer.dart';

class ViewLoadMoreBase extends StatefulWidget {
  const ViewLoadMoreBase({
    Key? key,
    required this.functionInit,
    required this.itemWidget,
    required this.controller,
    this.isInit = false,
    this.noDataWidget,
    this.child,
    this.isShowAll,
    this.isDispose = true,
    this.heightAppBar = 75,
  }) : super(key: key);
  final Future<dynamic> Function(int page, bool isInit) functionInit;
  final Function(int index, dynamic data) itemWidget;
  final LoadMoreController controller;
  final bool isInit;
  final bool isDispose;
  final Widget? noDataWidget;
  final Widget? child;
  final BehaviorSubject<List<dynamic>>? isShowAll;
  final double heightAppBar;

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
          await _controller.onRefresh();
        },
        child: CustomScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          controller: _controller.controller,
          slivers: <Widget>[
            widget.isShowAll != null
                ? StreamBuilder<List<dynamic>>(
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
                    })
                : SliverAppBar(
                    backgroundColor: Colors.transparent,
                    automaticallyImplyLeading: false,
                    snap: true,
                    floating: true,
                    expandedHeight: widget.heightAppBar,
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
                          return Column(
                            children: [
                              _childL(
                                list,
                                isController: false,
                                physics: NeverScrollableScrollPhysics(),
                                isWarp: true,
                              ),
                              _load(),
                            ],
                          );
                        } else if (list == null) {
                          return _childLNull();
                        } else {
                          return SingleChildScrollView(
                            child: Center(
                              child: widget.noDataWidget ?? notFound(),
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
    } else {
      return StreamBuilder<List<dynamic>?>(
          stream: _controller.streamList,
          builder: (context, snapshot) {
            final list = snapshot.data;
            if (list?.isNotEmpty ?? false) {
              return Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await _controller.onRefresh();
                      },
                      child: _childL(
                        list,
                      ),
                    ),
                  ),
                  _load(),
                ],
              );
            } else if (list == null) {
              return _childLNull();
            } else {
              return SingleChildScrollView(
                  child: Center(
                child: widget.noDataWidget ?? notFound(),
              ));
            }
          });
    }
  }

  _load() => StreamBuilder<bool>(
      stream: _controller.showLoad,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data == true) {
          _controller.controller.animateTo(
            _controller.controller.position.maxScrollExtent + 32,
            duration: Duration(milliseconds: 1000),
            curve: Curves.easeOut,
          );
          return Container(
            height: 20,
            width: 20,
            margin: EdgeInsets.only(
              bottom: 16,
            ),
            child: CircularProgressIndicator(
              color: COLORS.BLUE,
              strokeWidth: 3,
            ),
          );
        }
        return SizedBox.shrink();
      });

  @override
  bool get wantKeepAlive => true;

  _childL(
    list, {
    bool isController = true,
    ScrollPhysics? physics,
    bool isWarp = false,
  }) =>
      ListView.builder(
        shrinkWrap: isWarp,
        physics: physics ?? AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(
          top: 16,
        ),
        controller: isController ? _controller.controller : null,
        itemCount: list?.length,
        itemBuilder: (context, index) => widget.itemWidget(index, list?[index]),
      );

  _childLNull() => ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.only(
          top: 16,
        ),
        itemCount: 10,
        itemBuilder: (context, index) => Container(
          margin: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 16,
          ),
          padding: EdgeInsets.all(
            16,
          ),
          decoration: BoxDecoration(
            color: COLORS.WHITE,
            borderRadius: BorderRadius.all(
              Radius.circular(
                10,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(
                  0.3,
                ),
                spreadRadius: 3,
                blurRadius: 5,
                offset: Offset(0, 0), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _itemLoading(isMaxWidth: true),
              AppValue.vSpaceSmall,
              _itemLoading(),
              AppValue.vSpaceSmall,
              _itemLoading(),
              AppValue.vSpaceSmall,
              _itemLoading(),
            ],
          ),
        ),
      );

  _itemLoading({bool isMaxWidth = false}) => Shimmer.fromColors(
        baseColor: Colors.black12,
        highlightColor: Colors.white,
        child: Container(
          height: 20,
          width: isMaxWidth
              ? MediaQuery.of(context).size.width
              : MediaQuery.of(context).size.width / 1 / 2,
          decoration: BoxDecoration(
            color: Colors.cyan,
            borderRadius: BorderRadius.all(
              Radius.circular(
                4,
              ),
            ),
          ),
        ),
      );
}

class LoadMoreController<T> {
  final BehaviorSubject<List<dynamic>?> streamList = BehaviorSubject();
  BehaviorSubject<bool> showLoad = BehaviorSubject.seeded(false);
  final ScrollController controller = ScrollController();
  bool isLoadMore = false;
  bool isRefresh = true;
  int page = BASE_URL.PAGE_DEFAULT;
  Future<dynamic> Function(int page, bool isInit)? functionInit;

  reloadData() {
    streamList.add(null);
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
    showLoad.add(false);
  }

  Future<void> loadData(int page, {bool isInit = true}) async {
    if (functionInit != null) {
      if (page != BASE_URL.PAGE_DEFAULT) {
        showLoad.add(true);
      }
      final result = await functionInit!(page, isInit);
      if (result != null) {
        isLoadMore = result.length == BASE_URL.SIZE_DEFAULT;
      } else {
        isLoadMore = false;
      }
      showLoad.add(false);
      if (result.runtimeType == String) {
        showToastM(Get.context!, title: result.toString());
        isLoadMore = true;
      } else {
        if (page == BASE_URL.PAGE_DEFAULT) {
          streamList.add(result);
        } else {
          streamList.add([...streamList.value ?? [], ...result]);
        }
      }
    }
  }

  Future<void> onRefresh() async {
    if (isRefresh) {
      page = BASE_URL.PAGE_DEFAULT;
      isLoadMore = false;
      streamList.add(null);
      await loadData(page);
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
