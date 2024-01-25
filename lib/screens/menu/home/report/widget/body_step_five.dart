import 'package:flutter/material.dart';
import '../../../../../bloc/report/report_bloc/report_bloc.dart';
import '../../../../../l10n/key_text.dart';
import '../../../../../src/app_const.dart';
import '../../../../../src/models/model_generator/response_bao_cao_so_quy.dart';
import '../../../../../src/src_index.dart';
import '../../../../../widgets/image_default.dart';
import '../../../../../widgets/listview/list_load_infinity.dart';
import '../../../../../widgets/widget_text.dart';

class BodyReportFive extends StatelessWidget {
  const BodyReportFive({
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
                return bloc.getBaoCaoSoQuy(
                  page: page,
                );
              },
              itemWidget: (int index, data) {
                DataListSoQuy snap = data;
                return _buildCustomer(snap);
              },
              controller: bloc.controllerSoQuy,
            ),
          ),
        ],
      ),
    );
  }

  _buildCustomer(DataListSoQuy data) {
    return GestureDetector(
      onTap: () {
        //todo
      },
      child: Container(
        margin: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 16,
        ),
        padding: EdgeInsets.all(
          16,
        ),
        decoration: BoxDecoration(
          color: COLORS.WHITE,
          borderRadius: BorderRadius.circular(
            10,
          ),
          border: Border.all(width: 1, color: COLORS.WHITE),
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
          children: [
            Row(
              children: [
                ImageBaseDefault(
                  icon: ICONS.IC_WALLET_PNG,
                  height: 16,
                  width: 16,
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: WidgetText(
                    title: data.soPhieu ?? '',
                    style: AppStyle.DEFAULT_TITLE_PRODUCT
                        .copyWith(color: COLORS.TEXT_COLOR),
                  ),
                ),
                _getWidget(data.thu ?? 0),
              ],
            ),
            itemTextIcon(
              text: data.ghiChu ?? '',
              icon: ICONS.IC_CIRCLE_SMALL_PNG,
              isSVG: false,
              colorIcon: COLORS.GREY,
            ),
            itemTextIcon(
              text: data.hinhThucTt ?? '',
              icon: ICONS.IC_CIRCLE_SMALL_PNG,
              isSVG: false,
              colorIcon: COLORS.GREY,
            ),
            itemTextIcon(
              text: AppValue.format_money(data.soTien ?? ''),
              icon: ICONS.IC_CIRCLE_SMALL_PNG,
              isSVG: false,
              colorIcon: COLORS.GREY,
            ),
          ],
        ),
      ),
    );
  }

  _getWidget(int dataThu) => Container(
        decoration: BoxDecoration(
          color: _getColor(dataThu),
          borderRadius: BorderRadius.circular(99),
        ),
        padding: EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 8,
        ),
        child: Center(
          child: WidgetText(
            title: _getTXT(dataThu),
            style: AppStyle.DEFAULT_14.copyWith(
              color: COLORS.WHITE,
            ),
          ),
        ),
      );

  _getColor(int dataThu) {
    return dataThu == 1 ? COLORS.GREEN : COLORS.RED;
  }

  _getTXT(int dataThu) {
    return dataThu == 1 ? getT(KeyT.expenses) : getT(KeyT.income);
  }
}
