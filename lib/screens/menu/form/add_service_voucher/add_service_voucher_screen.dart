import 'dart:async';
import 'package:gen_crm/src/app_const.dart';
import 'package:gen_crm/src/models/model_generator/customer.dart';
import 'package:gen_crm/src/models/model_generator/list_product_customer_response.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/widgets/btn_thao_tac.dart';
import 'package:flutter/material.dart';
import '../../../../bloc/add_service_voucher/add_service_bloc.dart';
import '../../../../l10n/key_text.dart';
import '../../../../widgets/appbar_base.dart';
import '../../../../widgets/listview/list_load_infinity.dart';
import '../../../../widgets/search_base.dart';
import '../../home/customer/widget/item_list_customer.dart';
import '../../home/product/scanner_qrcode.dart';
import '../../home/product_customer/widget/item_product_customer.dart';

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
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  TextEditingController _txtPhone = TextEditingController();
  TextEditingController _txtBienSo = TextEditingController();
  late final ServiceVoucherBloc _bloc;
  bool isDataPhone = true;
  bool isDataCar = true;
  late final StreamSubscription _streamSubscription;
  late final TabController _tabController;

  @override
  void initState() {
    _bloc = ServiceVoucherBloc.of(context);
    _tabController = TabController(length: 2, vsync: this);
    _streamSubscription = _bloc.listCarSearchStream.listen((value) {
      if (value.runtimeType == List<CustomerData>) {
        if ((value as List).length == 1) {
          AppNavigator.navigateForm(
            title: widget.title,
            type: ADD_QUICK_CONTRACT,
            sdt: _tabController.index == 0
                ? (value.first as CustomerData).phone?.val //phone
                : '',
            bienSo: _tabController.index == 0
                ? ''
                : (value.firstOrNull as CustomerData).name,
          );
        } else if ((value).length == 0) {
          AppNavigator.navigateForm(
            title: widget.title,
            type: ADD_QUICK_CONTRACT,
            sdt: _tabController.index == 0 ? _txtPhone.text : '',
            bienSo: _tabController.index == 0 ? '' : _txtBienSo.text,
          );
        }
      }
    });
    _bloc.init();
    super.initState();
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    _bloc.listCarSearchStream.add(null); //reset data
    _bloc.loadMoreControllerBienSo.dispose();
    _bloc.loadMoreControllerPhone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: COLORS.WHITE,
      appBar: AppbarBaseNormal(widget.title),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            AppValue.vSpaceTiny,
            TabBar(
              controller: _tabController,
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
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _tabBody(
                    getT(KeyT.phone),
                    TextInputType.number,
                    getT(KeyT.enter_phone),
                    _txtPhone,
                    _bloc.loadMoreControllerPhone,
                    true,
                  ),
                  _tabBody(
                    getT(KeyT.license_plates),
                    TextInputType.text,
                    getT(KeyT.enter_license_plates),
                    _txtBienSo,
                    _bloc.loadMoreControllerBienSo,
                    false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _onTap(bool isPhone) {
    if (_txtPhone.text.trim() == '' && isPhone ||
        _txtBienSo.text.trim() == '' && !isPhone) {
      ShowDialogCustom.showDialogBase(
        title: getT(KeyT.notification),
        content: getT(KeyT.you_must_enter_your_phone_number_or_license_plates),
      );
    } else {
      if (isPhone) {
        isDataPhone = false;
        _bloc.loadMoreControllerPhone.reloadData();
      } else {
        isDataCar = false;
        _bloc.loadMoreControllerBienSo.reloadData();
      }
    }
  }

  _button(bool isPhone) => ButtonThaoTac(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          _onTap(isPhone);
        },
        title: getT(KeyT.check),
      );

  Widget _tabBody(
    String label,
    TextInputType textInputType,
    String hintText,
    TextEditingController textEditingController,
    LoadMoreController loadMoreController,
    bool isPhone,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: RichText(
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                text: TextSpan(
                  text: label,
                  style: AppStyle.DEFAULT_14W600,
                ),
              ),
            ),
            SearchBase(
              inputType: isPhone ? TextInputType.phone : null,
              controller: textEditingController,
              hint: hintText,
              endIcon: GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (context) => ScannerQrcode()))
                      .then((value) async {
                    if (value != '') {
                      _bloc.qr = value;
                      if (isPhone) {
                        _txtPhone.text = '';
                        isDataPhone = false;
                        _bloc.loadMoreControllerPhone.reloadData();
                      } else {
                        _txtBienSo.text = '';
                        isDataCar = false;
                        _bloc.loadMoreControllerBienSo.reloadData();
                      }
                    } else {
                      ShowDialogCustom.showDialogBase(
                        title: getT(KeyT.notification),
                        content: getT(KeyT.no_data),
                      );
                    }
                  });
                },
                child: Icon(
                  Icons.qr_code_scanner,
                  size: 20,
                ),
              ),
              onChange: (String v) {
                _bloc.qr = '';
              },
            ),
          ],
        ),
        Expanded(
          child: ViewLoadMoreBase(
            noDataWidget: isPhone
                ? isDataPhone
                    ? SizedBox()
                    : null
                : isDataCar
                    ? SizedBox()
                    : null,
            functionInit: (page, isInit) {
              return _bloc.getSearchQuickCreate(
                page: page,
                isPhone: isPhone,
                bienSoSearch: _txtBienSo.text,
                phoneSearch: _txtPhone.text,
              );
            },
            itemWidget: (int index, data) {
              final CustomerData item = data as CustomerData;
              return isPhone
                  ? ItemCustomer(
                      data: item,
                      onTap: () {
                        AppNavigator.navigateForm(
                          title: widget.title,
                          type: ADD_QUICK_CONTRACT,
                          sdt: item.phone?.val ?? '',
                        );
                      },
                    )
                  : ItemProductCustomer(
                      productModule: ProductCustomerResponse(
                        name: item.name,
                        customer: item.customer,
                        phone: item.phone,
                        loai: item.loai,
                      ),
                      onTap: () {
                        AppNavigator.navigateForm(
                          title: widget.title,
                          type: ADD_QUICK_CONTRACT,
                          bienSo: item.name,
                        );
                      },
                    );
            },
            controller: loadMoreController,
          ),
        ),
        _button(isPhone),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
