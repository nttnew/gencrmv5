import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gen_crm/screens/menu/widget/box_item.dart';
import 'package:gen_crm/src/models/model_generator/report_contact.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../../bloc/report/report_bloc/report_bloc.dart';
import '../../../../../l10n/key_text.dart';
import '../../../../../src/src_index.dart';
import '../../../../../widgets/image_default.dart';
import '../../../../../widgets/listview/list_load_infinity.dart';
import '../../../../../widgets/widget_text.dart';

class BodyReportOne extends StatelessWidget {
  const BodyReportOne({
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
                return bloc.getReportContact(
                  page: page,
                );
              },
              itemWidget: (int index, data) {
                DataListContact snap = data;
                return _item(
                  snap,
                );
              },
              controller: bloc.controllerContact,
            ),
          ),
        ],
      ),
    );
  }

  Widget _item(DataListContact dataContact) => BoxItem(
        onTap: () {
          AppNavigator.navigateDetailContract(
            dataContact.id ?? '',
            onRefreshForm: (){
              bloc.controllerContact.reloadData();
            }
          );
        },
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
                    title: dataContact.name ?? '',
                    style: AppStyle.DEFAULT_TITLE_PRODUCT
                        .copyWith(color: COLORS.TEXT_COLOR),
                  ),
                ),
                Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: dataContact.status_color != ''
                        ? HexColor(dataContact.status_color!)
                        : COLORS.RED,
                    borderRadius: BorderRadius.circular(
                      99,
                    ),
                  ),
                  width: AppValue.widths * 0.08,
                  height: AppValue.heights * 0.02,
                )
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              children: [
                SvgPicture.asset(
                  ICONS.IC_USER2_SVG,
                  color: Color(0xffE75D18),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: WidgetText(
                    title: dataContact.customer?.name ?? getT(KeyT.not_yet),
                    style: AppStyle.DEFAULT_LABEL_PRODUCT,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              children: [
                SvgPicture.asset(
                  ICONS.IC_DANG_XU_LY_SVG,
                  color: dataContact.status_color != ''
                      ? HexColor(dataContact.status_color!)
                      : COLORS.RED,
                ),
                SizedBox(
                  width: 10,
                ),
                WidgetText(
                  title: dataContact.status,
                  style: AppStyle.DEFAULT_LABEL_PRODUCT.copyWith(
                    color: dataContact.status_color != ''
                        ? HexColor(dataContact.status_color!)
                        : COLORS.RED,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              children: [
                SvgPicture.asset(
                  ICONS.IC_MAIL_SVG,
                  color: Colors.grey,
                ),
                SizedBox(
                  width: 10,
                ),
                WidgetText(
                  title: '${getT(KeyT.sales)}: ' +
                      dataContact.price.toString() +
                      money,
                  style: AppStyle.DEFAULT_LABEL_PRODUCT
                      .copyWith(color: COLORS.GREY),
                ),
                Spacer(),
              ],
            ),
            AppValue.hSpaceTiny,
          ],
        ),
      );
}
