import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/widgets/loading_api.dart';
import 'package:gen_crm/widgets/widgets.dart';
import 'package:flutter/material.dart';
import '../../../../bloc/add_service_voucher/add_service_bloc.dart';
import '../../../../l10n/key_text.dart';
import '../../../../widgets/appbar_base.dart';

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
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
          ),
          child: Column(
            children: [
              AppValue.vSpaceSmall,
              WidgetText(
                title: getT(KeyT.enter_number_phone_or_license_plates),
                style: TextStyle(
                  color: COLORS.BLACK,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              AppValue.vSpaceSmall,
              _fieldInputCustomer(getT(KeyT.phone), TextInputType.number,
                  getT(KeyT.enter_phone), (v) {
                sdt = v;
              }),
              _fieldInputCustomer(getT(KeyT.license_plates), TextInputType.text,
                  getT(KeyT.enter_license_plates), (v) {
                bienSo = v;
              }),
              AppValue.vSpaceTiny,
              WidgetButton(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  if (sdt.trim() == '' && bienSo.trim() == '') {
                    ShowDialogCustom.showDialogBase(
                      title: getT(KeyT.notification),
                      content: getT(KeyT
                          .you_must_enter_your_phone_number_or_license_plates),
                    );
                  } else {
                    ServiceVoucherBloc.of(context).add(
                      PostServiceVoucherEvent(
                        sdt.trim(),
                        bienSo.trim(),
                      ),
                    );
                  }
                },
                textStyle: TextStyle(
                  fontFamily: "Quicksand",
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                text: getT(KeyT.check),
              ),
            ],
          ),
        ),
      ),
    );
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
              border: Border.all(
                color: COLORS.ffBEB4B4,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                left: 10,
                top: 5,
                bottom: 5,
              ),
              child: Container(
                child: TextField(
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  keyboardType: textInputType,
                  onChanged: (v) => onChange(v),
                  decoration: InputDecoration(
                    hintText: prefixText,
                    hintStyle: AppStyle.DEFAULT_14W500,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
