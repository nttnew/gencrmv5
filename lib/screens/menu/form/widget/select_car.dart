import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../bloc/add_service_voucher/add_service_bloc.dart';
import '../../../../l10n/key_text.dart';
import '../../../../src/models/model_generator/list_car_response.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/widget_text.dart';

class SelectCar extends StatefulWidget {
  const SelectCar({Key? key}) : super(key: key);

  @override
  State<SelectCar> createState() => _SelectCarState();
}

class _SelectCarState extends State<SelectCar> {
  late final ServiceVoucherBloc _bloc;
  ScrollController _controller = ScrollController();

  void _scrollLate() {
    Timer(Duration(milliseconds: 200), () {
      _controller.animateTo(
        _controller
            .position.maxScrollExtent, // Vị trí đầu trang (điểm xuất phát)
        duration: Duration(milliseconds: 500), // Thời gian cuộn (milliseconds)
        curve: Curves.easeOut, // Loại hiệu ứng cuộn
      );
    });
  }

  @override
  void initState() {
    _bloc = ServiceVoucherBloc.of(context);
    _bloc.getVersionCarInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool isHang =
        _bloc.hangXe != '' && _bloc.hangXe != ServiceVoucherBloc.KHONG_XAC_DINH;
    final bool isDong =
        _bloc.dongXe != '' && _bloc.dongXe != ServiceVoucherBloc.KHONG_XAC_DINH;
    final bool isPhienBan = _bloc.phienBan != '' &&
        _bloc.phienBan != ServiceVoucherBloc.KHONG_XAC_DINH;
    return Container(
        height: MediaQuery.of(context).size.height * 0.9,
        padding: EdgeInsets.symmetric(vertical: 25, horizontal: 16),
        child: SingleChildScrollView(
          controller: _controller,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  WidgetText(
                    title: getT(KeyT.car_brand),
                    style: AppStyle.DEFAULT_16.copyWith(
                      color: HexColor('0079B5'),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  StreamBuilder<Set<HangXe>>(
                      stream: _bloc.listHangXe,
                      builder: (context, snapshot) {
                        final list = snapshot.data ?? {};
                        return Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: list
                              .map((e) => GestureDetector(
                                    onTap: () {
                                      _bloc.hangXe = e.name.toString();
                                      _bloc.dongXe = '';
                                      _bloc.phienBan = '';
                                      _bloc.namSanXuat = '';
                                      _bloc.canXe = '';
                                      _bloc.kieuDang = '';
                                      _bloc.soCho = '';
                                      _bloc.getDongXe(e.id.toString());
                                      _scrollLate();
                                      setState(() {});
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: _bloc.hangXe != e.name
                                              ? COLORS.WHITE
                                              : HexColor('0079B5')
                                                  .withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                            color: _bloc.hangXe != e.name
                                                ? Colors.grey
                                                : HexColor('0079B5'),
                                            width: 2,
                                          ),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        child: Text(e.name.toString())),
                                  ))
                              .toList(),
                        );
                      }),
                ],
              ),
              if (isHang)
                _baseSelect(
                    getT(KeyT.car_series), _bloc.dongXe, _bloc.listDongXe, (v) {
                  _bloc.dongXe = v;
                  _bloc.phienBan = '';
                  _bloc.namSanXuat = '';
                  _bloc.canXe = '';
                  _bloc.kieuDang = '';
                  _bloc.soCho = '';
                  _bloc.getPhienBan(v);
                  _scrollLate();
                  setState(() {});
                }),
              if (isHang && isDong)
                _baseSelect(
                    getT(KeyT.version), _bloc.phienBan, _bloc.listPhienBan,
                    (v) {
                  _bloc.phienBan = v;
                  _bloc.namSanXuat = '';
                  _bloc.canXe = '';
                  _bloc.kieuDang = '';
                  _bloc.soCho = '';
                  _bloc.getListNamSanXuat(v);
                  _bloc.getListKieuDang(v);
                  _bloc.getListCanXe(v);
                  _bloc.getListSoCho(v);
                  _scrollLate();
                  setState(() {});
                }),
              if (isHang && isDong && isPhienBan) ...[
                _baseSelect(getT(KeyT.year_of_manufacture), _bloc.namSanXuat,
                    _bloc.listNamSanXuat, (v) {
                  _bloc.namSanXuat = v;
                  setState(() {});
                }),
                _baseSelect(getT(KeyT.car_class), _bloc.canXe, _bloc.listCanXe,
                    (v) {
                  _bloc.canXe = v;
                  setState(() {});
                }),
                _baseSelect(
                    getT(KeyT.style), _bloc.kieuDang, _bloc.listKieuDang, (v) {
                  _bloc.kieuDang = v;
                  setState(() {});
                }),
                _baseSelect(
                    getT(KeyT.number_seats), _bloc.soCho, _bloc.listSoCho, (v) {
                  _bloc.soCho = v;
                  setState(() {});
                }),
              ],
              SizedBox(
                height: 32,
              ),
              Container(
                height: 37,
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _bloc.loaiXe.add('${_bloc.hangXe} '
                                  '${_bloc.dongXe == ServiceVoucherBloc.KHONG_XAC_DINH ? '' : _bloc.dongXe + ' '}'
                                  '${_bloc.phienBan == ServiceVoucherBloc.KHONG_XAC_DINH ? '' : _bloc.phienBan + ' '}'
                                  '${_bloc.namSanXuat == ServiceVoucherBloc.KHONG_XAC_DINH ? '' : _bloc.namSanXuat + ' '}'
                                  '${_bloc.kieuDang == ServiceVoucherBloc.KHONG_XAC_DINH ? '' : _bloc.kieuDang + ' '}'
                                  '${_bloc.soCho == ServiceVoucherBloc.KHONG_XAC_DINH ? '' : _bloc.soCho}'
                              .trim());
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: HexColor('c18300'),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(17))),
                          child: Center(
                            child: WidgetText(
                              title: getT(KeyT.select),
                              style: AppStyle.DEFAULT_16.copyWith(
                                  color: HexColor('130F26'),
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 22),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: HexColor('a6c1bc'),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(17))),
                          child: Center(
                            child: WidgetText(
                              title: getT(KeyT.close),
                              style: AppStyle.DEFAULT_16.copyWith(
                                  color: HexColor('130F26'),
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 32,
              )
            ],
          ),
        ));
  }

  Widget _baseSelect(String title, String select,
      BehaviorSubject<Set<String>> stream, Function(String) function) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 16,
        ),
        WidgetText(
          title: title,
          style: AppStyle.DEFAULT_16
              .copyWith(color: HexColor('0079B5'), fontWeight: FontWeight.w700),
        ),
        SizedBox(
          height: 16,
        ),
        StreamBuilder<Set<String>>(
            stream: stream,
            builder: (context, snapshot) {
              final list = snapshot.data ?? {};
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: list
                    .map((e) => GestureDetector(
                          onTap: () {
                            function(e);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: select != e
                                  ? COLORS.WHITE
                                  : HexColor('0079B5').withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: select != e
                                    ? Colors.grey
                                    : HexColor('0079B5'),
                                width: 2,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Text(e),
                          ),
                        ))
                    .toList(),
              );
            }),
      ],
    );
  }
}
