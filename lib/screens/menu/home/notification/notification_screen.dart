import 'package:flutter/material.dart';
import 'package:gen_crm/bloc/readed_list_notification/readed_list_notifi_bloc.dart'
    as Read;
import 'package:gen_crm/screens/menu/home/notification/tab/readed_list.dart';
import 'package:gen_crm/screens/menu/home/notification/tab/unread_list.dart';
import 'package:get/get.dart';
import '../../../../bloc/unread_list_notification/unread_list_notifi_bloc.dart';
import '../../../../l10n/key_text.dart';
import '../../../../src/app_const.dart';
import '../../../../src/src_index.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final UnreadNotificationBloc _bloc;
  late final Read.ReadNotificationBloc _blocRead;

  @override
  void initState() {
    _bloc = UnreadNotificationBloc.of(context);
    _blocRead = Read.ReadNotificationBloc.of(context);
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      _resetSelect();
    });
    super.initState();
  }

  _resetSelect() {
    _bloc.resetSelect();
    _bloc.add(ShowSelectOrUnselectAll(isSelect: false));
    _blocRead.add(Read.ShowSelectOrUnselectAll(isSelect: false));
  }

  @override
  void dispose() {
    _resetSelect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getBackgroundWithIsCar(),
      body: Column(
        children: [
          StreamBuilder<bool>(
              stream: _bloc.showSelectAll,
              builder: (context, snapshot) {
                final bool _isShowSelect = snapshot.data ?? false;
                return Container(
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top,
                  ),
                  height: AppValue.heightsAppBar,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: isCarCrm()
                        ? COLORS.PRIMARY_COLOR1
                        : COLORS.SECONDS_COLOR,
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (_isShowSelect) {
                            _resetSelect();
                          } else {
                            Get.back();
                          }
                        },
                        child: AnimatedSwitcher(
                          duration: Duration(milliseconds: 300),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            return RotationTransition(
                              turns: child.key == ValueKey('back')
                                  ? Tween<double>(begin: 0.5, end: 0)
                                      .animate(animation)
                                  : Tween<double>(begin: 0, end: 0.5)
                                      .animate(animation),
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            );
                          },
                          child: !_isShowSelect
                              ? Icon(
                                  Icons.arrow_back,
                                  key: ValueKey('back'),
                                  size: 24,
                                  color: getColorWithIsCar(),
                                )
                              : Icon(
                                  Icons.clear_outlined,
                                  key: ValueKey('close'),
                                  size: 24,
                                  color: getColorWithIsCar(),
                                ),
                        ),
                      ),
                      AppValue.hSpaceSmall,
                      if (_isShowSelect)
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  _bloc.add(
                                    ShowSelectOrUnselectAll(
                                      isSelect: _bloc.isShowBtnAll,
                                    ),
                                  );
                                  _blocRead.add(
                                    Read.ShowSelectOrUnselectAll(
                                      isSelect: _bloc.isShowBtnAll,
                                    ),
                                  );
                                  _bloc.isShowBtnAll = !_bloc.isShowBtnAll;
                                  setState(() {});
                                },
                                child: Text(
                                  _bloc.isShowBtnAll
                                      ? (getT(KeyT.select) +
                                          ' ' +
                                          getT(KeyT.all).toLowerCase())
                                      : getT(KeyT.unselect),
                                  style: AppStyle.DEFAULT_14_BOLD.copyWith(
                                    color: getColorWithIsCar(),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  if (_tabController.index ==
                                      0) // tab chưa đọc thì hiện
                                    InkWell(
                                      onTap: () {
                                        _bloc.readAll();
                                      },
                                      child: Text(
                                        getT(KeyT.readed),
                                        style:
                                            AppStyle.DEFAULT_14_BOLD.copyWith(
                                          color: getColorWithIsCar(),
                                        ),
                                      ),
                                    ),
                                  AppValue.hSpaceSmall,
                                  InkWell(
                                    onTap: () {
                                      ShowDialogCustom.showDialogBase(
                                        onTap2: () {
                                          if (_tabController.index == 0) {
                                            _bloc.deleteAll();
                                          } else {
                                            _blocRead.deleteAll();
                                          }
                                          Get.back();
                                        },
                                        title: getT(KeyT.notification),
                                        content: getT(KeyT
                                            .are_you_sure_you_want_to_delete),
                                      );
                                    },
                                    child: Text(
                                      getT(KeyT.delete),
                                      style: AppStyle.DEFAULT_14_BOLD.copyWith(
                                        color: getColorWithIsCar(),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      else
                        Text(
                          getT(KeyT.notification),
                          style: AppStyle.DEFAULT_16_BOLD.copyWith(
                            color: getColorWithIsCar(),
                          ),
                        ),
                    ],
                  ),
                );
              }),
          Expanded(
            child: Scaffold(
              appBar: TabBar(
                controller: _tabController,
                padding: EdgeInsets.symmetric(horizontal: 16),
                isScrollable: false,
                labelColor: COLORS.ff006CB1,
                unselectedLabelColor: COLORS.ff697077,
                labelStyle: AppStyle.DEFAULT_LABEL_TARBAR,
                indicatorColor: COLORS.ff006CB1,
                tabs: <Widget>[
                  Tab(
                    text: getT(KeyT.unread),
                  ),
                  Tab(
                    text: getT(KeyT.readed),
                  ),
                ],
              ),
              body: Container(
                child: Column(
                  children: [
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          UnReadList(),
                          ReadList(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
