import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gen_crm/src/app_const.dart';
import 'package:get/get.dart';
import '../../../../api_resfull/dio_provider.dart';
import '../../../../bloc/add_service_voucher/add_service_bloc.dart';
import '../../../../l10n/key_text.dart';
import '../../../../models/model_item_add.dart';
import '../../../../src/models/model_generator/add_customer.dart';
import '../../../../src/src_index.dart';
import '../../../../storages/share_local.dart';
import '../../../../widgets/widget_text.dart';
import 'select_car.dart';
import 'package:flutter/foundation.dart' as Foundation;

class TypeCarBase extends StatefulWidget {
  const TypeCarBase({
    Key? key,
    required this.data,
    required this.bloc,
    required this.function,
    required this.addData,
  }) : super(key: key);
  final CustomerIndividualItemData data;
  final ServiceVoucherBloc bloc;
  final Function(String v) function;
  final List<ModelItemAdd> addData;
  @override
  State<TypeCarBase> createState() => _TypeCarBaseState();
}

class _TypeCarBaseState extends State<TypeCarBase> {
  String idDF = '';

  void getId() {
    final List<ModelItemAdd> dataSelect = widget.addData;
    dataSelect.forEach((element) {
      element.data.forEach((value) {
        if (value.label == widget.data.field_parent?.field_value) {
          if (value.value != null && value.value != '' && idDF != value.value)
            getDataApi(value.value.toString());
        }
      });
    });
  }

  Future<void> getDataApi(String id) async {
    idDF = id;
    try {
      var headers = {
        'Authorization': shareLocal.getString(PreferencesKey.TOKEN),
      };
      var dio = Dio();
      dio
        ..options.connectTimeout =
            Duration(milliseconds: BASE_URL.connectionTimeout).inMilliseconds
        ..options.receiveTimeout =
            Duration(milliseconds: BASE_URL.connectionTimeout).inMilliseconds;
      if (Foundation.kDebugMode) {
        dio.interceptors.add(dioLogger());
      }
      var response = await dio.request(
        '${widget.data.field_parent?.field_url}?${widget.data.field_parent?.field_keyparam}=$id',
        options: Options(
          method: 'GET',
          headers: headers,
        ),
      );

      if (response.statusCode == 200) {
        if (response.data['data'] != null) {
          widget.bloc.loaiXe.add(response.data['data']);
        }
      }
    } catch (e) {
      throw e;
    }
  }

  @override
  void initState() {
    if (widget.data.field_set_value != '' &&
        widget.data.field_set_value != null) {
      widget.bloc.loaiXe.add(widget.data.field_set_value);
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TypeCarBase oldWidget) {
    if (widget.data.field_parent != null) getId();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            textScaleFactor: MediaQuery.of(Get.context!).textScaleFactor,
            text: TextSpan(
              text: widget.data.field_label ?? '',
              style: AppStyle.DEFAULT_14W600,
              children: <TextSpan>[
                widget.data.field_require == 1
                    ? TextSpan(
                        text: '*',
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: COLORS.RED,
                        ),
                      )
                    : TextSpan(),
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          GestureDetector(
            onTap: () {
              showBottomGenCRM(
                isDismissible: false,
                enableDrag: false,
                child: SelectCar(),
              );
            },
            child: StreamBuilder<String>(
                stream: widget.bloc.loaiXe,
                builder: (context, snapshot) {
                  if (widget.bloc.loaiXe.value.trim() != '') {
                    widget.function(widget.bloc.loaiXe.value);
                  }
                  return Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: COLORS.WHITE,
                      borderRadius: BorderRadius.circular(
                        5,
                      ),
                      border: Border.all(
                        color: COLORS.ffBEB4B4,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 10,
                        top: 16,
                        bottom: 16,
                      ),
                      child: Container(
                        child: WidgetText(
                          title: (widget.bloc.loaiXe.value != ''
                              ? widget.bloc.loaiXe.value
                              : '---${getT(KeyT.select)}---'),
                          style: AppStyle.DEFAULT_14_BOLD,
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
