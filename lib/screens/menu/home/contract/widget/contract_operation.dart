import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/contract/detail_contract_bloc.dart';
import 'package:gen_crm/screens/menu/home/customer/widget/list_note.dart';
import '../../../../../bloc/list_note/list_note_bloc.dart';
import '../../../../../src/app_const.dart';
import '../../../../../src/src_index.dart';
import '../../../widget/information.dart';

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
      color: getBackgroundWithIsCar(),
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
                      ),
                      child: InfoBase(
                        listData: state.listDetailContract,
                        isLine: false,
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
                return Padding(
                  padding: const EdgeInsets.only(
                    top: 16,
                  ),
                  child: loadInfo(),
                );
            }),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
