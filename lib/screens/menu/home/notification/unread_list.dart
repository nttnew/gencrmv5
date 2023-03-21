import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:gen_crm/bloc/unread_list_notification/unread_list_notifi_bloc.dart';

import '../../../../src/models/model_generator/list_notification.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/slide_menu.dart';
import '../../../../widgets/description_text_widget.dart';
import '../../../../widgets/widget_text.dart';

class UnReadList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _UnReadListState();
}

class _UnReadListState extends State<UnReadList> {
  int page = 1;
  int total = 0;
  int lenght = 0;
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    GetListUnReadNotifiBloc.of(context).add(InitGetListUnReadNotifiEvent(1));
    _scrollController.addListener(() {
      if (_scrollController.offset == _scrollController.position.maxScrollExtent && lenght < total) {
        GetListUnReadNotifiBloc.of(context).add(InitGetListUnReadNotifiEvent(page + 1));
        page = page + 1;
      } else {}
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return BlocListener<GetListUnReadNotifiBloc, UnReadListNotifiState>(
      listener: (context, state) {
        if (state is DeleteUnReadListNotifiState) {
          // Scaffold.of(context).showSnackBar(SnackBar(content: Text("Xoá thành công "),duration: Duration(seconds: 2),));
          GetListUnReadNotifiBloc.of(context).add(InitGetListUnReadNotifiEvent(1));
        } else if (state is ErrorDeleteUnReadListNotifiState) {
          // Scaffold.of(context).showSnackBar(SnackBar(content: Text("Xoá thất bại "),duration: Duration(seconds: 2),));
        } else if (state is ReadUnReadListNotifiState) {
          // Scaffold.of(context).showSnackBar(SnackBar(content: Text("Đã đọc"),duration: Duration(seconds: 2),));
          GetListUnReadNotifiBloc.of(context).add(InitGetListUnReadNotifiEvent(1));
        } else if (state is ErrorReadUnReadListNotifiState) {
          // Scaffold.of(context).showSnackBar(SnackBar(content: Text(MESSAGES.CONNECT_ERROR),duration: Duration(seconds: 2),));
        }
      },
      child: BlocBuilder<GetListUnReadNotifiBloc, UnReadListNotifiState>(builder: (context, state) {
        if (state is UpdateUnReadListNotifiState) {
          total = int.parse(state.total);
          lenght = state.list.length;
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
          return Center(
            child: WidgetText(
              title: 'Không có dữ liệu',
              style: AppStyle.DEFAULT_18_BOLD,
            ),
          );
        }
      }),
    );
  }

  Widget _buildSlideMenuItem(BuildContext context, DataNotification item) {
    return new SlideMenu(
      child: new ListTile(
        onTap: () {
          if (item.module == 'customer') {
            AppNavigator.navigateDetailCustomer(item.record_id!, 'Chi tiết');
          } else if (item.module == 'opportunity') {
            AppNavigator.navigateInfoChance(item.record_id!, 'Chi tiết');
          } else if (item.module == 'job') {
            AppNavigator.navigateDeatailWork(int.parse(item.record_id!), 'Chi tiết');
          } else if (item.module == 'contract') {
            AppNavigator.navigateInfoContract(item.record_id!, 'Chi tiết');
          } else if (item.module == 'support') {
            AppNavigator.navigateDeatailSupport(item.record_id!, 'Chi tiết');
          } else {
            AppNavigator.navigateInfoClue(
              item.record_id!,
              'Chi tiết',
            );
          }
          GetListUnReadNotifiBloc.of(context).add(ReadNotifiEvent(item.id!, item.type!));
        },
        title: new Text(item.title!),
        subtitle: Container(
          decoration: BoxDecoration(
              // border: Border.all(width: 1)
              ),
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
            onPressed: () => GetListUnReadNotifiBloc.of(context).add(DeleteUnReadListNotifiEvent(int.parse(item.id!), item.type!)),
          ),
        ),
      ],
    );
  }
}
