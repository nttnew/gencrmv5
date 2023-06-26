import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:gen_crm/bloc/unread_list_notification/unread_list_notifi_bloc.dart';
import '../../../../../src/app_const.dart';
import '../../../../../src/models/model_generator/list_notification.dart';
import '../../../../../src/src_index.dart';
import '../../../../../widgets/slide_menu.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UnReadList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _UnReadListState();
}

class _UnReadListState extends State<UnReadList>
    with AutomaticKeepAliveClientMixin {
  int page = 1;
  int total = 0;
  int length = 0;
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    GetNotificationBloc.of(context).add(InitGetListUnReadNotificationEvent(1));
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

  Widget build(BuildContext context) {
    super.build(context);
    return BlocListener<GetNotificationBloc, NotificationState>(
      listener: (context, state) {
        if (state is DeleteNotificationState) {
          GetNotificationBloc.of(context)
              .add(InitGetListUnReadNotificationEvent(1));
        } else if (state is ErrorDeleteNotificationState) {
        } else if (state is ReadNotificationState) {
          GetNotificationBloc.of(context)
              .add(InitGetListUnReadNotificationEvent(1));
        } else if (state is ErrorNotificationState) {}
      },
      child: BlocBuilder<GetNotificationBloc, NotificationState>(
          builder: (context, state) {
        if (state is UpdateNotificationState) {
          total = int.parse(state.total);
          length = state.list.length;
          return ListView(
              controller: _scrollController,
              children: ListTile.divideTiles(
                  context: context,
                  tiles: state.list.map((element) {
                    return Builder(
                      builder: (ctx) => _buildSlideMenuItem(ctx, element),
                    );
                  })).toList());
        } else {
          return noData();
        }
      }),
    );
  }

  Widget _buildSlideMenuItem(BuildContext context, DataNotification item) {
    return new SlideMenu(
      child: new ListTile(
        onTap: () {
          if (item.module == 'customer') {
            AppNavigator.navigateDetailCustomer(
              item.record_id!,
              AppLocalizations.of(Get.context!)?.detail ?? '',
            );
          } else if (item.module == 'opportunity') {
            AppNavigator.navigateInfoChance(
              item.record_id!,
              AppLocalizations.of(Get.context!)?.detail ?? '',
            );
          } else if (item.module == 'job') {
            AppNavigator.navigateDetailWork(
              int.parse(item.record_id!),
              AppLocalizations.of(Get.context!)?.detail ?? '',
            );
          } else if (item.module == 'contract') {
            AppNavigator.navigateInfoContract(
              item.record_id!,
              AppLocalizations.of(Get.context!)?.detail ?? '',
            );
          } else if (item.module == 'support') {
            AppNavigator.navigateDetailSupport(
              item.record_id!,
              AppLocalizations.of(Get.context!)?.detail ?? '',
            );
          } else {
            AppNavigator.navigateInfoClue(
              item.record_id!,
              AppLocalizations.of(Get.context!)?.detail ?? '',
            );
          }
          GetNotificationBloc.of(context)
              .add(ReadNotificationEvent(item.id!, item.type!));
        },
        title: new Text(item.title!),
        subtitle: Container(
          decoration: BoxDecoration(),
          padding: EdgeInsets.all(0),
          child: Html(data: item.content!),
        ),
      ),
      menuItems: <Widget>[
        new Container(
          color: Colors.red,
          child: new IconButton(
            icon: new Icon(Icons.delete),
            color: Colors.white,
            onPressed: () => GetNotificationBloc.of(context).add(
                DeleteUnReadListNotificationEvent(
                    int.parse(item.id!), item.type!)),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
