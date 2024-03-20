import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../bloc/detail_clue/detail_clue_bloc.dart';
import '../../../../../bloc/list_note/list_note_bloc.dart';
import '../../../../../src/src_index.dart';
import '../../../widget/information.dart';
import '../../customer/widget/list_note.dart';

class GeneralInfo extends StatefulWidget {
  const GeneralInfo({
    Key? key,
    required this.id,
    required this.blocNote,
    required this.bloc,
  }) : super(key: key);
  final String id;
  final ListNoteBloc blocNote;
  final GetDetailClueBloc bloc;

  @override
  State<GeneralInfo> createState() => _GeneralInfoState();
}

class _GeneralInfoState extends State<GeneralInfo>
    with AutomaticKeepAliveClientMixin {
  late final ListNoteBloc _blocNote;
  late final GetDetailClueBloc _bloc;

  @override
  void initState() {
    _blocNote = widget.blocNote;
    _bloc = widget.bloc;
    super.initState();
  }

  init() async {
    _bloc.add(InitGetDetailClueEvent(widget.id));
    _blocNote.add(RefreshEvent());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () async {
        await init();
      },
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<GetDetailClueBloc, DetailClueState>(
                bloc: _bloc,
                builder: (context, state) {
                  if (state is GetDetailClueState) {
                    if (state.list == [] || state.list == null) {
                      return SizedBox();
                    } else {
                      return Padding(
                        padding: const EdgeInsets.only(
                          top: 16,
                        ),
                        child: InfoBase(
                          listData: state.list ?? [],
                        ),
                      );
                    }
                  } else if (state is ErrorGetDetailClueState) {
                    return Text(
                      state.msg,
                      style: AppStyle.DEFAULT_16_T,
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.only(
                        top: 16,
                      ),
                      child: loadInfo(),
                    );
                  }
                }),
            AppValue.vSpaceTiny,
            ListNote(
              module: Module.DAU_MOI,
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
