import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/detail_customer/detail_customer_bloc.dart';
import 'package:gen_crm/screens/menu/home/customer/widget/list_note.dart';
import '../../../../../../bloc/list_note/list_note_bloc.dart';
import '../../../../../../src/app_const.dart';
import '../../../../../../src/src_index.dart';
import '../../../../widget/error_item.dart';
import '../../../../widget/information.dart';

class TabInfoCustomer extends StatefulWidget {
  TabInfoCustomer({
    Key? key,
    required this.id,
    required this.blocNote,
    required this.bloc,
  }) : super(key: key);

  final String id;
  final ListNoteBloc blocNote;
  final DetailCustomerBloc bloc;

  @override
  State<TabInfoCustomer> createState() => _TabInfoCustomerState();
}

class _TabInfoCustomerState extends State<TabInfoCustomer>
    with AutomaticKeepAliveClientMixin {
  late final ListNoteBloc _blocNote;
  late final DetailCustomerBloc _bloc;
  @override
  void initState() {
    _blocNote = widget.blocNote;
    _bloc = widget.bloc;
    init();
    super.initState();
  }

  init() async {
    _bloc.add(InitGetDetailCustomerEvent(int.parse(widget.id)));
    _blocNote.add(RefreshEvent());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      color: getBackgroundWithIsCar(),
      onRefresh: () async {
        await init();
      },
      child: SingleChildScrollView(
        physics: ClampingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppValue.vSpaceTiny,
            BlocBuilder<DetailCustomerBloc, DetailCustomerState>(
                bloc: _bloc,
                builder: (context, state) {
                  if (state is UpdateGetDetailCustomerState) {
                    return InfoBase(
                      listData: state.customerInfo,
                    );
                  } else if (state is ErrorGetDetailCustomerState) {
                    return ErrorItem(
                      error: state.msg,
                      onPressed: () async {
                        await init();
                      },
                    );
                  } else
                    return loadInfo();
                }),
            ListNote(
              module: Module.KHACH_HANG,
              id: widget.id,
              bloc: _blocNote,
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
