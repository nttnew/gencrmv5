import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../bloc/blocs.dart';
import '../../../../src/models/model_generator/job_chance.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/widget_text.dart';

class JobListChance extends StatefulWidget {
  const JobListChance({Key? key, required this.id}) : super(key: key);

  final String? id;

  @override
  State<JobListChance> createState() => _JobListChanceState();
}

class _JobListChanceState extends State<JobListChance>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<GetJobChanceBloc, JobChanceState>(
        builder: (context, state) {
      if (state is UpdateGetJobChanceState) {
        if (state.data.length > 0) {
          return Padding(
            padding: EdgeInsets.only(top: 15),
            child: Container(
                padding: EdgeInsets.only(bottom: 10),
                child: ListView.separated(
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          AppNavigator.navigateDetailWork(
                              int.parse(state.data[index].id!),
                              state.data[index].name_job ?? '',
                          );
                        },
                        child: _tabBarWork(state.data[index]),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(
                          height: 10,
                        ),
                    itemCount: state.data.length)),
          );
        } else
          return Center(
            child: WidgetText(
              title: "Không có dữ liệu",
              style: AppStyle.DEFAULT_18,
            ),
          );
      } else
        return Container(
          child: Center(
            child: Text(
              'Không có dữ liệu!',
              style: AppStyle.DEFAULT_LABEL_TARBAR,
            ),
          ),
        );
    });
  }

  _tabBarWork(DataFormAdd data) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Container(
        height: AppValue.heights * 0.25,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        width: AppValue.widths,
        decoration: BoxDecoration(
          color: COLORS.WHITE,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 1, color: Colors.white),
          boxShadow: [
            BoxShadow(
              color: COLORS.BLACK.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: WidgetText(
                    title: data.name_job,
                    style: AppStyle.DEFAULT_TITLE_PRODUCT
                        .copyWith(color: COLORS.TEXT_COLOR),
                  ),
                  width: AppValue.widths * 0.7,
                ),
                if (data.user_work_name != '')
                  Row(
                    children: [
                      SvgPicture.asset(
                        ICONS.IC_USER2_SVG,
                        color: Color(0xffE75D18),
                      ),
                      AppValue.hSpaceTiny,
                      WidgetText(
                          title: data.user_work_name,
                          style: AppStyle.DEFAULT_LABEL_PRODUCT),
                    ],
                  ),
                if (data.status_job != '')
                  Row(
                    children: [
                      SvgPicture.asset(ICONS.IC_DANG_XU_LY_SVG),
                      AppValue.hSpaceTiny,
                      WidgetText(
                        title: data.status_job ?? '',
                        style: AppStyle.DEFAULT_LABEL_PRODUCT
                            .copyWith(color: Colors.red),
                      ),
                    ],
                  ),
                Row(
                  children: [
                    Image.asset(ICONS.IC_DATE_PNG,height: 20,width: 20,),
                    AppValue.hSpaceTiny,
                    WidgetText(
                        title: data.start_date,
                        style: AppStyle.DEFAULT_LABEL_PRODUCT
                            .copyWith(color: Colors.grey)),
                  ],
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(ICONS.IC_RED_PNG),
                  Row(children: [
                    SvgPicture.asset(ICONS.IC_MESS),
                    SizedBox(
                      width: 3,
                    ),
                    WidgetText(
                        title: data.total_comment.toString(),
                        style: TextStyle(
                          color: HexColor("#0052B4"),
                        ))
                  ])
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
