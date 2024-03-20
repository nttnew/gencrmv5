import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../bloc/detail_chance/detail_chance_bloc.dart';
import '../../../../../bloc/list_note/list_note_bloc.dart';
import '../../../../../src/src_index.dart';
import '../../../widget/information.dart';
import '../../customer/widget/list_note.dart';

class ChanceInfo extends StatefulWidget {
  const ChanceInfo({
    Key? key,
    required this.id,
    required this.blocNote,
    required this.bloc,
  }) : super(key: key);
  final String id;
  final ListNoteBloc blocNote;
  final GetListDetailChanceBloc bloc;

  @override
  State<ChanceInfo> createState() => _ChanceInfoState();
}

class _ChanceInfoState extends State<ChanceInfo>
    with AutomaticKeepAliveClientMixin {
  late final GetListDetailChanceBloc _bloc;
  late final ListNoteBloc _blocNote;

  @override
  void initState() {
    _bloc = widget.bloc;
    _blocNote = widget.blocNote;
    super.initState();
  }

  _onRefresh() async {
    _bloc.add(InitGetListDetailEvent(int.parse(widget.id)));
    _blocNote.add(RefreshEvent());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () async {
        await _onRefresh();
      },
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<GetListDetailChanceBloc, DetailChanceState>(
                bloc: _bloc,
                builder: (context, state) {
                  if (state is UpdateGetListDetailChanceState) {
                    return Padding(
                      padding: EdgeInsets.only(
                        top: 16,
                      ),
                      child: InfoBase(
                        listData: state.data,
                        isLine: false,
                      ),
                    );
                  } else if (state is ErrorGetListDetailChanceState) {
                    return Text(
                      state.msg,
                      style: AppStyle.DEFAULT_16_T,
                    );
                  } else
                    return Padding(
                      padding: EdgeInsets.only(
                      top: 16,
                  ),
                  child: loadInfo(),);
                }),
            ListNote(
              module: Module.CO_HOI_BH,
              id: widget.id,
              bloc: _blocNote,
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
