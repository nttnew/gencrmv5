import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:gen_crm/screens/main/show_detail_car.dart';
import 'package:gen_crm/screens/main/widget/item_car.dart';
import 'package:gen_crm/src/models/model_generator/report_option.dart';
import '../../bloc/login/login_bloc.dart';
import '../../l10n/key_text.dart';
import '../../src/src_index.dart';
import '../../storages/share_local.dart';
import '../../widgets/listview/list_load_infinity.dart';

class MainCar extends StatefulWidget {
  const MainCar({Key? key}) : super(key: key);

  @override
  State<MainCar> createState() => _MainCarState();
}

class _MainCarState extends State<MainCar> {
  @override
  void initState() {
    LoginBloc _blocLogin = LoginBloc.of(context);
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
            isInit: isInit,
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
