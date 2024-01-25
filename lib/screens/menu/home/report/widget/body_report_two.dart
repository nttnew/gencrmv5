import 'package:flutter/material.dart';
import '../../../../../bloc/report/report_bloc/report_bloc.dart';
import '../../../../../l10n/key_text.dart';
import '../../../../../src/models/model_generator/report_product.dart';
import '../../../../../src/src_index.dart';
import '../../../../../widgets/listview/list_load_infinity.dart';

class BodyReportTwo extends StatelessWidget {
  const BodyReportTwo({
    Key? key,
    required this.money,
    required this.bloc,
  }) : super(key: key);
  final String money;
  final ReportBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      margin: EdgeInsets.only(
        top: 16,
      ),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerRight,
            width: 60,
            height: 4,
            margin: EdgeInsets.only(
              bottom: 10,
            ),
            decoration: BoxDecoration(
              color: COLORS.GREY,
              borderRadius: BorderRadius.all(
                Radius.circular(
                  10,
                ),
              ),
            ),
          ),
          Expanded(
            child: ViewLoadMoreBase(
              isInit: true,
              functionInit: (page, isInit) {
                return bloc.getReportGeneralSelect(
                  page: page,
                );
              },
              itemWidget: (int index, data) {
                ListReportProduct snap = data;
                return Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(
                      0.1,
                    ),
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            snap.name ?? getT(KeyT.undefined),
                            style: AppStyle.DEFAULT_18,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        '${snap.doanh_so ?? getT(KeyT.undefined)}$money',
                        style: AppStyle.DEFAULT_16,
                      ),
                    ],
                  ),
                );
              },
              controller: bloc.controllerGeneralSelect,
            ),
          ),
        ],
      ),
    );
  }
}
