import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:gen_crm/screens/main/widget/item_car.dart';
import 'package:gen_crm/src/models/model_generator/report_option.dart';
import 'package:gen_crm/storages/share_local.dart';
import '../../bloc/login/login_bloc.dart';
import '../../models/button_menu_model.dart';
import '../../src/models/model_generator/xe_dich_vu_response.dart';
import '../../src/src_index.dart';
import '../../widgets/listview/list_load_infinity.dart';

class MainCar extends StatefulWidget {
  const MainCar({
    Key? key,
    required this.listMenu,
  }) : super(key: key);
  final List<ButtonMenuModel> listMenu;
  @override
  State<MainCar> createState() => _MainCarState();
}

class _MainCarState extends State<MainCar> {
  late String? lang;
  late final LoginBloc _blocLogin;

  @override
  void initState() {
    lang = shareLocal.getString(PreferencesKey.LANGUAGE_NAME);
    _blocLogin = LoginBloc.of(context);
    _blocLogin.locationStatusStream.listen((value) {
      final listTrangThai = value.data?.trangthaihd ?? [];
      if (_blocLogin.valueTrangThai == null && listTrangThai.length > 0) {
        _blocLogin.valueTrangThai = listTrangThai.firstOrNull;
        _blocLogin.initData();
      }
    });
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MainCar oldWidget) {
    final langNew = shareLocal.getString(PreferencesKey.LANGUAGE_NAME);
    if (lang != langNew) {
      lang = langNew;
      _blocLogin.getChiNhanh();
      _blocLogin.loadMoreControllerCar.reloadData();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    double _wSz = MediaQuery.of(context).size.width;
    double w = _wSz / 5;
    return Expanded(
      child: ViewLoadMoreBase(
        isShowAll: _blocLogin.isShowLocaiton,
        isDispose: false,
        heightAppBar: w + 104 - MediaQuery.of(context).padding.top,
        child: Container(
          child: SingleChildScrollView(
            padding: EdgeInsets.zero,
            child: StreamBuilder<FilterResponse>(
                stream: _blocLogin.locationStatusStream,
                builder: (context, snapshot) {
                  final listLocation = snapshot.data?.data?.diem_ban ?? [];
                  final listTrangThai = snapshot.data?.data?.trangthaihd ?? [];
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.listMenu.length > 0)
                        Container(
                          decoration: BoxDecoration(
                            color: COLORS.PRIMARY_COLOR1,
                            // gradient: linearGradientMain,
                          ),
                          child: Stack(
                            children: [
                              Container(
                                height: w + 16,
                                decoration: BoxDecoration(
                                  color: COLORS.WHITE,
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(6),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: w,
                                  width: _wSz,
                                  child: Scrollbar(
                                    thumbVisibility: true,
                                    trackVisibility: true,
                                    child: ListView.builder(
                                      padding: EdgeInsets.only(
                                        left: 12,
                                      ),
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: widget.listMenu.length,
                                      itemBuilder: (context, i) {
                                        final item = widget.listMenu[i];
                                        return Container(
                                          width: w,
                                          height: w,
                                          margin: EdgeInsets.only(
                                            top: 12,
                                            right: 12,
                                            bottom: 10,
                                          ),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              padding: EdgeInsets.zero,
                                                backgroundColor:
                                                COLORS.PRIMARY_COLOR1,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.all(
                                                    Radius.circular(
                                                      10,
                                                    ),
                                                  ),
                                                )),
                                            onPressed: () {
                                              item.onTap();
                                            },
                                            child: Text(
                                              item.title,
                                              style:
                                              AppStyle.DEFAULT_14.copyWith(
                                                color: COLORS.WHITE,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                              maxLines: 3,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      AppValue.vSpaceTiny,
                      Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                            padding: EdgeInsets.only(
                              left: 16,
                              bottom: 5,
                            ),
                            scrollDirection: Axis.horizontal,
                            itemCount: listTrangThai.length,
                            itemBuilder: (context, i) {
                              final itemData = listTrangThai[i];
                              bool isSelected =
                                  _blocLogin.valueTrangThai?.id == itemData.id;
                              return GestureDetector(
                                onTap: () {
                                  _blocLogin.valueTrangThai =
                                      isSelected ? null : itemData;
                                  _blocLogin.loadMoreControllerCar.reloadData();

                                  setState(() {});
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                    right: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    border: isSelected
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
                                    style: AppStyle.DEFAULT_14.copyWith(
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                      if (listLocation.length > 1)
                        Container(
                          height: 30,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          margin: EdgeInsets.only(
                            bottom: 10,
                          ),
                          child: DropdownButton2(
                              value: _blocLogin.valueLocation ??
                                  listLocation.first[1],
                              icon: SizedBox.shrink(),
                              // isDense: true,
                              underline: SizedBox.shrink(),
                              dropdownMaxHeight: 300,
                              onChanged: (String? value) {
                                _blocLogin.valueLocation = value ?? '';
                                _blocLogin.loadMoreControllerCar.reloadData();
                                setState(() {});
                              },
                              selectedItemBuilder: (context) => listLocation
                                  .map(
                                    (items) => DropdownMenuItem<String>(
                                      onTap: () {
                                        _blocLogin.location = items.first;
                                      },
                                      value: items[1],
                                      child: RichText(
                                        maxLines: 1,
                                        textScaleFactor: MediaQuery.of(context)
                                            .textScaleFactor,
                                        overflow: TextOverflow.ellipsis,
                                        text: TextSpan(
                                          children: [
                                            WidgetSpan(
                                              alignment:
                                                  PlaceholderAlignment.bottom,
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                  right: 8,
                                                  bottom: 3,
                                                ),
                                                child: Image.asset(
                                                  ICONS.IC_DROP_DOWN_PNG,
                                                  height: 10,
                                                  width: 10,
                                                ),
                                              ),
                                            ),
                                            TextSpan(
                                              text: items[1],
                                              style: AppStyle.DEFAULT_14_BOLD,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              items: listLocation
                                  .map(
                                    (items) => DropdownMenuItem<String>(
                                      onTap: () {
                                        _blocLogin.location = items.first;
                                      },
                                      value: items[1],
                                      child: Text(
                                        items[1],
                                        style: AppStyle.DEFAULT_14_BOLD,
                                      ),
                                    ),
                                  )
                                  .toList()),
                        ),
                    ],
                  );
                }),
          ),
        ),
        functionInit: (page, isInit) {
          return _blocLogin.getXeDichVu(
            page: page,
          );
        },
        itemWidget: (int index, data) {
          XeDichVu _item = data as XeDichVu;
          return ItemCar(
            data: _item,
            onTap: () {
              AppNavigator.navigateDetailCarMain(_item.id ?? '');
            },
          );
        },
        controller: _blocLogin.loadMoreControllerCar,
      ),
    );
  }

  // static List<Color> generateColors({
  //   Color? startColorD,
  //   Color? endColorD,
  // }) {
  //   int count = 8;
  //   List<Color> colors = [];
  //   Color startColor = startColorD ?? COLORS.PRIMARY_COLOR1;
  //   Color endColor = endColorD ?? COLORS.PRIMARY_COLOR1;
  //   colors.add(startColor);
  //   // Tính toán giá trị màu cho từng thành phần màu (red, green, blue)
  //   double startRed = startColor.red.toDouble();
  //   double startGreen = startColor.green.toDouble();
  //   double startBlue = startColor.blue.toDouble();
  //
  //   double endRed = endColor.red.toDouble();
  //   double endGreen = endColor.green.toDouble();
  //   double endBlue = endColor.blue.toDouble();
  //
  //   // Tạo các màu ở giữa
  //   for (int i = 1; i <= count; i++) {
  //     double red = startRed + ((endRed - startRed) / (count + 1)) * i;
  //     double green = startGreen + ((endGreen - startGreen) / (count + 1)) * i;
  //     double blue = startBlue + ((endBlue - startBlue) / (count + 1)) * i;
  //
  //     colors.add(Color.fromARGB(255, red.toInt(), green.toInt(), blue.toInt()));
  //   }
  //   return colors;
  // }
}
