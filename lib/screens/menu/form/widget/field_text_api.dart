import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' as Foundation;
import '../../../../api_resfull/dio_provider.dart';
import '../../../../models/model_item_add.dart';
import '../../../../src/base.dart';
import '../../../../src/color.dart';
import '../../../../src/models/model_generator/add_customer.dart';
import '../../../../src/preferences_key.dart';
import '../../../../src/styles.dart';
import '../../../../storages/share_local.dart';

class FieldTextAPi extends StatefulWidget {
  const FieldTextAPi({
    Key? key,
    required this.data,
    required this.onChange,
    required this.addData,
    this.typeInput,
  }) : super(key: key);
  final CustomerIndividualItemData data;
  final Function(String) onChange;
  final List<ModelItemAdd> addData;
  final TextInputType? typeInput;

  @override
  State<FieldTextAPi> createState() => _FieldTextAPiState();
}

class _FieldTextAPiState extends State<FieldTextAPi> {
  late final CustomerIndividualItemData data;
  TextEditingController _textEditingController = TextEditingController();
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
          _textEditingController.text = response.data['data'] ?? '';
        }
      }
    } catch (e) {
      throw e;
    }
  }

  @override
  void initState() {
    data = widget.data;
    _textEditingController.addListener(() {
      widget.onChange(data.field_type == 'MONEY'
          ? _textEditingController.text.replaceAll('.', '')
          : _textEditingController.text);
    });
    if (widget.data.field_set_value != null &&
        widget.data.field_set_value != '')
      _textEditingController.text = widget.data.field_set_value;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant FieldTextAPi oldWidget) {
    if (widget.data.field_parent != null) getId();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isReadOnly =
        data.field_special == 'none-edit' || data.field_read_only == '1';
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            textScaleFactor: MediaQuery.of(Get.context!).textScaleFactor,
            text: TextSpan(
              text: data.field_label ?? '',
              style: AppStyle.DEFAULT_14W600,
              children: <TextSpan>[
                data.field_require == 1
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
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: isReadOnly ? COLORS.LIGHT_GREY : COLORS.WHITE,
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
                child: TextFormField(
                  inputFormatters:
                      data.field_type == 'MONEY' ? AppStyle.inputPrice : null,
                  controller: _textEditingController,
                  minLines: data.field_type == 'TEXTAREA' ? 2 : 1,
                  maxLines: data.field_type == 'TEXTAREA' ? 6 : 1,
                  style: AppStyle.DEFAULT_14_BOLD,
                  keyboardType: widget.typeInput ??
                      (data.field_special == 'numberic' ||
                              data.field_type == 'MONEY'
                          ? TextInputType.number
                          : data.field_special == 'default'
                              ? TextInputType.text
                              : data.field_special == 'email-address'
                                  ? TextInputType.emailAddress
                                  : isReadOnly
                                      ? TextInputType.none
                                      : TextInputType.text),
                  decoration: InputDecoration(
                    hintStyle: AppStyle.DEFAULT_14W500,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    isDense: true,
                  ),
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
