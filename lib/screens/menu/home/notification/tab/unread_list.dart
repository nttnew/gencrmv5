import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/unread_list_notification/unread_list_notifi_bloc.dart';
import '../../../../../../src/app_const.dart';
import '../../../../../../src/models/model_generator/list_notification.dart';
import '../../../../../../src/src_index.dart';
import '../../../widget/error_item.dart';
import '../widget/item_noti.dart';

class UnReadList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _UnReadListState();
}

class _UnReadListState extends State<UnReadList>
    with AutomaticKeepAliveClientMixin {
  int _page = BASE_URL.PAGE_DEFAULT;
  int _length = 0;
  ScrollController _scrollController = ScrollController();
  late final UnreadNotificationBloc _bloc;

  @override
  void initState() {
    _bloc = UnreadNotificationBloc.of(context);
    _bloc.add(InitGetListUnReadNotificationEvent(BASE_URL.PAGE_DEFAULT));
    _scrollController.addListener(() {
      if (_scrollController.offset ==
              _scrollController.position.maxScrollExtent &&
          _length < _bloc.total.value) {
        _page = _page + 1;
        _bloc.resetSelect();
        _bloc.add(InitGetListUnReadNotificationEvent(_page));
      }
    });
    super.initState();
  }

  reload() async {
    _bloc.showSelectAll.add(false);
    _bloc.resetSelect();
    _bloc.add(CheckNotification());
    _bloc.add(InitGetListUnReadNotificationEvent(BASE_URL.PAGE_DEFAULT));
  }

  Widget build(BuildContext context) {
    super.build(context);
    return BlocListener<UnreadNotificationBloc, UnReadNotificationState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state is DeleteNotificationState) {
          reload();
        } else if (state is ReadNotificationState) {
          reload();
        }
      },
      child: BlocBuilder<UnreadNotificationBloc, UnReadNotificationState>(
          bloc: _bloc,
          builder: (context, state) {
            if (state is UpdateNotificationState) {
              final _list = state.list;
              _length = _list.length;
              if (_length > 0)
                return RefreshIndicator(
                  onRefresh: () async {
                    await reload();
                  },
                  child: StreamBuilder<bool>(
                      stream: _bloc.showSelectAll,
                      builder: (context, snapshot) {
                        final bool _select = snapshot.data ?? false;
                        return ListView.builder(
                          physics: ClampingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          controller: _scrollController,
                          itemCount: _list.length,
                          itemBuilder: (BuildContext context, int i) {
                            return ItemNotification(
                              isSelect: _select,
                              item: _list[i],
                              onChange: (DataNotification _item, bool _value) {
                                _bloc.selectOrUnselectOne(
                                    value: _item, isSelect: _value);
                              },
                              onLongPress:
                                  (DataNotification _item, bool _value) {
                                _bloc.showSelectAll.add(_value);
                                _bloc.selectOrUnselectOne(
                                  value: _item,
                                  isSelect: _value,
                                );
                              },
                              onTap: (DataNotification _item) {
                                ModuleMy.getNavigate(
                                  _item.recordId ?? '',
                                  _item.module ?? '',
                                );
                                _bloc.add(
                                  ReadNotificationEvent(
                                    _item.id ?? '',
                                  ),
                                );
                              },
                            );
                          },
                        );
                      }),
                );
              return noData();
            } else if (state is ErrorNotificationState) {
              return ErrorItem(
                onPressed: () => reload(),
                error: state.msg,
              );
            }
            return SizedBox.shrink();
          }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
