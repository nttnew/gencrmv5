import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/contract/detail_contract_bloc.dart';
import 'package:gen_crm/screens/menu/home/customer/list_note.dart';
import 'package:gen_crm/widgets/line_horizontal_widget.dart';
import 'package:gen_crm/widgets/widget_text.dart';

import '../../../../src/models/model_generator/detail_contract.dart';
import '../../../../src/src_index.dart';
import '../../../../src/values.dart';
import '../../../../widgets/widget_line.dart';

class ContractOperation extends StatefulWidget {
  ContractOperation({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  State<ContractOperation> createState() => _ContractOperationState();
}

class _ContractOperationState extends State<ContractOperation> {
  @override
  void initState() {
    // Future.delayed(Duration(milliseconds: 100),(){
    //   DetailContractBloc.of(context).add(InitGetDetailContractEvent(int.parse(widget.id)));
    // });

    // DetailContractBloc.of(context).add(InitGetDetailContractEvent(98));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(bottom: 10),
        child: BlocBuilder<DetailContractBloc, DetailContractState>(
            builder: (context, state) {
          if (state is SuccessDetailContractState)
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      List.generate(state.listDetailContract.length, (index) {
                    if (state.listDetailContract[index].data != null) {
                      return _buildContent1(state.listDetailContract[index]);
                    } else
                      return Container();
                  }),
                ),
                WidgetLine(
                  color: Colors.grey,
                ),
                // WidgetText(
                //   title: "Thảo luận",
                //   style: AppStyle.DEFAULT_16_BOLD,
                // ),
                ListNote(type: 4, id: widget.id)
              ],
            );
          else
            return Container();
        }),
      ),
    );
  }

  _buildContent1(DetailContractData data) {
    return Container(
      padding: EdgeInsets.only(bottom: 8, top: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WidgetLine(
            color: Colors.grey,
          ),
          SizedBox(
            height: 8,
          ),
          WidgetText(
            title: data.group_name,
            style: AppStyle.DEFAULT_16_BOLD,
          ),
          Column(
            children: List.generate(
              data.data!.length,
              (index) {
                if (data.data![index].field_type == "LINE") {
                  return Container(
                      margin: EdgeInsets.symmetric(vertical: 3),
                      child: LineHorizontal());
                } else
                  return  data.data![index].value_field != ''
                      ? Container(
                    padding: EdgeInsets.only(top: 3, bottom: 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: WidgetText(
                            title: data.data![index].label_field ?? "",
                            style: AppStyle.DEFAULT_14
                                .copyWith(color: Colors.grey),
                          ),
                        ),
                        Expanded(
                            flex: 2,
                            child: GestureDetector(
                              onTap: (){
                                if(data.data![index].label_field==BASE_URL.KHACH_HANG
                                ){
                                  AppNavigator.navigateDetailCustomer(data.data![index].id!,data.data![index].value_field ?? '');
                                }
                              },
                              child: WidgetText(
                                  title: data.data![index].value_field ?? '',
                                  textAlign: TextAlign.right,
                                  style: AppStyle.DEFAULT_14.copyWith(
                                    decoration: data.data![index].label_field==BASE_URL.KHACH_HANG?
                                    TextDecoration.underline:null,
                                    color: data.data![index].label_field==BASE_URL.KHACH_HANG?
                                        Colors.blue:null,
                                  )
                              ),
                            ))
                      ],
                    ),
                  )  : SizedBox();
              },
            ),
          )
        ],
      ),
    );
  }

  _buildContent2() {
    return Container(
      height: AppValue.heights * 0.18,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nhóm nội dung 2',
            style: AppStyle.DEFAULT_16_BOLD,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Địa chỉ',
                style: AppStyle.DEFAULT_14.copyWith(color: Colors.grey),
              ),
              Text('298 Cầu giấy', style: AppStyle.DEFAULT_14)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Điện thoại',
                style: AppStyle.DEFAULT_14.copyWith(color: Colors.grey),
              ),
              Text('0983 123 456', style: AppStyle.DEFAULT_14)
            ],
          ),
          WidgetLine(
            color: Colors.grey,
          )
        ],
      ),
    );
  }

  _discuss() {
    return ListView.separated(
      shrinkWrap: true,
      // physics: NeverScrollableScrollPhysics(),
      itemCount: 2,
      itemBuilder: (context, index) {
        return Row(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: AppValue.heights * 0.1),
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/images/img-1.png'),
              ),
            ),
            AppValue.hSpaceTiny,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nguyễn Hoàng Nam',
                    style: AppStyle.DEFAULT_14
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '20/03/2022 lúc 05:15 PM',
                    style:
                        AppStyle.DEFAULT_12.copyWith(color: Color(0xff838A91)),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    'Chị Thảo muốn nhận báo giá có ưu đãi. Nếu giá tốt sẽ bắt đầu triển khai ngay vào đầu tháng tới. Chú ý: gửi báo giá cả bản cứng và bản mềm cho chị.',
                    style: AppStyle.DEFAULT_14
                        .copyWith(fontWeight: FontWeight.w500),
                  )
                ],
              ),
            )
          ],
        );
      },
      separatorBuilder: (BuildContext context, int index) => const SizedBox(
        height: 8,
      ),
    );
  }
}
