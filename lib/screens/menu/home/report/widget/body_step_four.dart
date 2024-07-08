import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../../bloc/report/report_bloc/report_bloc.dart';
import '../../../../../l10n/key_text.dart';
import '../../../../../src/app_const.dart';
import '../../../../../src/models/model_generator/response_bao_cao.dart';
import '../../../../../src/src_index.dart';
import '../../../../../widgets/image_default.dart';
import '../../../../../widgets/listview/list_load_infinity.dart';
import '../../../../../widgets/widget_text.dart';

class BodyReportFour extends StatelessWidget {
  const BodyReportFour({
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
                return bloc.getListReportCar(
                  page: page,
                );
              },
              itemWidget: (int index, data) {
                ItemResponseReportCar snap = data;
                return _buildCustomer(snap);
              },
              controller: bloc.controllerGara,
            ),
          ),
        ],
      ),
    );
  }

  _buildCustomer(ItemResponseReportCar data) {
    return GestureDetector(
      onTap: () {
        // Get.back();
        AppNavigator.navigateDetailContract(data.id ?? '', onRefreshForm: () {
          bloc.controllerGara.reloadData();
        });
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
                  icon: ICONS.IC_CONTRACT_3X_PNG,
                  width: 16,
                  height: 16,
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: WidgetText(
                    title: data.name ?? '',
                    style: AppStyle.DEFAULT_TITLE_PRODUCT
                        .copyWith(color: COLORS.TEXT_COLOR),
                  ),
                ),
                Spacer(),
                Container(
                  decoration: BoxDecoration(
                      color:
                          data.color != "" ? HexColor(data.color!) : COLORS.RED,
                      borderRadius: BorderRadius.circular(99)),
                  width: AppValue.widths * 0.08,
                  height: AppValue.heights * 0.02,
                )
              ],
            ),
            itemTextIcon(
              text: (data.customer?.name ?? '').trim(),
              icon: ICONS.IC_USER2_SVG,
              colorIcon: HexColor('E75D18'),
            ),
            itemTextIcon(
              isSVG: false,
              text: (data.bienSo ?? '').trim(),
              icon: ICONS.IC_LICENSE_PLATE_PNG,
            ),
            itemTextIcon(
              text: (data.status ?? '').trim(),
              icon: ICONS.IC_DANG_XU_LY_SVG,
              colorIcon: data.color != "" ? HexColor(data.color!) : COLORS.RED,
              colorText: data.color != "" ? HexColor(data.color!) : COLORS.RED,
            ),
            itemTextIcon(
              text: '${getT(KeyT.total_amount)}: ' +
                  '${data.giaTriHopDong ?? 0}' +
                  money,
              icon: ICONS.IC_MAIL_SVG,
              colorIcon: Colors.grey,
              colorText: Colors.grey,
            ),
            AppValue.hSpaceTiny,
          ],
        ),
      ),
    );
  }
}
