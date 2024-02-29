import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/contract/detail_contract_bloc.dart';
import 'package:gen_crm/l10n/key_text.dart';
import 'package:gen_crm/screens/menu/home/customer/widget/list_note.dart';
import 'package:gen_crm/widgets/line_horizontal_widget.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import '../../../../../bloc/list_note/list_note_bloc.dart';
import '../../../../../src/models/model_generator/detail_contract.dart';
import '../../../../../src/src_index.dart';

class ContractOperation extends StatefulWidget {
  ContractOperation({
    Key? key,
    required this.id,
    required this.bloc,
    required this.blocNote,
  }) : super(key: key);
  final ListNoteBloc blocNote;
  final DetailContractBloc bloc;
  final String id;

  @override
  State<ContractOperation> createState() => _ContractOperationState();
}

class _ContractOperationState extends State<ContractOperation>
    with AutomaticKeepAliveClientMixin {
  late final ListNoteBloc _blocNote;
  late final DetailContractBloc _bloc;

  @override
  void initState() {
    _blocNote = widget.blocNote;
    _bloc = widget.bloc;
    _initData();
    super.initState();
  }

  _initData() {
    _bloc.add(InitGetDetailContractEvent(int.parse(widget.id)));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () async {
        _blocNote.add(RefreshEvent());
        await _initData();
      },
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: BlocBuilder<DetailContractBloc, DetailContractState>(
            bloc: _bloc,
            builder: (context, state) {
              if (state is SuccessDetailContractState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 16,
                        left: 16,
                        right: 16,
                      ),
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                                state.listDetailContract.length, (index) {
                              if (state.listDetailContract[index].data !=
                                  null) {
                                return _buildContent1(
                                    state.listDetailContract[index]);
                              } else
                                return SizedBox.shrink();
                            }),
                          ),
                        ],
                      ),
                    ),
                    ListNote(
                      module: Module.HOP_DONG,
                      id: widget.id,
                      bloc: _blocNote,
                    )
                  ],
                );
              } else if (state is ErrorDetailContractState) {
                return Text(
                  state.msg,
                  style: AppStyle.DEFAULT_16_T,
                );
              } else
                return SizedBox.shrink();
            }),
      ),
    );
  }

  _buildContent1(DetailContractData data) {
    return Container(
      padding: EdgeInsets.only(
        bottom: 15,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WidgetText(
            title: data.group_name,
            style: AppStyle.DEFAULT_16_BOLD,
          ),
          ((data.data
                          ?.where((e) =>
                              e.value_field != '' && e.value_field != null)
                          .toList()
                          .length ??
                      0) >
                  0)
              ? Column(
                  children: List.generate(
                    data.data?.length ?? 0,
                    (index) {
                      bool isKH = data.data?[index].id == 'col131' &&
                          (data.data?[index].is_link ?? false);
                      bool isSPKH = data.data?[index].id == 'hdsan_pham_kh' &&
                          (data.data?[index].link != '' &&
                              data.data?[index].link != null);
                      bool isNameSP = data.data?[index].name_field == 'name';
                      if (data.data![index].field_type == "LINE") {
                        return Container(
                            margin: EdgeInsets.symmetric(vertical: 3),
                            child: LineHorizontal());
                      } else
                        return data.data![index].value_field != ''
                            ? Container(
                                padding: EdgeInsets.only(top: 3, bottom: 3),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: WidgetText(
                                        title:
                                            data.data![index].label_field ?? "",
                                        style: AppStyle.DEFAULT_14
                                            .copyWith(color: Colors.grey),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: GestureDetector(
                                        onTap: () {
                                          if (isKH) {
                                            AppNavigator.navigateDetailCustomer(
                                                data.data?[index].link ?? '',
                                                data.data?[index].value_field ??
                                                    '');
                                          } else if (isSPKH) {
                                            AppNavigator
                                                .navigateDetailProductCustomer(
                                              data.data?[index].label_field ??
                                                  '',
                                              data.data?[index].link ?? '',
                                            );
                                          }
                                        },
                                        child: WidgetText(
                                          title:
                                              data.data![index].value_field ??
                                                  '',
                                          textAlign: TextAlign.right,
                                          style: AppStyle.DEFAULT_14.copyWith(
                                            decoration: isKH || isSPKH
                                                ? TextDecoration.underline
                                                : null,
                                            color: isKH || isSPKH
                                                ? Colors.blue
                                                : isNameSP
                                                    ? COLORS.ORANGE_IMAGE
                                                    : null,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox();
                    },
                  ),
                )
              : Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: WidgetText(
                    title: getT(KeyT.no_data),
                    style: AppStyle.DEFAULT_14.copyWith(
                      color: COLORS.GREY,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
