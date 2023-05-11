import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/support_customer/support_customer_bloc.dart';
import 'package:gen_crm/screens/menu/home/support/support_card_widget.dart';
import 'package:gen_crm/widgets/widget_text.dart';

import '../../../../../../src/src_index.dart';

class SupportCustomer extends StatefulWidget {
  SupportCustomer({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  State<SupportCustomer> createState() => _SupportCustomerState();
}

class _SupportCustomerState extends State<SupportCustomer>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: AppValue.heights * 0.02,
          ),
          BlocBuilder<SupportCustomerBloc, SupportCustomerState>(
              builder: (context, state) {
            if (state is UpdateGetSupportCustomerState) if (state
                    .listSupport.length >
                0)
              return Column(
                children: List.generate(
                    state.listSupport.length,
                    (index) => GestureDetector(
                        onTap: () {
                          AppNavigator.navigateDetailSupport(
                              state.listSupport[index].id.toString(),
                              state.listSupport[index].name ?? '');
                        },
                        child:
                            SupportCardWidget(data: state.listSupport[index]))),
              );
            else {
              return Center(
                child: WidgetText(
                  title: "Không có dữ liệu",
                  style: AppStyle.DEFAULT_16_BOLD,
                ),
              );
            }
            else
              return Container();
          }),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
