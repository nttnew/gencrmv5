import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/screens/menu/widget/error_item.dart';
import '../../../../../../bloc/readed_list_notification/readed_list_notifi_bloc.dart';
import '../../../../../../bloc/unread_list_notification/unread_list_notifi_bloc.dart'
    as UnreadBloc;
import '../../../../../../src/app_const.dart';
import '../../../../../../src/models/model_generator/list_notification.dart';
import '../../../../../../src/src_index.dart';
import '../widget/item_noti.dart';

class ReadList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _ReadListState();
}

class _ReadListState extends State<ReadList>
    with AutomaticKeepAliveClientMixin {
  int _page = BASE_URL.PAGE_DEFAULT;
  int _length = 0;
  ScrollController _scrollController = ScrollController();
  late final ReadNotificationBloc _bloc;
  late final UnreadBloc.UnreadNotificationBloc _blocUnread;

  @override
  void initState() {
    _bloc = ReadNotificationBloc.of(context);
    _blocUnread = UnreadBloc.UnreadNotificationBloc.of(context);
    _bloc.add(InitGetListReadedNotifiEvent(_page));
    _scrollController.addListener(() {
      if (_scrollController.offset ==
              _scrollController.position.maxScrollExtent &&
          _length < _bloc.total) {
        _page = _page + 1;
        _bloc.add(ShowSelectOrUnselectAll(isSelect: false));
        _blocUnread.resetSelect();
        _bloc.add(InitGetListReadedNotifiEvent(_page));
      }
    });
    super.initState();
  }

  reload() async {
    _blocUnread.resetSelect();
    _page = BASE_URL.PAGE_DEFAULT;
    _bloc.add(ShowSelectOrUnselectAll(isSelect: false));
    _bloc.add(InitGetListReadedNotifiEvent(_page));
  }

  Widget build(BuildContext context) {
    super.build(context);
    return BlocListener<ReadNotificationBloc, ReadNotificationState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state is DeleteReadNotificationState) {
          reload();
        }
      },
      child: BlocBuilder<ReadNotificationBloc, ReadNotificationState>(
          bloc: _bloc,
          builder: (context, state) {
            if (state is UpdateReadNotificationState) {
              final _list = state.list;
              _length = _list.length;
              if (_length > 0)
                return RefreshIndicator(
                  onRefresh: () async {
                    await reload();
                  },
                  child: StreamBuilder<bool>(
                      stream: _blocUnread.showSelectAll,
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
                                _blocUnread.showSelectAll.add(_value);
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
                              },
                            );
                          },
                        );
                      }),
                );
              return noData();
            } else if (state is ErrorGetReadNotificationState) {
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
