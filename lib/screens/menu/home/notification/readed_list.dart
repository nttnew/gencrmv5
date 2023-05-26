import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../../bloc/readed_list_notification/readed_list_notifi_bloc.dart';
import '../../../../src/app_const.dart';
import '../../../../widgets/slide_menu.dart';

class ReadList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _ReadListState();
}

class _ReadListState extends State<ReadList> {
  int page = 1;
  int total = 0;
  int lenght = 0;
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    GetListReadedNotifiBloc.of(context).add(InitGetListReadedNotifiEvent(1));
    _scrollController.addListener(() {
      if (_scrollController.offset ==
              _scrollController.position.maxScrollExtent &&
          lenght < total) {
        GetListReadedNotifiBloc.of(context)
            .add(InitGetListReadedNotifiEvent(page + 1));
        page = page + 1;
      } else {}
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return BlocListener<GetListReadedNotifiBloc, ReadedListNotifiState>(
      listener: (context, state) {
        if (state is DeleteReadedListNotifiState) {
          GetListReadedNotifiBloc.of(context)
              .add(InitGetListReadedNotifiEvent(1));
        } else if (state is ErrorDeleteReadedListNotifiState) {
        }
      },
      child: BlocBuilder<GetListReadedNotifiBloc, ReadedListNotifiState>(
          builder: (context, state) {
        if (state is UpdateReadedListNotifiState) {
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
          return noData();
        }
      }),
    );
  }

  Widget _buildSlideMenuItem(BuildContext context, item) {
    return new SlideMenu(
      child: new ListTile(
        title: new Text(item.title),
        subtitle: new Container(
          child: Html(data: item.content!),
        ),
      ),
      menuItems: <Widget>[
        new Container(
          color: Colors.red,
          child: new IconButton(
            icon: new Icon(Icons.delete),
            color: Colors.white,
            onPressed: () => GetListReadedNotifiBloc.of(context).add(
                DeleteReadedListNotifiEvent(int.parse(item.id), item.type)),
          ),
        ),
      ],
    );
  }
}
