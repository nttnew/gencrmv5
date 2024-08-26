import 'package:flutter/material.dart';
import 'package:gen_crm/l10n/key_text.dart';
import 'package:gen_crm/screens/widget/box_item.dart';
import 'package:gen_crm/src/app_const.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shimmer/shimmer.dart';

import '../line_horizontal_widget.dart';

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
    this.heightAppBar,
    this.widgetLoad,
    this.paddingList,
  }) : super(key: key);
  final Future<dynamic> Function(int page, bool isInit) functionInit;
  final Function(int index, dynamic data) itemWidget;
  final LoadMoreController controller;
  final bool isInit;
  final bool isDispose;
  final Widget? noDataWidget;
  final Widget? child;
  final BehaviorSubject<List<dynamic>>? isShowAll;
  final double? heightAppBar;
  final Widget? widgetLoad;
  final double? paddingList;

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
    final hAppBar = widget.heightAppBar;
    super.build(context);
    if (widget.child != null) {
      return RefreshIndicator(
        color: getBackgroundWithIsCar(),
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
                        expandedHeight: (snapshot.data ?? []).length > 0
                            ? hAppBar != null
                                ? hAppBar
                                : 135
                            : hAppBar != null
                                ? (hAppBar - 40)
                                : 75,
                        flexibleSpace: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: boxShadowVip,
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
                    expandedHeight: hAppBar ?? 75,
                    flexibleSpace: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: boxShadowVip,
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
                      color: getBackgroundWithIsCar(),
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
              color: getBackgroundWithIsCar(),
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
          top: widget.paddingList ?? 16,
        ),
        controller: isController ? _controller.controller : null,
        itemCount: list?.length,
        itemBuilder: (context, index) => widget.itemWidget(index, list?[index]),
      );

  _childLNull() => ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.only(
          top: widget.paddingList ?? 16,
        ),
        itemCount: 10,
        itemBuilder: (context, index) =>
            widget.widgetLoad ??
            BoxItem(
              onTap: () {},
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  itemLoading(isMaxWidth: true),
                  AppValue.vSpaceSmall,
                  itemLoading(),
                  AppValue.vSpaceSmall,
                  itemLoading(),
                  AppValue.vSpaceSmall,
                  itemLoading(),
                ],
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
  bool isSet = false;
  int page = BASE_URL.PAGE_DEFAULT;
  Future<dynamic> Function(int page, bool isInit)? functionInit;

  reloadData() {
    if (functionInit != null) {
      streamList.add(null);
      isRefresh = true;
      page = BASE_URL.PAGE_DEFAULT;
      loadData(page);
    }
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
    isSet = false;
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
        ShowDialogCustom.showDialogBase(
          title: getT(KeyT.notification),
          content: result.toString(),
          textButton1: getT(KeyT.try_again),
          onTap1: () {
            reloadData();
            Get.back();
          },
        );
        isLoadMore = true;
      } else {
        if (page == BASE_URL.PAGE_DEFAULT) {
          streamList.add(result);
        } else {
          if (isSet) {
            final resultSet = [];
            result.map((e) {
              if (!(streamList.value ?? [])
                  .map((e) => e[0])
                  .toList()
                  .contains(e[0])) resultSet.add(e as List<dynamic>);
            }).toList();
            streamList.add([...streamList.value ?? [], ...resultSet]);
          } else {
            streamList.add([...streamList.value ?? [], ...result]);
          }
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

// Define your COLORS here
const COLORS_LOAD = {
  'GRAY_IMAGE': Color(0xFFE0E0E0),
  'WHITE10': Color(0x1AFFFFFF),
  'BLACK': Colors.black,
};

itemLoading({
  bool isMaxWidth = false,
  double height = 20,
  double? width,
}) =>
    Shimmer.fromColors(
      baseColor: COLORS.GRAY_IMAGE,
      highlightColor: COLORS.GRAY_IMAGE.withOpacity(0.5),
      period: Duration(seconds: 1),
      child: Container(
        height: height,
        width: width ??
            (isMaxWidth
                ? MediaQuery.of(Get.context!).size.width
                : MediaQuery.of(Get.context!).size.width / 1 / 2),
        decoration: BoxDecoration(
          color: COLORS.BLACK,
          borderRadius: BorderRadius.all(
            Radius.circular(
              4,
            ),
          ),
        ),
      ),
    );

itemLoading2({bool isMaxWidth = false}) => Shimmer.fromColors(
      baseColor: COLORS.GRAY_IMAGE,
      highlightColor: COLORS.GRAY_IMAGE.withOpacity(0.5),
      period: Duration(seconds: 1),
      child: Container(
        height: 40,
        width: isMaxWidth
            ? MediaQuery.of(Get.context!).size.width
            : MediaQuery.of(Get.context!).size.width / 1 / 2,
        decoration: BoxDecoration(
          color: COLORS.BLACK,
          borderRadius: BorderRadius.all(
            Radius.circular(
              4,
            ),
          ),
        ),
      ),
    );

widgetLoading() {
  return Container(
    margin: EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 6,
    ),
    child: Container(
      padding: EdgeInsets.all(12),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: COLORS.WHITE,
        border: Border.all(
          color: COLORS.GREY_400,
          width: 0.5,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(
            6,
          ),
        ),
      ),
      child: itemLoading(isMaxWidth: true),
    ),
  );
}

widgetLoadingProduct() {
  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: 16,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppValue.vSpaceSmall,
        Row(
          children: [
            Expanded(
              child: itemLoading(),
            ),
            Expanded(flex: 2, child: SizedBox()),
          ],
        ),
        AppValue.vSpace4,
        Row(
          children: [
            Expanded(
              flex: 3,
              child: itemLoading(),
            ),
            Expanded(flex: 2, child: SizedBox()),
          ],
        ),
        AppValue.vSpace4,
        Row(
          children: [
            Expanded(
              flex: 2,
              child: itemLoading(),
            ),
            Expanded(flex: 3, child: SizedBox()),
          ],
        ),
        AppValue.vSpace10,
        LineHorizontal(
          color: COLORS.GREY_400,
        ),
      ],
    ),
  );
}

widgetLoadingPack() {
  return Container(
    margin: EdgeInsets.only(
      top: 8,
      left: 16,
      right: 16,
    ),
    padding: EdgeInsets.only(
      bottom: 16,
    ),
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          width: 1,
          color: COLORS.GREY_400,
        ),
      ),
    ),
    child: Row(
      children: [
        WidgetContainerImage(
          image: ICONS.IC_CART_PNG,
          width: 25,
          height: 25,
          fit: BoxFit.contain,
          borderRadius: BorderRadius.circular(0),
          colorImage: COLORS.BLUE,
        ),
        SizedBox(
          width: 16,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              itemLoading(),
              AppValue.vSpace4,
              itemLoading(),
              AppValue.vSpace4,
              itemLoading(),
              AppValue.vSpace4,
              itemLoading(),
            ],
          ),
        ),
        SizedBox(
          height: 40,
          width: 40,
          child: Center(
            child: Transform.scale(
              scale: 1.2,
              child: Checkbox(
                //1 là đang sử dụng
                value: false,
                onChanged: null,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
