import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gen_crm/widgets/loading_api.dart';
import '../../../../l10n/key_text.dart';
import '../../../../src/app_const.dart';
import '../../../../src/models/model_generator/add_customer.dart';
import '../../../../src/src_index.dart';
import '../../../api_resfull/dio_provider.dart';
import '../../../widgets/btn_thao_tac.dart';
import '../../widget/widget_label.dart';

class FieldText extends StatefulWidget {
  const FieldText({
    Key? key,
    required this.data,
    required this.onChange,
    this.init,
    this.soTien,
    this.isNoneEdit = false,
  }) : super(key: key);
  final CustomerIndividualItemData data;
  final Function(String, Map<String, dynamic>?) onChange;
  final String? init;
  final double? soTien;
  final bool isNoneEdit;

  @override
  State<FieldText> createState() => _FieldTextState();
}

class _FieldTextState extends State<FieldText> {
  late final CustomerIndividualItemData data;
  TextEditingController _textEditingController = TextEditingController();

  void initState() {
    super.initState();

    // Lấy dữ liệu từ widget
    data = widget.data;

    // Lắng nghe thay đổi từ TextEditingController
    _textEditingController.addListener(_handleTextChanged);

    // Đặt giá trị ban đầu cho TextEditingController nếu có
    _initializeTextController();
  }

  void _handleTextChanged() {
    // Xử lý thay đổi khi người dùng nhập vào TextEditingController
    final String newText =
        data.field_type == 'MONEY' || data.field_type == 'TEXT_NUMERIC'
            ? _textEditingController.text.replaceAll('.', '')
            : _textEditingController.text;

    // Gọi hàm onChange từ widget
    widget.onChange(newText, null);
  }

  void _initializeTextController() {
    // Kiểm tra giá trị khởi tạo hoặc giá trị được set trước đó
    final bool hasInitialValue = widget.data.field_set_value != null &&
        widget.data.field_set_value != '';
    final bool hasInit = widget.init != null;

    if (hasInitialValue || hasInit) {
      if (data.field_type == 'MONEY' || data.field_type == 'TEXT_NUMERIC') {
        if (widget.init != null && widget.init?.trim() != '') {
          _textEditingController.text = AppValue.formatMoney(
            widget.init!.replaceAll('.', ''),
            isD: false,
          );
        } else {
          _textEditingController.text = AppValue.formatMoney(
            widget.data.field_set_value.replaceAll('.', ''),
            isD: false,
          );
        }
      } else {
        // Đặt giá trị khởi tạo cho các loại khác
        _textEditingController.text =
            widget.init ?? widget.data.field_set_value;
      }
    }
  }

  @override
  void didUpdateWidget(covariant FieldText oldWidget) {
    _initializeTextController();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  Future<void> getDataApi() async {
    Loading().showLoading();
    final ApiModel _dataApi = widget.data.api!;
    final String param = jsonEncode(_dataApi.params)
        .toString()
        .replaceAll('{value}', _textEditingController.text);
    try {
      var dio = DioProvider.dio;
      var response = await dio.request(
        _dataApi.link!,
        options: Options(
          method: 'POST',
        ),
        data: param,
      );
      Loading().popLoading();
      if (response.statusCode == 200) {
        if (response.data['code'] == 200) {
          if (response.data['data'] != null) {
            final res = response.data['data'] as Map<String, dynamic>;
            widget.onChange(_textEditingController.text, res);
          }
        } else {
          ShowDialogCustom.showDialogBase(
            title: getT(KeyT.notification),
            content: response.data['msg'].toString(),
          );
        }
      }
    } catch (e) {
      Loading().popLoading();
      ShowDialogCustom.showDialogBase(
        title: getT(KeyT.notification),
        content: getT(KeyT.an_error_occurred),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isReadOnly = data.field_special == 'none-edit' ||
        data.field_read_only.toString() == '1' ||
        widget.isNoneEdit;
    return Container(
      margin: marginBottomFrom,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: TextFormField(
              enabled: !isReadOnly,
              inputFormatters: data.field_type == 'MONEY' ||
                      data.field_type == 'TEXT_NUMERIC'
                  ? AppStyle.inputPrice
                  : null,
              controller: _textEditingController,
              minLines: data.field_type == 'TEXTAREA' ? 2 : 1,
              maxLines: data.field_type == 'TEXTAREA' ? 6 : 1,
              style: AppStyle.DEFAULT_14_BOLD.copyWith(
                color: isReadOnly ? COLORS.GREY : null,
              ),
              keyboardType: data.field_type == 'MONEY' ||
                      data.field_special == 'numeric' ||
                      data.field_type == 'TEXT_NUMERIC'
                  ? TextInputType.number
                  : data.field_special == 'default'
                      ? TextInputType.text
                      : data.field_special == 'email-address'
                          ? TextInputType.emailAddress
                          : isReadOnly
                              ? TextInputType.none
                              : TextInputType.text,
              decoration: InputDecoration(
                  contentPadding: paddingBaseForm,
                  label: WidgetLabel(data),
                  counterText: '',
                  counterStyle: TextStyle(fontSize: 0),
                  hintStyle: hintTextStyle,
                  border: OutlineInputBorder(),
                  isDense: true,
                  hintText: getT(KeyT.enter) +
                      ' ' +
                      (data.field_label ?? '').toLowerCase(),
                  suffixIconConstraints:
                      data.api != null ? BoxConstraints() : null,
                  suffixIcon: data.api != null
                      ? ButtonCheck(
                          onTap: () {
                            getDataApi();
                          },
                          textEditingController: _textEditingController,
                        )
                      : null),
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          if (data.field_name == hdSoTien && widget.soTien != null) ...[
            SizedBox(
              height: 4,
            ),
            RichText(
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              text: TextSpan(
                text: '${getT(KeyT.unpaid)}:',
                style: AppStyle.DEFAULT_14W600.copyWith(
                  fontSize: 12,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text:
                        ' ${AppValue.formatMoney(widget.soTien?.toStringAsFixed(
                              0,
                            ) ?? '')}',
                    style: AppStyle.DEFAULT_14W600.copyWith(
                      fontSize: 12,
                      color: COLORS.TEXT_COLOR,
                    ),
                  ),
                ],
              ),
            ),
          ]
        ],
      ),
    );
  }
}

class ButtonCheck extends StatefulWidget {
  const ButtonCheck({
    Key? key,
    required this.textEditingController,
    required this.onTap,
  }) : super(key: key);
  final TextEditingController textEditingController;
  final Function onTap;

  @override
  State<ButtonCheck> createState() => _ButtonCheckState();
}

class _ButtonCheckState extends State<ButtonCheck> {
  @override
  void initState() {
    widget.textEditingController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.textEditingController.text.trim() != ''
        ? Container(
            margin: EdgeInsets.symmetric(
              horizontal: 8,
            ),
            child: ButtonSmall(
              onTap: () {
                widget.onTap();
              },
              borderRadius: 4,
              isWrap: true,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                child: Text(
                  getT(KeyT.check),
                  style: AppStyle.DEFAULT_14.copyWith(
                    fontSize: 10,
                    color: COLORS.WHITE,
                  ),
                ),
              ),
              backGround: COLORS.ORANGE_IMAGE,
            ),
          )
        : SizedBox.shrink();
  }
}
