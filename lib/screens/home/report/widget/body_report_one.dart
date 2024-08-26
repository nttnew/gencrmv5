import 'package:flutter/material.dart';
import 'package:gen_crm/screens/widget/box_item.dart';
import 'package:gen_crm/src/app_const.dart';
import 'package:gen_crm/src/models/model_generator/report_contact.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../../bloc/report/report_bloc/report_bloc.dart';
import '../../../../../l10n/key_text.dart';
import '../../../../../src/src_index.dart';
import '../../../../../widgets/listview/list_load_infinity.dart';

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
          AppNavigator.navigateDetailContract(dataContact.id ?? '',
              onRefreshForm: () {
            bloc.controllerContact.reloadData();
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            itemTextIconStart(
              title: dataContact.name ?? '',
              icon: ICONS.IC_CONTRACT_3X_PNG,
              colorDF: dataContact.status_color != ''
                  ? HexColor(dataContact.status_color ?? '#FB4C2F')
                  : COLORS.RED,
              isSVG: false,
              color: '',
            ),
            itemTextIcon(
              text: dataContact.customer?.name ?? getT(KeyT.not_yet),
              isSVG: false,
              icon: ICONS.IC_USER_NEW_PNG,
              colorIcon: Color(0xffE75D18),
            ),
            itemTextIcon(
              text: dataContact.status ?? '',
              icon: ICONS.IC_DANG_XU_LY_SVG,
              colorIcon: dataContact.status_color != ''
                  ? HexColor(dataContact.status_color!)
                  : COLORS.RED,
              colorText: dataContact.status_color != ''
                  ? HexColor(dataContact.status_color!)
                  : COLORS.RED,
            ),
            itemTextIcon(
              text: '${getT(KeyT.sales)}: ' +
                  dataContact.price.toString() +
                  money,
              icon: ICONS.IC_GROSS_PNG,
              isSVG: false,
            ),
          ],
        ),
      );
}
