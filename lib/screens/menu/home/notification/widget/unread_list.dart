import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:gen_crm/bloc/unread_list_notification/unread_list_notifi_bloc.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import '../../../../../src/app_const.dart';
import '../../../../../src/models/model_generator/list_notification.dart';
import '../../../../../src/src_index.dart';
import '../../../../../widgets/slide_menu.dart';

class UnReadList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _UnReadListState();
}

class _UnReadListState extends State<UnReadList>
    with AutomaticKeepAliveClientMixin {
  int page = BASE_URL.PAGE_DEFAULT;
  int total = 0;
  int length = 0;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    GetNotificationBloc.of(context)
        .add(InitGetListUnReadNotificationEvent(BASE_URL.PAGE_DEFAULT));
    _scrollController.addListener(() {
      if (_scrollController.offset ==
              _scrollController.position.maxScrollExtent &&
          length < total) {
        page = page + 1;
        GetNotificationBloc.of(context)
            .add(InitGetListUnReadNotificationEvent(page));
      }
    });
    super.initState();
  }

  reload() async {
    GetNotificationBloc.of(context).add(CheckNotification());
    GetNotificationBloc.of(context)
        .add(InitGetListUnReadNotificationEvent(BASE_URL.PAGE_DEFAULT));
  }

  Widget build(BuildContext context) {
    super.build(context);
    return BlocListener<GetNotificationBloc, NotificationState>(
      listener: (context, state) {
        if (state is DeleteNotificationState) {
          reload();
        } else if (state is ErrorDeleteNotificationState) {
        } else if (state is ReadNotificationState) {
          reload();
        } else if (state is ErrorNotificationState) {}
      },
      child: BlocBuilder<GetNotificationBloc, NotificationState>(
          builder: (context, state) {
        if (state is UpdateNotificationState) {
          total = int.parse(state.total);
          length = state.list.length;
          if (length != 0)
            return RefreshIndicator(
              onRefresh: () async {
                await reload();
              },
              child: ListView(
                physics: ClampingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                controller: _scrollController,
                children: ListTile.divideTiles(
                    context: context,
                    tiles: state.list.map((element) {
                      return Builder(
                        builder: (ctx) => _buildSlideMenuItem(ctx, element),
                      );
                    })).toList(),
              ),
            );
          return noData();
        } else {
          return noData();
        }
      }),
    );
  }

  Widget _buildSlideMenuItem(BuildContext context, DataNotification item) {
    return SlideMenu(
      child: ListTile(
        onTap: () {
          ModuleMy.getNavigate(
              item.record_id ?? '', item.title ?? '', item.module ?? '');
          GetNotificationBloc.of(context)
              .add(ReadNotificationEvent(item.id ?? '', item.type ?? ''));
        },
        contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 4),
        title: WidgetText(
          title: item.title ?? '',
          style: AppStyle.DEFAULT_16.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Container(
          decoration: BoxDecoration(),
          padding: EdgeInsets.all(2),
          child: Html(data: item.content ?? ''),
        ),
      ),
      menuItems: <Widget>[
        Container(
          color: COLORS.RED,
          child: IconButton(
            icon: Icon(Icons.delete),
            color: COLORS.WHITE,
            onPressed: () => GetNotificationBloc.of(context).add(
                DeleteUnReadListNotificationEvent(
                    int.parse(item.id ?? '0'), item.type ?? '')),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
