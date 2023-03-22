
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gen_crm/widgets/widget_button.dart';
import 'package:gen_crm/widgets/widgets.dart';

import '../../../../bloc/authen/authentication_bloc.dart';
import '../../../../src/src_index.dart';
import 'package:grouped_list/grouped_list.dart';
import '../../../../widgets/widget_dialog.dart';

class WidgetItemChance extends StatelessWidget {
  final ListChanceData listChanceData;
  // final CustomerData customerData;

  const WidgetItemChance({required this.listChanceData, });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){AppNavigator.navigateInfoChance(listChanceData.id!,listChanceData.name!);
        print({listChanceData.id});
        },
      child: Container(
        margin: EdgeInsets.only(left: 25,right: 25,bottom: 20),
        padding: EdgeInsets.symmetric(vertical: 15,horizontal: 15),
        decoration: BoxDecoration(
          color: COLORS.WHITE,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 1,color: Colors.white),
          boxShadow: [
            BoxShadow(
              color: COLORS.BLACK.withOpacity(0.1),
              spreadRadius: 1, blurRadius: 5,)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset('assets/icons/Chance.png'),
                SizedBox(width: 10,),
                SizedBox(
                    width: AppValue.widths*0.6,
                    child: WidgetText(title:listChanceData.name,style: AppStyle.DEFAULT_TITLE_PRODUCT.copyWith(color: COLORS.TEXT_COLOR),)),
                Spacer(),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(99)),
                  width: AppValue.widths * 0.1,
                  height: AppValue.heights * 0.02,
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
        if ((listChanceData.customer?.name??'').trim() != '') ...[

    Row(
              children: [
                SvgPicture.asset('assets/icons/User.svg'),
                SizedBox(width: 10,),
                SizedBox(
                  width: AppValue.widths*0.7,
                  child: WidgetText(
                    title: '${listChanceData.customer!.danh_xung ??''}'
                        + ' ' +
                        '${listChanceData.customer!.name ??''}',
                    style: AppStyle.DEFAULT_LABEL_PRODUCT),
                  ),
                ],
            ),
            SizedBox(
              height: 15,
            ),            ],
    if (listChanceData.status != '') ...[

            Row(
              children: [
                SvgPicture.asset('assets/icons/dangxuly.svg'),
                SizedBox(width: 10,),
                WidgetText(title:listChanceData.status,style:  AppStyle.DEFAULT_LABEL_PRODUCT.copyWith(color: Colors.red)),
              ],
            ),
            SizedBox(
              height: 15,
            ),            ],

            Row(
              children: [
                Image.asset('assets/icons/date.png'),
                SizedBox(width: 10,),
                WidgetText(title: (listChanceData.dateNextCare == null || listChanceData.dateNextCare == "")
                    ? 'Chưa có' : listChanceData.dateNextCare,
                    style: AppStyle.DEFAULT_LABEL_PRODUCT.copyWith(color: COLORS.TEXT_COLOR)),
                Spacer(),
                SvgPicture.asset('assets/icons/Mess.svg'),
              ],
            ),
            AppValue.hSpaceTiny,
          ],
        ),
      ),
    );
  }
}