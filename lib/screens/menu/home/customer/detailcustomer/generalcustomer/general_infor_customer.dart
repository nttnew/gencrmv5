import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/detail_customer/detail_customer_bloc.dart';
import 'package:gen_crm/screens/menu/home/customer/list_note.dart';
import 'package:gen_crm/src/models/model_generator/detail_customer.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../../src/src_index.dart';
import '../../../../../../widgets/line_horizontal_widget.dart';

class TabInfoCustomer extends StatefulWidget {
  TabInfoCustomer({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  State<TabInfoCustomer> createState() => _TabInfoCustomerState();
}

class _TabInfoCustomerState extends State<TabInfoCustomer>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppValue.vSpaceSmall,
          BlocBuilder<DetailCustomerBloc, DetailCustomerState>(
              builder: (context, state) {
            if (state is UpdateGetDetailCustomerState)
              return Column(
                children: List.generate(state.customerInfo.length,
                    (index) => _renderInfo(state.customerInfo[index])),
              );
            else
              return Container();
          }),
          ListNote(module: Module.KHACH_HANG, id: widget.id),
        ],
      ),
    );
  }

  Widget _renderInfo(CustomerInfoData data) {
    return (Container(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WidgetText(
              title: data.group_name ?? '',
              style: AppStyle.DEFAULT_14.copyWith(fontWeight: FontWeight.w700)),
          AppValue.vSpaceTiny,
          Column(
            children: List.generate(
              data.data?.length ?? 0,
              (index) =>
                  data.data?[index].value_field?.trim().isNotEmpty ?? false
                      ? Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              WidgetText(
                                title: data.data?[index].label_field ?? '',
                                style: AppStyle.DEFAULT_14.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: COLORS.TEXT_GREY,
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: GestureDetector(
                                    onTap: () {
                                      if (data.data![index].action == 2) {
                                        launchUrl(Uri(
                                            scheme: "tel",
                                            path: "${data.data![index].link}"));
                                      }
                                    },
                                    child: WidgetText(
                                      title: data.data![index].value_field,
                                      textAlign: TextAlign.right,
                                      style: AppStyle.DEFAULT_14_BOLD.copyWith(
                                          color:
                                              data.data![index].action != null
                                                  ? COLORS.TEXT_BLUE_BOLD
                                                  : COLORS.TEXT_GREY_BOLD),
                                    )),
                              ),
                            ],
                          ),
                        )
                      : SizedBox(),
            ),
          ),
          AppValue.vSpaceTiny,
          LineHorizontal(),
          SizedBox(
            height: 25,
          ),
        ],
      ),
    ));
  }

  TextStyle ValueStyle([String? color]) => TextStyle(
        fontFamily: "Quicksand",
        color: color == null ? HexColor("#263238") : HexColor(color),
        fontWeight: FontWeight.w700,
        fontSize: 14,
      );

  @override
  bool get wantKeepAlive => true;
}
