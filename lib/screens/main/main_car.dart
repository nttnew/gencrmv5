import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:gen_crm/screens/main/show_detail_car.dart';
import 'package:gen_crm/src/models/model_generator/report_option.dart';
import '../../bloc/login/login_bloc.dart';
import '../../l10n/key_text.dart';
import '../../src/app_const.dart';
import '../../src/models/model_generator/xe_dich_vu_response.dart';
import '../../src/src_index.dart';
import '../../storages/share_local.dart';
import '../../widgets/dialog_call.dart';
import '../../widgets/listview/list_load_infinity.dart';
import 'package:gen_crm/widgets/widget_text.dart';

import '../../widgets/loading_api.dart';

class MainCar extends StatefulWidget {
  const MainCar({Key? key}) : super(key: key);

  @override
  State<MainCar> createState() => _MainCarState();
}

class _MainCarState extends State<MainCar> {
  @override
  void initState() {
    LoginBloc _blocLogin = LoginBloc.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Thực hiện hành động sau khi build hoàn thành
      context.visitChildElements((element) {
        LoadingApi().pushLoading();
      });
    });
    _blocLogin.locationStatusStream.listen((value) {
      final listTrangThai = value.data?.trangthaihd ?? [];
      if (_blocLogin.valueTrangThai == null && listTrangThai.length > 0) {
        _blocLogin.valueTrangThai = listTrangThai.firstOrNull;
        _blocLogin.initController();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LoginBloc _blocLogin = LoginBloc.of(context);
    return Expanded(
      child: ViewLoadMoreBase(
        child: SingleChildScrollView(
          child: StreamBuilder<FilterResponse>(
              stream: _blocLogin.locationStatusStream,
              builder: (context, snapshot) {
                final listLocation = snapshot.data?.data?.diem_ban ?? [];
                final listTrangThai = snapshot.data?.data?.trangthaihd ?? [];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (listLocation.length > 0)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DropdownButton2(
                                value: _blocLogin.valueLocation ??
                                    listLocation.first[1],
                                icon:
                                    const Icon(Icons.arrow_drop_down_outlined),
                                underline: SizedBox.shrink(),
                                dropdownMaxHeight: 250,
                                onChanged: (String? value) {
                                  _blocLogin.valueLocation = value ?? '';
                                  _blocLogin.loadMoreControllerCar.reloadData();
                                  setState(() {});
                                },
                                items: listLocation
                                    .map(
                                      (items) => DropdownMenuItem<String>(
                                        onTap: () {
                                          _blocLogin.location = items.first;
                                        },
                                        value: items[1],
                                        child: FittedBox(
                                          child: Text(
                                            items[1],
                                            style: AppStyle.DEFAULT_18_BOLD,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList()),
                            GestureDetector(
                              onTap: () {
                                AppNavigator.navigateReport(shareLocal
                                        .getString(PreferencesKey.MONEY) ??
                                    '');
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                  left: 16,
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: COLORS.PRIMARY_COLOR,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(
                                      4,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  getT(KeyT.report),
                                  style: AppStyle.DEFAULT_16_BOLD,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    Container(
                      constraints: BoxConstraints(
                        maxHeight: 50,
                      ),
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(
                        bottom: 16,
                      ),
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.only(
                            left: 16,
                          ),
                          itemCount: listTrangThai.length,
                          itemBuilder: (context, i) {
                            final itemData = listTrangThai[i];
                            return GestureDetector(
                              onTap: () {
                                _blocLogin.valueTrangThai =
                                    itemData == _blocLogin.valueTrangThai
                                        ? null
                                        : itemData;
                                _blocLogin.loadMoreControllerCar.reloadData();

                                setState(() {});
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                  right: 16,
                                ),
                                decoration: BoxDecoration(
                                  border: _blocLogin.valueTrangThai?.id ==
                                          itemData.id
                                      ? Border(
                                          bottom: BorderSide(
                                            color: COLORS.RED,
                                            width: 3,
                                          ),
                                        )
                                      : null,
                                ),
                                child: Text(
                                  itemData.label ?? '',
                                  style: AppStyle.DEFAULT_16_T.copyWith(
                                    fontWeight:
                                        _blocLogin.valueTrangThai == itemData
                                            ? FontWeight.w700
                                            : null,
                                    color: _blocLogin.valueTrangThai == itemData
                                        ? null
                                        : null,
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                );
              }),
        ),
        functionInit: (page, isInit) {
          return _blocLogin.getXeDichVu(
            page: page,
          );
        },
        itemWidget: (int index, data) {
          return ItemCar(
            data: data,
            onTap: () {
              showDetailCar(context, data);
            },
          );
        },
        controller: _blocLogin.loadMoreControllerCar,
      ),
    );
  }
}

class ItemCar extends StatelessWidget {
  const ItemCar({
    Key? key,
    required this.data,
    required this.onTap,
  }) : super(key: key);
  final XeDichVu data;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
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
          borderRadius: BorderRadius.all(
            Radius.circular(
              10,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(
                0.3,
              ),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: Image.asset(
                    ICONS.IC_CAR_PNG,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: WidgetText(
                    title: data.bienSo ?? getT(KeyT.not_yet),
                    style: AppStyle.DEFAULT_18.copyWith(
                      color: COLORS.ff006CB1,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: COLORS.PRIMARY_COLOR,
                    borderRadius: BorderRadius.circular(
                      99,
                    ),
                  ),
                  child: WidgetText(
                    title: data.chiNhanh ?? getT(KeyT.not_yet),
                    style: AppStyle.DEFAULT_14.copyWith(
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                AppNavigator.navigateDetailCustomer(
                    data.khachHangId ?? '', data.tenKhachHang ?? '');
              },
              child: itemTextIcon(
                text: data.tenKhachHang ?? '',
                icon: ICONS.IC_USER2_SVG,
                colorIcon: COLORS.GREY,
                styleText: AppStyle.DEFAULT_LABEL_PRODUCT.copyWith(
                  color: COLORS.TEXT_BLUE_BOLD,
                  fontSize: 14,
                ),
              ),
            ),
            itemTextIcon(
              onTap: () {
                if (data.diDong != null && data.diDong != '') {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DialogCall(
                        phone: '${data.diDong}',
                        name: '${data.tenKhachHang}',
                      );
                    },
                  );
                }
              },
              text: data.diDong ?? getT(KeyT.not_yet),
              styleText: AppStyle.DEFAULT_14.copyWith(
                fontWeight: FontWeight.w400,
                color: COLORS.TEXT_BLUE_BOLD,
              ),
              icon: ICONS.IC_PHONE_CUSTOMER_SVG,
            ),
            itemTextIcon(
              text: data.trangThai ?? getT(KeyT.not_yet),
              icon: ICONS.IC_DANG_XU_LY_SVG,
              colorIcon: COLORS.GREY,
              styleText: AppStyle.DEFAULT_14.copyWith(
                color: COLORS.ORANGE,
              ),
            ),
            itemTextIcon(
              styleText: AppStyle.DEFAULT_14.copyWith(
                fontWeight: FontWeight.w400,
                color: COLORS.TEXT_BLUE_BOLD,
              ),
              textPlus: getT(KeyT.so_phieu),
              text: data.soPhieu ?? '',
              icon: ICONS.IC_CART_PNG,
              isSVG: false,
              colorIcon: COLORS.GREY,
            ),
          ],
        ),
      ),
    );
  }
}
