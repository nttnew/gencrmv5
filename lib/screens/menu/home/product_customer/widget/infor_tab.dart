import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../bloc/detail_product_customer/detail_product_customer_bloc.dart';
import '../../../../../src/src_index.dart';
import '../../../widget/information.dart';

class InfoTabProductCustomer extends StatefulWidget {
  const InfoTabProductCustomer({
    Key? key,
  }) : super(key: key);

  @override
  State<InfoTabProductCustomer> createState() => _InfoTabProductCustomerState();
}

class _InfoTabProductCustomerState extends State<InfoTabProductCustomer>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<DetailProductCustomerBloc, DetailProductCustomerState>(
        builder: (context, state) {
      if (state is GetDetailProductCustomerState) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            top: 16,
          ),
          child: InfoBase(
            listData: state.productInfo.data ?? [],
          ),
        );
      } else if (state is ErrorGetDetailProductCustomerState) {
        return Text(
          state.msg,
          style: AppStyle.DEFAULT_16_T,
        );
      }
      return Padding(
        padding: EdgeInsets.only(
          top: 16,
        ),
        child: loadInfo(),
      );
    });
  }

  @override
  bool get wantKeepAlive => true;
}
