import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/detail_chance/detail_chance_bloc.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/widget_line.dart';
import '../../../../widgets/widget_text.dart';
import '../customer/list_note.dart';

class ChanceInfo extends StatefulWidget {
  const ChanceInfo({
    Key? key,
    required this.id,
  }) : super(key: key);
  final String id;

  @override
  State<ChanceInfo> createState() => _ChanceInfoState();
}

class _ChanceInfoState extends State<ChanceInfo>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WidgetLine(
              color: Colors.grey,
            ),
            BlocBuilder<GetListDetailChanceBloc, DetailChanceState>(
                builder: (context, state) {
              if (state is UpdateGetListDetailChanceState) {
                return ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (state.data[index].data != null)
                        return Container(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppValue.vSpaceTiny,
                              WidgetText(
                                title: state.data[index].group_name ?? "",
                                style: AppStyle.DEFAULT_16_BOLD,
                              ),
                              AppValue.vSpaceTiny,
                              Column(
                                children: List.generate(
                                  state.data[index].data!.length,
                                  (index1) => state.data[index].data![index1]
                                              .value_field !=
                                          ''
                                      ? Padding(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                  flex: 1,
                                                  child: WidgetText(
                                                    title: state
                                                            .data[index]
                                                            .data![index1]
                                                            .label_field ??
                                                        '',
                                                    style: AppStyle.DEFAULT_14
                                                        .copyWith(
                                                            color: Colors.grey),
                                                  )),
                                              Expanded(
                                                  flex: 2,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      if (state
                                                              .data[index]
                                                              .data![index1]
                                                              .label_field ==
                                                          BASE_URL.KHACH_HANG) {
                                                        AppNavigator.navigateDetailCustomer(
                                                            state
                                                                .data[index]
                                                                .data![index1]
                                                                .id!,
                                                            state
                                                                    .data[index]
                                                                    .data![
                                                                        index1]
                                                                    .value_field ??
                                                                '');
                                                      }
                                                    },
                                                    child: WidgetText(
                                                        title: state
                                                                .data[index]
                                                                .data![index1]
                                                                .value_field ??
                                                            '',
                                                        textAlign:
                                                            TextAlign.right,
                                                        style: AppStyle
                                                            .DEFAULT_14
                                                            .copyWith(
                                                          decoration: state
                                                                      .data[
                                                                          index]
                                                                      .data![
                                                                          index1]
                                                                      .label_field ==
                                                                  BASE_URL
                                                                      .KHACH_HANG
                                                              ? TextDecoration
                                                                  .underline
                                                              : null,
                                                          color: state
                                                                      .data[
                                                                          index]
                                                                      .data![
                                                                          index1]
                                                                      .label_field ==
                                                                  BASE_URL
                                                                      .KHACH_HANG
                                                              ? Colors.blue
                                                              : null,
                                                        )),
                                                  ))
                                            ],
                                          ),
                                        )
                                      : SizedBox(),
                                ),
                              ),
                              AppValue.vSpaceTiny,
                              AppValue.vSpaceTiny,
                              AppValue.vSpaceTiny,
                              WidgetLine(
                                color: Colors.grey,
                              )
                            ],
                          ),
                        );
                      else
                        return Container();
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox();
                    },
                    itemCount: state.data.length);
              } else
                return Container();
            }),
            AppValue.vSpaceTiny,
            ListNote(type: 3, id: widget.id)
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
