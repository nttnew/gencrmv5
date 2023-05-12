import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gen_crm/bloc/contract/customer_contract_bloc.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/widgets/line_horizontal_widget.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../widgets/widget_search.dart';

class CustomerContractScreen extends StatefulWidget {
  CustomerContractScreen(
      {Key? key,
      required this.contextFather,
      required this.onClickItem,
      this.type = 1,
      this.id = ""})
      : super(key: key);

  BuildContext contextFather;
  Function onClickItem;
  int type;
  String id;

  @override
  State<CustomerContractScreen> createState() => _CustomerContractScreenState();
}

class _CustomerContractScreenState extends State<CustomerContractScreen> {
  ScrollController _scrollController = ScrollController();
  int page = 1;
  int length = 0;
  String search = "";

  @override
  void initState() {
    if (widget.type == 1) {
      CustomerContractBloc.of(context)
          .add(InitGetContractCustomerEvent(page.toString(), ""));
      _scrollController.addListener(() {
        if (_scrollController.offset ==
                _scrollController.position.maxScrollExtent &&
            length % 10 == 0) {
          CustomerContractBloc.of(context)
              .add(InitGetContractCustomerEvent((page + 1).toString(), search));
          // setState(() {
          //   isCheck=!isCheck;
          // });
          page = page + 1;
        } else {}
      });
    } else {
      CustomerContractBloc.of(context).add(InitGetContactCusEvent(widget.id));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerContractBloc, CustomerContractState>(
        builder: (context, state) {
      if (state is SuccessGetContractCustomerState) {
        length = state.listContractCustomer.length;
        return Container(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: Get.width,
                  child: WidgetText(
                    title: "Chọn khách hàng",
                    style: AppStyle.DEFAULT_20_BOLD,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        margin: EdgeInsets.only(top: 8, bottom: 4),
                        child: WidgetSearch(
                          hintTextStyle: TextStyle(
                              fontFamily: "Quicksand",
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: HexColor("#707070")),
                          hint: "Tìm khách hàng",
                          leadIcon: SvgPicture.asset(ICONS.IC_SEARCH_SVG),
                          onSubmit: (v) {
                            search = v;
                            CustomerContractBloc.of(context)
                                .add(InitGetContractCustomerEvent("1", v));
                          },
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Container(
                            width: Get.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                  state.listContractCustomer.length,
                                  (index) => GestureDetector(
                                        onTap: () {
                                          widget.onClickItem(
                                              state.listContractCustomer[index]
                                                  [0],
                                              state.listContractCustomer[index]
                                                  [1]);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(top: 8),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              WidgetText(
                                                title:
                                                    state.listContractCustomer[
                                                        index][1],
                                                style: AppStyle.DEFAULT_18
                                                    .copyWith(
                                                        color: COLORS
                                                            .TEXT_BLUE_BOLD),
                                              ),
                                              SizedBox(
                                                height: 8,
                                              ),
                                              LineHorizontal()
                                            ],
                                          ),
                                        ),
                                      )),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      } else
        return Container();
    });
  }
}
