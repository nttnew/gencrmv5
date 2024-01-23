import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../../bloc/detail_product_customer/detail_product_customer_bloc.dart';
import '../../../../../src/src_index.dart';
import '../../../../../widgets/line_horizontal_widget.dart';
import '../../../../../widgets/widget_text.dart';

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
      if (state is GetDetailProductCustomerState)
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                (state.productInfo.data ?? []).length,
                (index) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 24,
                    ),
                    WidgetText(
                      title:
                          (state.productInfo.data ?? [])[index].groupName ?? '',
                      style: TextStyle(
                          fontFamily: "Quicksand",
                          color: HexColor("#263238"),
                          fontWeight: FontWeight.w700,
                          fontSize: 14),
                    ),
                    SizedBox(
                      height: AppValue.heights * 0.02,
                    ),
                    Column(
                      children: List.generate(
                          (state.productInfo.data?[index].data ?? []).length,
                          (index1) {
                        bool isKH =
                            state.productInfo.data?[index].data?[index1].id ==
                                'khach_hang_sp';
                        if (state.productInfo.data?[index].data?[index1]
                                    .valueField !=
                                null &&
                            state.productInfo.data?[index].data?[index1]
                                    .valueField !=
                                '')
                          return Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  WidgetText(
                                    title: state.productInfo.data?[index]
                                        .data?[index1].labelField,
                                    style: LabelStyle(),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        if (isKH) {
                                          AppNavigator.navigateDetailCustomer(
                                              state.productInfo.data?[index]
                                                      .data?[index1].link ??
                                                  '',
                                              state
                                                      .productInfo
                                                      .data?[index]
                                                      .data?[index1]
                                                      .valueField ??
                                                  '');
                                        }
                                      },
                                      child: WidgetText(
                                        title: state.productInfo.data?[index]
                                            .data?[index1].valueField,
                                        textAlign: TextAlign.right,
                                        style: ValueStyle().copyWith(
                                          decoration: isKH
                                              ? TextDecoration.underline
                                              : null,
                                          color: isKH ? Colors.blue : null,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: AppValue.heights * 0.02,
                              ),
                            ],
                          );
                        return SizedBox();
                      }),
                    ),
                    LineHorizontal(),
                  ],
                ),
              ),
            ),
          ),
        );
      return SizedBox();
    });
  }

  TextStyle ValueStyle([String? color]) => TextStyle(
      fontFamily: "Quicksand",
      color: color == null ? HexColor("#263238") : HexColor(color),
      fontWeight: FontWeight.w700,
      fontSize: 14);

  TextStyle LabelStyle() => TextStyle(
      fontFamily: "Quicksand",
      color: COLORS.GREY,
      fontWeight: FontWeight.w600,
      fontSize: 14);

  @override
  bool get wantKeepAlive => true;
}
