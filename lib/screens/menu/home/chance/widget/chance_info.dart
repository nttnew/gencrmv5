import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../bloc/detail_chance/detail_chance_bloc.dart';
import '../../../../../bloc/list_note/list_note_bloc.dart';
import '../../../../../src/src_index.dart';
import '../../../../../widgets/widget_line.dart';
import '../../../../../widgets/widget_text.dart';
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
                      padding: EdgeInsets.all(25),
                      child: ListView.separated(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            if (state.data[index].data != null)
                              return Container(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppValue.vSpaceTiny,
                                    WidgetText(
                                      title: state.data[index].group_name ?? "",
                                      style: AppStyle.DEFAULT_16_BOLD,
                                    ),
                                    AppValue.vSpaceTiny,
                                    Column(
                                      children: List.generate(
                                        state.data[index].data!.length,
                                        (index1) =>
                                            state.data[index].data![index1]
                                                        .value_field !=
                                                    ''
                                                ? Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 5),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Expanded(
                                                            flex: 1,
                                                            child: WidgetText(
                                                              title: state
                                                                      .data[
                                                                          index]
                                                                      .data![
                                                                          index1]
                                                                      .label_field ??
                                                                  '',
                                                              style: AppStyle
                                                                  .DEFAULT_14
                                                                  .copyWith(
                                                                      color: Colors
                                                                          .grey),
                                                            )),
                                                        Expanded(
                                                            flex: 2,
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                if (state
                                                                            .data[
                                                                                index]
                                                                            .data?[
                                                                                index1]
                                                                            .label_field ==
                                                                        BASE_URL
                                                                            .KHACH_HANG &&
                                                                    (state
                                                                            .data[index]
                                                                            .data?[index1]
                                                                            .is_link ??
                                                                        false)) {
                                                                  AppNavigator.navigateDetailCustomer(
                                                                      state.data[index].data?[index1].link ??
                                                                          '',
                                                                      state.data[index].data?[index1]
                                                                              .value_field ??
                                                                          '');
                                                                }
                                                              },
                                                              child: WidgetText(
                                                                  title: state
                                                                          .data[
                                                                              index]
                                                                          .data![
                                                                              index1]
                                                                          .value_field ??
                                                                      '',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .right,
                                                                  style: AppStyle
                                                                      .DEFAULT_14
                                                                      .copyWith(
                                                                    decoration: (state.data[index].data?[index1].label_field == BASE_URL.KHACH_HANG &&
                                                                            (state.data[index].data?[index1].is_link ??
                                                                                false))
                                                                        ? TextDecoration
                                                                            .underline
                                                                        : null,
                                                                    color: (state.data[index].data?[index1].label_field == BASE_URL.KHACH_HANG &&
                                                                            (state.data[index].data?[index1].is_link ??
                                                                                false))
                                                                        ? Colors
                                                                            .blue
                                                                        : null,
                                                                  )),
                                                            ))
                                                      ],
                                                    ),
                                                  )
                                                : SizedBox(),
                                      ),
                                    ),
                                    AppValue.vSpaceTiny,
                                    AppValue.vSpaceTiny,
                                    AppValue.vSpaceTiny,
                                    WidgetLine(
                                      color: Colors.grey,
                                    )
                                  ],
                                ),
                              );
                            else
                              return Container();
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox();
                          },
                          itemCount: state.data.length),
                    );
                  } else
                    return Container();
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
