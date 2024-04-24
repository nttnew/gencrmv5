import 'package:flutter/material.dart';
import 'package:gen_crm/l10n/key_text.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/widgets/listview/list_load_infinity.dart';
import 'package:gen_crm/widgets/showToastM.dart';
import 'package:get/get.dart';
import '../../bloc/login/login_bloc.dart';
import '../../src/models/model_generator/bieu_mau_response.dart';
import '../../widgets/widget_appbar.dart';

class ListBieuMau extends StatefulWidget {
  const ListBieuMau({
    Key? key,
  }) : super(key: key);

  @override
  State<ListBieuMau> createState() => _ListBieuMauState();
}

class _ListBieuMauState extends State<ListBieuMau> {
  late final LoginBloc _loginBloc;
  final String idDetail = Get.arguments[0];

  @override
  void initState() {
    _loginBloc = LoginBloc.of(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          WidgetAppbar(
            title: getT(KeyT.bieu_mau),
            textColor: COLORS.BLACK,
            padding: 10,
            right: SizedBox(),
          ),
          Expanded(
            child: ViewLoadMoreBase(
              isInit: true,
              functionInit: (page, isInit) {
                return _loginBloc.getBieuMau();
              },
              itemWidget: (int index, data) {
                final BieuMauItemRes _item = data as BieuMauItemRes;
                return GestureDetector(
                  onTap: () async {
                    final res = await _loginBloc.getPdf(
                      idDetail: idDetail,
                      idBieuMau: _item.id ?? '',
                    );
                    if (res['mes'] == '' && res['html'] != null) {
                      AppNavigator.navigateInPhieu(
                        link: res['html'],
                      );
                    } else {
                      showToastM(
                        context,
                        title: res['mes'],
                      );
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    padding: EdgeInsets.all(
                      10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          4,
                        ),
                      ),
                      color: COLORS.WHITE,
                      boxShadow: boxShadow1,
                    ),
                    child: Text(
                      _item.tenBieuMau ?? '',
                      style: AppStyle.DEFAULT_16_BOLD,
                    ),
                  ),
                );
              },
              widgetLoad: widgetLoading(),
              controller: _loginBloc.loadMoreControllerBieuMau,
            ),
          ),
        ],
      ),
    );
  }
}

