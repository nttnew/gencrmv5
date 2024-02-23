import 'package:flutter/material.dart';
import 'package:gen_crm/src/models/model_generator/xe_dich_vu_response.dart';
import 'package:gen_crm/widgets/btn_thao_tac.dart';
import 'package:gen_crm/widgets/showToastM.dart';
import '../../bloc/login/login_bloc.dart';
import '../../l10n/key_text.dart';
import '../../src/app_const.dart';
import '../../src/models/model_generator/detail_xe_dich_vu.dart';
import '../../src/src_index.dart';
import '../../widgets/cupertino_loading.dart';
import '../../widgets/dialog_call.dart';
import '../../widgets/widget_text.dart';

showDetailCar(
  BuildContext context,
  XeDichVu xeDichVu,
) {
  return showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(30),
        topLeft: Radius.circular(30),
      ),
    ),
    backgroundColor: COLORS.WHITE,
    builder: (context) => DetailCar(
      xeDichVu: xeDichVu,
    ),
  );
}

class DetailCar extends StatefulWidget {
  const DetailCar({
    Key? key,
    required this.xeDichVu,
  }) : super(key: key);
  final XeDichVu xeDichVu;
  @override
  State<DetailCar> createState() => _DetailCarState();
}

class _DetailCarState extends State<DetailCar> {
  late final LoginBloc _blocLogin;
  @override
  void initState() {
    _blocLogin = LoginBloc(
      userRepository: LoginBloc.of(context).userRepository,
      localRepository: LoginBloc.of(context).localRepository,
    );
    _blocLogin.xeDichVu = widget.xeDichVu;
    _blocLogin.getDetailXeDichVu();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      width: double.infinity,
      margin: EdgeInsets.only(
        bottom: 16,
      ),
      padding: EdgeInsets.only(top: 32),
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
              final List<CTDichVu> listNhanCong = dataDetail.listNhanCong ?? [];
              final List<CTDichVu> listSP = dataDetail.listPhuTung ?? [];
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
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
                                        title: _blocLogin.xeDichVu?.bienSo ??
                                            getT(KeyT.not_yet),
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
                                        title: _blocLogin.xeDichVu?.chiNhanh ??
                                            getT(KeyT.not_yet),
                                        style: AppStyle.DEFAULT_14.copyWith(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                itemTextIcon(
                                  text: _blocLogin.xeDichVu?.tenKhachHang ?? '',
                                  icon: ICONS.IC_USER2_SVG,
                                  colorIcon: COLORS.GREY,
                                ),
                                itemTextIcon(
                                  onTap: () {
                                    if (_blocLogin.xeDichVu?.diDong != null &&
                                        _blocLogin.xeDichVu?.diDong != '') {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
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
                                  styleText: AppStyle.DEFAULT_14.copyWith(
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
                                  styleText: AppStyle.DEFAULT_14.copyWith(
                                    color: COLORS.ORANGE,
                                  ),
                                ),
                                itemTextIcon(
                                  textPlus: getT(KeyT.ngay_vao),
                                  text: _blocLogin.xeDichVu?.ngayVao ?? '',
                                  icon: ICONS.IC_CALENDAR_PNG,
                                  isSVG: false,
                                  colorIcon: COLORS.GREY,
                                ),
                                itemTextIcon(
                                  textPlus: getT(KeyT.ngay_ra),
                                  text: _blocLogin.xeDichVu?.ngayRa ?? '',
                                  icon: ICONS.IC_CALENDAR_PNG,
                                  isSVG: false,
                                  colorIcon: COLORS.GREY,
                                ),
                                itemTextIcon(
                                  styleText: AppStyle.DEFAULT_14.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: COLORS.TEXT_BLUE_BOLD,
                                  ),
                                  textPlus: getT(KeyT.so_phieu),
                                  text: _blocLogin.xeDichVu?.soPhieu ?? '',
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
                                return itemDichVu(
                                  context,
                                  listNhanCong[i],
                                  dataDetail,
                                  _blocLogin,
                                );
                              }),
                          if (listSP.length > 0)
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
                        ],
                      ),
                    ),
                  ),
                  AppValue.vSpaceSmall,
                  Row(
                    children: [
                      AppValue.hSpaceSmall,
                      Expanded(
                        child: ButtonBaseSmall(
                            title: ModuleMy.getNameModuleMy(
                              ModuleMy.HOP_DONG,
                              isTitle: true,
                            ),
                            onTap: () {
                              AppNavigator.navigateAddContract(
                                title: ModuleMy.getNameModuleMy(
                                  ModuleMy.HOP_DONG,
                                  isTitle: true,
                                ),
                              );
                            }),
                      ),
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
                                  widget.xeDichVu.trangThai,
                              (data) async {
                                final res = await _blocLogin.postUpdateTTHD(
                                    id: widget.xeDichVu.id ?? '',
                                    idTT: '${data?.first}');

                                if (res != '') {
                                  showToastM(context, title: res);
                                } else {
                                  _blocLogin.trangThaiDichVu = data?.last;
                                  setState(() {});
                                  Navigator.of(context).pop();
                                }
                              },
                            );
                          },
                        ),
                      ),
                      AppValue.hSpaceSmall,
                    ],
                  ),
                ],
              );
            }
          }),
    );
  }
}

itemDichVu(
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
            showModalSelect(
              context,
              getT(KeyT.nguoi_lam),
              dataDetail.listNguoiThucHien ?? [],
              init: dataDV.nguoiThucHien,
              (data) async {
                final res = await blocLogin.postUpdateTDNTH(
                  id: dataDV.idct ?? '',
                  idTD: dataDV.idTienDo ?? '',
                  idNTH: '${data?.first}',
                );

                if (res != '') {
                  showToastM(context, title: res);
                } else {
                  blocLogin.getDetailXeDichVu();
                  Navigator.pop(context);
                }
              },
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
            showModalSelect(
              context,
              getT(KeyT.cap_nhat_tien_do),
              dataDetail.listTienDo ?? [],
              init: dataDV.tienDo,
              (data) async {
                final res = await blocLogin.postUpdateTDNTH(
                  id: dataDV.idct ?? '',
                  idNTH: dataDV.idNguoiThucHien ?? '',
                  idTD: '${data?.first}',
                );

                if (res != '') {
                  showToastM(context, title: res);
                } else {
                  blocLogin.getDetailXeDichVu();
                  Navigator.pop(context);
                }
              },
            );
          },
          contentNull: getT(KeyT.chua_bat_dau),
          color: getColor(dataDV.tienDo ?? ''),
        ),
      ],
    ),
  );
}

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

showModalSelect(
  BuildContext context,
  String title,
  List<List<dynamic>> listData,
  Function(List<dynamic>?) onTap, {
  String? init,
}) {
  return showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(30),
        topLeft: Radius.circular(30),
      ),
    ),
    backgroundColor: COLORS.WHITE,
    builder: (context) => SelectBody(
      init: init,
      title: title,
      listData: listData,
      onTap: onTap,
    ),
  );
}

class SelectBody extends StatefulWidget {
  const SelectBody({
    Key? key,
    required this.init,
    required this.title,
    required this.listData,
    required this.onTap,
  }) : super(key: key);
  final String? init;
  final String title;
  final List<List<dynamic>> listData;
  final Function(List<dynamic>?) onTap;

  @override
  State<SelectBody> createState() => _SelectBodyState();
}

class _SelectBodyState extends State<SelectBody> {
  List<dynamic>? dataSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 4),
      padding: EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.title,
            style: AppStyle.DEFAULT_18_BOLD.copyWith(
              color: COLORS.TEXT_BLUE_BOLD,
            ),
          ),
          AppValue.vSpace24,
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: widget.listData.asMap().entries.map((entry) {
              final e = entry.value;
              return GestureDetector(
                onTap: () {
                  widget.onTap(e);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: widget.init == e[1]
                        ? COLORS.ORANGE.withOpacity(0.5)
                        : COLORS.LIGHT_GREY,
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        12,
                      ),
                    ),
                  ),
                  child: Text(
                    e[1],
                    style: AppStyle.DEFAULT_16_T,
                  ),
                ),
              );
            }).toList(),
          ),
          AppValue.vSpaceMedium,
        ],
      ),
    );
  }
}

class ItemSanPham extends StatelessWidget {
  const ItemSanPham({
    Key? key,
    required this.dataDV,
  }) : super(key: key);
  final CTDichVu dataDV;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 16,
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            margin: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: COLORS.GREY,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              dataDV.tenSanPham ?? '',
              style: AppStyle.DEFAULT_14_BOLD,
            ),
          ),
          Expanded(
            child: Text(
              '${dataDV.soLuong} ${dataDV.donViTinh}',
              style: AppStyle.DEFAULT_14_BOLD,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
