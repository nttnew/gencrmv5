import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../bloc/job_contract/job_contract_bloc.dart';
import '../../../../src/models/model_generator/job_chance.dart';
import '../../../../src/src_index.dart';

class ContractJob extends StatefulWidget {
  ContractJob({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  State<ContractJob> createState() => _ContractJobState();
}

class _ContractJobState extends State<ContractJob>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
        padding: EdgeInsets.only(bottom: 10),
        child: BlocBuilder<JobContractBloc, JobContractState>(
            builder: (context, state) {
          if (state is SuccessJobContractState) if (state.listJob.length > 0)
            return ListView.separated(
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      AppNavigator.navigateDeatailWork(
                          int.parse(state.listJob[index].id!),
                          state.listJob[index].name_job ?? '');
                    },
                    child: _tabBarWork(state.listJob[index]),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(
                      height: 10,
                    ),
                itemCount: state.listJob.length);
          else
            return Center(
              child: WidgetText(
                title: "Không có dữ liệu",
                style: AppStyle.DEFAULT_18,
              ),
            );
          else
            return Container();
        }));
  }

  _tabBarWork(DataFormAdd data) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      decoration: BoxDecoration(
        color: COLORS.WHITE,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(width: 1, color: Colors.white),
        boxShadow: [
          BoxShadow(
            color: COLORS.BLACK.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: WidgetText(
                  title: data.name_job ?? "",
                  style: AppStyle.DEFAULT_TITLE_PRODUCT
                      .copyWith(color: COLORS.TEXT_COLOR),
                ),
                width: AppValue.widths * 0.7,
              ),
              Image.asset(
                'assets/icons/red.png',
                color: (data.color != null && data.color != "")
                    ? HexColor(data.color!)
                    : COLORS.PRIMARY_COLOR,
              )
            ],
          ),
          AppValue.vSpaceTiny,
          if (data.name_customer?.isNotEmpty ?? false) ...[
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/User.svg',
                  color: Color(0xffE75D18),
                ),
                AppValue.hSpaceTiny,
                WidgetText(
                    title: data.name_customer ?? "",
                    style: AppStyle.DEFAULT_LABEL_PRODUCT),
              ],
            ),
            AppValue.vSpaceTiny,
          ],
          if (data.status_job?.isNotEmpty ?? false) ...[
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/dangxuly.svg',
                  color: (data.color != null && data.color != "")
                      ? HexColor(data.color!)
                      : COLORS.PRIMARY_COLOR,
                ),
                AppValue.hSpaceTiny,
                WidgetText(
                  title: data.status_job ?? "",
                  style: AppStyle.DEFAULT_LABEL_PRODUCT.copyWith(
                      color: (data.color != null && data.color != "")
                          ? HexColor(data.color!)
                          : COLORS.PRIMARY_COLOR),
                ),
              ],
            ),
            AppValue.vSpaceTiny,
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset('assets/icons/date.png'),
                  AppValue.hSpaceTiny,
                  WidgetText(
                      title: data.start_date ?? "",
                      style: AppStyle.DEFAULT_LABEL_PRODUCT
                          .copyWith(color: Colors.grey)),
                ],
              ),
              Row(
                children: [
                  SvgPicture.asset('assets/icons/Mess.svg'),
                  SizedBox(
                    width: 5,
                  ),
                  WidgetText(
                    title: data.total_comment.toString(),
                    style: AppStyle.DEFAULT_12
                        .copyWith(color: COLORS.TEXT_BLUE_BOLD),
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
