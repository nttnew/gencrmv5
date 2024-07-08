import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../../../bloc/readed_list_notification/readed_list_notifi_bloc.dart';
import '../../../../../src/app_const.dart';
import '../../../../../src/models/model_generator/list_notification.dart';
import '../../../../../src/src_index.dart';
import '../../../../../widgets/slide_menu.dart';
import '../../../../../widgets/widget_text.dart';

class ReadList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _ReadListState();
}

class _ReadListState extends State<ReadList>
    with AutomaticKeepAliveClientMixin {
  int page = BASE_URL.PAGE_DEFAULT;
  int total = 0;
  int length = 0;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    GetListReadedNotifiBloc.of(context).add(InitGetListReadedNotifiEvent(1));
    _scrollController.addListener(() {
      if (_scrollController.offset ==
              _scrollController.position.maxScrollExtent &&
          length < total) {
        GetListReadedNotifiBloc.of(context)
            .add(InitGetListReadedNotifiEvent(page + 1));
        page = page + 1;
      }
    });
    super.initState();
  }

  reload() async {
    GetListReadedNotifiBloc.of(context).add(InitGetListReadedNotifiEvent(1));
  }

  Widget build(BuildContext context) {
    super.build(context);
    return BlocListener<GetListReadedNotifiBloc, ReadNotificationState>(
      listener: (context, state) {
        if (state is DeleteReadNotificationState) {
          reload();
        } else if (state is ErrorDeleteReadNotificationState) {}
      },
      child: BlocBuilder<GetListReadedNotifiBloc, ReadNotificationState>(
          builder: (context, state) {
        if (state is UpdateReadNotificationState) {
          total = int.parse(state.total);
          length = state.list.length;
          if (length != 0)
            return RefreshIndicator(
              onRefresh: () async {
                await reload();
              },
              child: ListView(
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
          return SizedBox.shrink();
        }
      }),
    );
  }

  Widget _buildSlideMenuItem(BuildContext context, DataNotification item) {
    return SlideMenu(
      child: ListTile(
        onTap: () {
          ModuleMy.getNavigate(
            item.record_id ?? '',
            item.module ?? '',
          );
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
            onPressed: () => GetListReadedNotifiBloc.of(context).add(
                DeleteReadedListNotifiEvent(
                    int.parse(item.id ?? '0'), item.type ?? '')),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
