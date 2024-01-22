import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../bloc/detail_clue/detail_clue_bloc.dart';
import '../../../../../bloc/list_note/list_note_bloc.dart';
import '../../../../../src/models/model_generator/clue_detail.dart';
import '../../../../../src/src_index.dart';
import '../../../../../widgets/widget_line.dart';
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
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
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        children: List.generate(state.list!.length,
                            (index) => _buildContent(state.list![index])),
                      ),
                    );
                  }
                } else {
                  return SizedBox();
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
    );
  }

  _buildContent(DetailClueGroupName detailClue) {
    if (detailClue.group_name == null &&
        detailClue.mup == null &&
        detailClue.data == null) {
      return Container();
    } else {
      return Container(
        padding: EdgeInsets.only(bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 16,
            ),
            Text(
              detailClue.group_name ?? '',
              style: AppStyle.DEFAULT_16_BOLD,
            ),
            SizedBox(
              height: 16,
            ),
            Column(
              children: List.generate(detailClue.data?.length ?? 0, (index) {
                bool isKH = detailClue.data?[index].id == 'khach_hang_id_dm' &&
                    (detailClue.data?[index].is_link ?? false);
                if (detailClue.data?[index].value_field != '')
                  return Container(
                    margin: EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          detailClue.data?[index].label_field ?? '',
                          style: AppStyle.DEFAULT_14.copyWith(
                              fontWeight: FontWeight.w600,
                              color: COLORS.TEXT_GREY),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (isKH) {
                                AppNavigator.navigateDetailCustomer(
                                    detailClue.data?[index].link ?? '',
                                    detailClue.data?[index].value_field ?? '');
                              }
                            },
                            child: Text(
                              detailClue.data?[index].value_field ?? '',
                              textAlign: TextAlign.right,
                              style: AppStyle.DEFAULT_14_BOLD.copyWith(
                                color:
                                    isKH ? Colors.blue : COLORS.TEXT_GREY_BOLD,
                                decoration:
                                    isKH ? TextDecoration.underline : null,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                return SizedBox();
              }),
            ),
            const SizedBox(
              height: 8,
            ),
            WidgetLine(
              color: Colors.grey,
            )
          ],
        ),
      );
    }
  }

  @override
  bool get wantKeepAlive => true;
}
