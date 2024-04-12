import 'package:flutter/material.dart';
import 'package:gen_crm/screens/main/widget/item_detail_sp.dart';
import 'package:gen_crm/screens/main/widget/select_body.dart';
import 'package:gen_crm/screens/main/widget/select_multi_body.dart';
import 'package:gen_crm/src/models/model_generator/xe_dich_vu_response.dart';
import 'package:gen_crm/widgets/btn_thao_tac.dart';
import 'package:gen_crm/widgets/showToastM.dart';
import 'package:get/get.dart';
import '../../bloc/login/login_bloc.dart';
import '../../l10n/key_text.dart';
import '../../src/app_const.dart';
import '../../src/models/model_generator/detail_xe_dich_vu.dart';
import '../../src/src_index.dart';
import '../../widgets/cupertino_loading.dart';
import '../../widgets/dialog_call.dart';
import '../../widgets/widget_appbar.dart';
import '../../widgets/widget_text.dart';

// showDetailCar(
//   BuildContext context,
//   XeDichVu xeDichVu,
// ) {
//   return showModalBottomSheet(
//     isScrollControlled: true,
//     context: context,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.only(
//         topRight: Radius.circular(30),
//         topLeft: Radius.circular(30),
//       ),
//     ),
//     backgroundColor: COLORS.WHITE,
//     builder: (context) => DetailCar(
//       xeDichVu: xeDichVu,
//     ),
//   );
// }

class DetailCar extends StatefulWidget {
  const DetailCar({
    Key? key,
  }) : super(key: key);

  @override
  State<DetailCar> createState() => _DetailCarState();
}

class _DetailCarState extends State<DetailCar> {
  late final LoginBloc _blocLogin;

  final XeDichVu xeDichVu = Get.arguments;
  @override
  void initState() {
    _blocLogin = LoginBloc(
      userRepository: LoginBloc.of(context).userRepository,
      localRepository: LoginBloc.of(context).localRepository,
    );
    _blocLogin.xeDichVu = xeDichVu;
    _blocLogin.getDetailXeDichVu();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          WidgetAppbar(
            title: '',
            textColor: COLORS.BLACK,
            padding: 10,
            right: Row(
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    AppNavigator.navigateInPhieu();

                    //todo
                  },
                  icon: Icon(
                    Icons.print,
                    color: COLORS.WHITE,
                    size: 20,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    AppNavigator.navigateForm(
                      type: EDIT_CONTRACT,
                      id: int.tryParse(_blocLogin.xeDichVu?.id ?? ''),
                      onRefreshForm: () {
                        _blocLogin.getDetailXeDichVu();
                      },
                    );
                    //todo
                  },
                  icon: Icon(
                    Icons.edit_note,
                    color: COLORS.WHITE,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
                stream: _blocLogin.responseDetailXeDichVuStream,
                builder: (context, snapshot) {
                  final snapShot = snapshot.data;
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CupertinoLoading());
                  } else if (snapshot.hasError) {
                    return Text(
                      getT(KeyT.an_error_occurred),
                      style: AppStyle.DEFAULT_16_T,
                    );
                  } else {
                    if (snapShot.runtimeType == String) {
                      return Text(
                        snapShot,
                        style: AppStyle.DEFAULT_16_T,
                      );
                    }
                    final dataDetail = snapShot as DetailXeDichVuData;
                    final List<CTDichVu> listNhanCong =
                        dataDetail.listNhanCong ?? [];
                    final List<CTDichVu> listSP = dataDetail.listPhuTung ?? [];
                    return Column(
                      children: [
                        Expanded(
                          child: RefreshIndicator(
                            onRefresh: () async {
                              await _blocLogin.getDetailXeDichVu();
                            },
                            child: SingleChildScrollView(
                              physics: AlwaysScrollableScrollPhysics(),
                              padding: EdgeInsets.only(
                                top: 24,
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
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
                                                title: _blocLogin
                                                        .xeDichVu?.bienSo ??
                                                    getT(KeyT.not_yet),
                                                style: AppStyle.DEFAULT_18
                                                    .copyWith(
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
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  99,
                                                ),
                                              ),
                                              child: WidgetText(
                                                title: _blocLogin
                                                        .xeDichVu?.chiNhanh ??
                                                    getT(KeyT.not_yet),
                                                style: AppStyle.DEFAULT_14
                                                    .copyWith(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            AppNavigator.navigateDetailCustomer(
                                                _blocLogin.xeDichVu
                                                        ?.khachHangId ??
                                                    '',
                                                _blocLogin.xeDichVu
                                                        ?.tenKhachHang ??
                                                    '');
                                          },
                                          child: itemTextIcon(
                                            text: _blocLogin
                                                    .xeDichVu?.tenKhachHang ??
                                                '',
                                            icon: ICONS.IC_USER2_SVG,
                                            colorIcon: COLORS.GREY,
                                            styleText: AppStyle
                                                .DEFAULT_LABEL_PRODUCT
                                                .copyWith(
                                              color: COLORS.TEXT_BLUE_BOLD,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        itemTextIcon(
                                          onTap: () {
                                            if (_blocLogin.xeDichVu?.diDong !=
                                                    null &&
                                                _blocLogin.xeDichVu?.diDong !=
                                                    '') {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return DialogCall(
                                                    phone:
                                                        '${_blocLogin.xeDichVu?.diDong}',
                                                    name:
                                                        '${_blocLogin.xeDichVu?.tenKhachHang}',
                                                  );
                                                },
                                              );
                                            }
                                          },
                                          text: _blocLogin.xeDichVu?.diDong ??
                                              getT(KeyT.not_yet),
                                          styleText:
                                              AppStyle.DEFAULT_14.copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: COLORS.TEXT_BLUE_BOLD,
                                          ),
                                          icon: ICONS.IC_PHONE_CUSTOMER_SVG,
                                        ),
                                        itemTextIcon(
                                          text: _blocLogin.trangThaiDichVu ??
                                              _blocLogin.xeDichVu?.trangThai ??
                                              getT(KeyT.not_yet),
                                          icon: ICONS.IC_DANG_XU_LY_SVG,
                                          colorIcon: COLORS.GREY,
                                          styleText:
                                              AppStyle.DEFAULT_14.copyWith(
                                            color: COLORS.ORANGE,
                                          ),
                                        ),
                                        itemTextIcon(
                                          textPlus: getT(KeyT.ngay_vao),
                                          text: _blocLogin.xeDichVu?.ngayVao ??
                                              '',
                                          icon: ICONS.IC_CALENDAR_PNG,
                                          isSVG: false,
                                          colorIcon: COLORS.GREY,
                                        ),
                                        itemTextIcon(
                                          textPlus: getT(KeyT.ngay_ra),
                                          text:
                                              _blocLogin.xeDichVu?.ngayRa ?? '',
                                          icon: ICONS.IC_CALENDAR_PNG,
                                          isSVG: false,
                                          colorIcon: COLORS.GREY,
                                        ),
                                        itemTextIcon(
                                          onTap: () {
                                            AppNavigator.navigateDetailContract(
                                              _blocLogin.xeDichVu?.id ?? '',
                                              _blocLogin.xeDichVu?.soPhieu ??
                                                  '',
                                            );
                                          },
                                          styleText:
                                              AppStyle.DEFAULT_14.copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: COLORS.TEXT_BLUE_BOLD,
                                          ),
                                          textPlus: getT(KeyT.so_phieu),
                                          text: _blocLogin.xeDichVu?.soPhieu ??
                                              '',
                                          icon: ICONS.IC_CART_PNG,
                                          isSVG: false,
                                          colorIcon: COLORS.GREY,
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (listNhanCong.length > 0)
                                    Container(
                                      margin: EdgeInsets.only(
                                        top: 20,
                                      ),
                                      height: 1,
                                      color: COLORS.GREY_400,
                                    ),
                                  ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.only(
                                        left: 16,
                                        right: 16,
                                        bottom: 20,
                                      ),
                                      shrinkWrap: true,
                                      itemCount: listNhanCong.length,
                                      itemBuilder: (context, i) {
                                        return _itemDichVu(
                                          context,
                                          listNhanCong[i],
                                          dataDetail,
                                          _blocLogin,
                                        );
                                      }),
                                  Container(
                                    margin: EdgeInsets.only(
                                      top: 20,
                                    ),
                                    height: 1,
                                    color: COLORS.GREY_400,
                                  ),
                                  ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.only(
                                        left: 16,
                                        right: 16,
                                        bottom: 20,
                                      ),
                                      shrinkWrap: true,
                                      itemCount: listSP.length,
                                      itemBuilder: (context, i) {
                                        return ItemSanPham(
                                          dataDV: listSP[i],
                                        );
                                      }),
                                  if (listSP.length == 0)
                                    Text(
                                      getT(KeyT.no_data),
                                      style: AppStyle.DEFAULT_14_BOLD.copyWith(
                                        color: COLORS.GREY,
                                      ),
                                    )
                                ],
                              ),
                            ),
                          ),
                        ),
                        AppValue.vSpaceSmall,
                        Row(
                          children: [
                            AppValue.hSpaceSmall,
                            Expanded(
                              child: ButtonBaseSmall(
                                  title: getT(KeyT.pay),
                                  onTap: () {
                                    AppNavigator.navigateForm(
                                      title: getT(KeyT.pay),
                                      type: ADD_PAYMENT,
                                      id: int.tryParse(xeDichVu.id ?? ''),
                                      onRefreshForm: () {
                                        //todo
                                        // _blocLogin.getDetailXeDichVu();
                                      },
                                    );
                                    //todo
                                  }),
                            ),
                            // Expanded(
                            //   child: ButtonBaseSmall(
                            //       title: getT(KeyT.edit) +
                            //           ' ' +
                            //           ModuleMy.getNameModuleMy(
                            //             ModuleMy.HOP_DONG,
                            //           ),
                            //       onTap: () {
                            //         AppNavigator.navigateForm(
                            //           type: EDIT_CONTRACT,
                            //           id: int.tryParse(
                            //               _blocLogin.xeDichVu?.id ?? ''),
                            //           onRefreshFormAdd: () {
                            //             _blocLogin.getDetailXeDichVu();
                            //           },
                            //         );
                            //       }),
                            // ),
                            AppValue.hSpaceSmall,
                            Expanded(
                              child: ButtonBaseSmall(
                                title: getT(KeyT.cap_nhat_trang_thai),
                                onTap: () {
                                  showModalSelect(
                                    context,
                                    getT(KeyT.cap_nhat_trang_thai),
                                    dataDetail.listTrangThai ?? [],
                                    init: _blocLogin.trangThaiDichVu ??
                                        xeDichVu.trangThai,
                                    (data) async {
                                      final res =
                                          await _blocLogin.postUpdateTTHD(
                                              id: xeDichVu.id ?? '',
                                              idTT: '${data?.first}');

                                      if (res != '') {
                                        showToastM(context, title: res);
                                      } else {
                                        _blocLogin.trangThaiDichVu = data?.last;
                                        setState(() {});
                                        Navigator.of(context).pop();
                                        LoginBloc.of(context)
                                            .loadMoreControllerCar
                                            .reloadData();
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                            AppValue.hSpaceSmall,
                          ],
                        ),
                        AppValue.vSpaceSmall,
                        // Row(
                        //   children: [
                        //     AppValue.hSpaceSmall,
                        //     Expanded(
                        //       child: ButtonBaseSmall(
                        //           title: getT(KeyT.pay),
                        //           onTap: () {
                        //             //todo
                        //           }),
                        //     ),
                        //     AppValue.hSpaceSmall,
                        //     Expanded(
                        //       child: ButtonBaseSmall(
                        //           title: getT(KeyT.in_phieu),
                        //           onTap: () {
                        //             AppNavigator.navigateInPhieu();
                        //           }),
                        //     ),
                        //     AppValue.hSpaceSmall,
                        //   ],
                        // ),
                      ],
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }
}

_itemDichVu(
  BuildContext context,
  CTDichVu dataDV,
  DetailXeDichVuData dataDetail,
  LoginBloc blocLogin,
) {
  return Container(
    margin: EdgeInsets.only(
      top: 20,
    ),
    child: Column(
      children: [
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              margin: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: getColor(dataDV.tienDo ?? ''),
                shape: BoxShape.circle,
              ),
            ),
            Expanded(
              child: Text(
                dataDV.tenSanPham ?? '',
                style: AppStyle.DEFAULT_16_BOLD,
              ),
            ),
          ],
        ),
        AppValue.vSpace10,
        widgetTextClick(
          getT(KeyT.nguoi_lam),
          '${dataDV.nguoiThucHien}',
          () {
            _clickShow(
              context,
              blocLogin,
              dataDetail,
              dataDV,
            );
          },
          contentNull: getT(KeyT.chua_phan_cong),
          color: getColor(dataDV.tienDo ?? ''),
        ),
        AppValue.vSpace10,
        widgetTextClick(
          getT(KeyT.tien_do),
          '${dataDV.tienDo}',
          contentValueNull: '',
          () {
            _clickShow(
              context,
              blocLogin,
              dataDetail,
              dataDV,
            );
          },
          contentNull: getT(KeyT.chua_bat_dau),
          color: getColor(dataDV.tienDo ?? ''),
        ),
      ],
    ),
  );
}

_clickShow(
  BuildContext context,
  blocLogin,
  DetailXeDichVuData dataDetail,
  CTDichVu dataDV,
) =>
    showModalSelectMulti(
      context,
      [
        getT(KeyT.nguoi_lam),
        getT(KeyT.cap_nhat_tien_do),
      ],
      [dataDetail.listNguoiThucHien ?? [], dataDetail.listTienDo ?? []],
      init: [dataDV.nguoiThucHien, dataDV.tienDo],
      (data) async {
        String idNTH = data?.first.first ?? dataDV.idNguoiThucHien ?? '';
        String idTD = data?.last.first ?? dataDV.idTienDo ?? '';

        final res = await blocLogin.postUpdateTDNTH(
          id: dataDV.idct ?? '',
          idNTH: idNTH,
          idTD: idTD,
        );

        if (res != '') {
          showToastM(context, title: res);
        } else {
          blocLogin.getDetailXeDichVu();
          Navigator.pop(context);
        }
      },
    );

Color getColor(String tienDo) {
  if (tienDo.length > 0) {
    int tienDoInt = int.tryParse(
          tienDo.substring(
            0,
            tienDo.length - 1,
          ),
        ) ??
        0;

    if (tienDoInt < 31) {
      return COLORS.RED;
    } else if (tienDoInt < 70) {
      return COLORS.ORANGE;
    } else {
      return COLORS.GREEN;
    }
  }

  return COLORS.RED;
}
