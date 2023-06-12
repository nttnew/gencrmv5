import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../bloc/support_contract_bloc/support_contract_bloc.dart';
import '../../../../../src/app_const.dart';
import '../../../../../src/models/model_generator/support.dart';
import '../../support/widget/item_support.dart';

class ContractSupport extends StatefulWidget {
  ContractSupport({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  State<ContractSupport> createState() => _ContractSupportState();
}

class _ContractSupportState extends State<ContractSupport>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
        padding: EdgeInsets.only(bottom: 10),
        margin: EdgeInsets.only(top: 16),
        child: BlocBuilder<SupportContractBloc, SupportContractState>(
            builder: (context, state) {
          if (state is SuccessSupportContractState) if (state
                  .listSupportContract.length >
              0)
            return ListView.separated(
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  return ItemSupport(
                    data: SupportItemData(
                      state.listSupportContract[index].id,
                      state.listSupportContract[index].name,
                      state.listSupportContract[index].created_date,
                      state.listSupportContract[index].status,
                      state.listSupportContract[index].color,
                      state.listSupportContract[index].total_note,
                      CustomerData(
                        state.listSupportContract[index].khach_hang,
                        state.listSupportContract[index].khach_hang,
                      ),
                      null,
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(),
                itemCount: state.listSupportContract.length);
          else
            return noData();
          else
            return Container();
        }));
  }

  @override
  bool get wantKeepAlive => true;
}
