import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/widgets/btn_thao_tac.dart';
import 'package:gen_crm/widgets/loading_api.dart';
import 'package:flutter/material.dart';
import '../../../../bloc/add_service_voucher/add_service_bloc.dart';
import '../../../../l10n/key_text.dart';
import '../../../../widgets/appbar_base.dart';

class AddServiceVoucherScreen extends StatefulWidget {
  const AddServiceVoucherScreen({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<AddServiceVoucherScreen> createState() =>
      _AddServiceVoucherScreenState();
  final String title;
}

class _AddServiceVoucherScreenState extends State<AddServiceVoucherScreen>
    with AutomaticKeepAliveClientMixin {
  TextEditingController _txtPhone = TextEditingController();
  TextEditingController _txtBienSo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              AppValue.vSpaceTiny,
              TabBar(
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                isScrollable: true,
                indicatorColor: COLORS.TEXT_COLOR,
                labelColor: COLORS.TEXT_COLOR,
                unselectedLabelColor: COLORS.GREY,
                labelStyle: AppStyle.DEFAULT_LABEL_TARBAR,
                tabs: [
                  Tab(
                    text: getT(KeyT.phone),
                  ),
                  Tab(
                    text: getT(KeyT.license_plates),
                  )
                ],
              ),
              AppValue.vSpaceMedium,
              Expanded(
                child: TabBarView(
                  children: [
                    _fieldInputCustomer(
                      getT(KeyT.phone),
                      TextInputType.number,
                      getT(KeyT.enter_phone),
                      _txtPhone,
                    ),
                    _fieldInputCustomer(
                      getT(KeyT.license_plates),
                      TextInputType.text,
                      getT(KeyT.enter_license_plates),
                      _txtBienSo,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _button(bool isPhone) => ButtonThaoTac(
        marginHorizontal: 0,
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          if (_txtPhone.text.trim() == '' && isPhone ||
              _txtBienSo.text.trim() == '' && !isPhone) {
            ShowDialogCustom.showDialogBase(
              title: getT(KeyT.notification),
              content:
                  getT(KeyT.you_must_enter_your_phone_number_or_license_plates),
            );
          } else {
            ServiceVoucherBloc.of(context).add(
              PostServiceVoucherEvent(
                isPhone ? _txtPhone.text.trim() : '',
                isPhone ? '' : _txtBienSo.text.trim(),
              ),
            );
          }
        },
        title: getT(KeyT.check),
      );

  Widget _fieldInputCustomer(
    String label,
    TextInputType textInputType,
    String hintText,
    TextEditingController textEditingController,
  ) {
    bool isPhone = getT(KeyT.phone) == label;
    return Container(
      margin: EdgeInsets.only(
        bottom: 16,
        right: 16,
        left: 16,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
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
                      controller: textEditingController,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      keyboardType: textInputType,
                      decoration: InputDecoration(
                        hintText: hintText,
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
          _button(isPhone),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
