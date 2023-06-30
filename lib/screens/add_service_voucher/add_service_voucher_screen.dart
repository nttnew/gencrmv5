import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/widgets/loading_api.dart';
import 'package:gen_crm/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../bloc/add_service_voucher/add_service_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import '../../widgets/appbar_base.dart';

class AddServiceVoucherScreen extends StatefulWidget {
  const AddServiceVoucherScreen({Key? key, required this.title})
      : super(key: key);

  @override
  State<AddServiceVoucherScreen> createState() =>
      _AddServiceVoucherScreenState();
  final String title;
}

class _AddServiceVoucherScreenState extends State<AddServiceVoucherScreen> {
  String sdt = '';
  String bienSo = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: COLORS.WHITE,
        appBar: AppbarBaseNormal(widget.title),
        body: BlocListener<ServiceVoucherBloc, ServiceVoucherState>(
          listener: (context, state) {
            if (state is GetServiceVoucherState) {
              LoadingApi().popLoading();
              AppNavigator.navigateAddServiceVoucherStepTwo(widget.title);
            }
          },
          child: Container(
            padding: EdgeInsets.only(
              left: 25,
              right: 25,
              top: 20,
            ),
            color: COLORS.WHITE,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  AppValue.vSpaceSmall,
                  WidgetText(
                      title: AppLocalizations.of(Get.context!)
                          ?.enter_number_phone_or_license_plates,
                      style: TextStyle(
                        color: COLORS.BLACK,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      )),
                  AppValue.vSpaceSmall,
                  _fieldInputCustomer(
                      AppLocalizations.of(Get.context!)?.phone??'',
                      TextInputType.number,
                      AppLocalizations.of(Get.context!)?.enter_phone??'', (v) {
                    sdt = v;
                  }),
                  _fieldInputCustomer(
                      AppLocalizations.of(Get.context!)?.license_plates??'',
                      TextInputType.text,
                      AppLocalizations.of(Get.context!)?.enter_license_plates??'',
                      (v) {
                    bienSo = v;
                  }),
                  AppValue.vSpaceTiny,
                  WidgetButton(
                    onTap: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      if (sdt.trim() == '' && bienSo.trim() == '') {
                        ShowDialogCustom.showDialogBase(
                          title:
                              AppLocalizations.of(Get.context!)?.notification,
                          content: AppLocalizations.of(Get.context!)
                              ?.you_must_enter_your_phone_number_or_license_plates,
                        );
                      } else {
                        ServiceVoucherBloc.of(context).add(
                            PostServiceVoucherEvent(sdt.trim(), bienSo.trim()));
                      }
                    },
                    boxDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(17),
                      color: HexColor("#D0F1EB"),
                    ),
                    textStyle: TextStyle(
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                    text: AppLocalizations.of(Get.context!)?.check,
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _fieldInputCustomer(String label, TextInputType textInputType,
      String prefixText, Function(String v) onChange) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            text: TextSpan(
              text: label,
              style: AppStyle.DEFAULT_14W600,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: HexColor("#BEB4B4"))),
            child: Padding(
              padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
              child: Container(
                child: TextField(
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  keyboardType: textInputType,
                  onChanged: (v) => onChange(v),
                  decoration: InputDecoration(
                      hintText: prefixText,
                      hintStyle: AppStyle.DEFAULT_14W500,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      isDense: true),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
