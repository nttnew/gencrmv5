import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as Foundation;
import '../../../../api_resfull/dio_provider.dart';
import '../../../../l10n/key_text.dart';
import '../../../../models/model_item_add.dart';
import '../../../../src/base.dart';
import '../../../../src/models/model_generator/add_customer.dart';
import '../../../../src/preferences_key.dart';
import '../../../../src/styles.dart';
import '../../../../storages/share_local.dart';
import '../../widget/widget_label.dart';

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
  late final CustomerIndividualItemData _data;
  TextEditingController _textEditingController = TextEditingController();
  String _idDF = '';
  bool _isDisable = false;

  void getId() {
    final List<ModelItemAdd> dataSelect = widget.addData;
    dataSelect.forEach((element) {
      element.data.forEach((value) {
        if (value.label == widget.data.field_parent?.field_value) {
          if (value.value != null &&
              value.value != '' &&
              _idDF != value.value) {
            getDataApi(value.value.toString());
            return;
          } else if (value.value == '' && _isDisable) {
            // case carpa 12/7
            _isDisable = false;
            _textEditingController.text = '';
            _idDF = '';
            return;
          }
        }
      });
    });
  }

  Future<void> getDataApi(String id) async {
    _idDF = id;
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
          _isDisable = response.data['isDisable'] ?? false;
          _textEditingController.text = response.data['data'] ?? '';
          if (_isDisable) {
            // trong case carpa
            setState(() {});
          }
        }
      }
    } catch (e) {
      throw e;
    }
  }

  @override
  void initState() {
    _data = widget.data;
    _textEditingController.addListener(() {
      widget.onChange(
          _data.field_type == 'MONEY' || _data.field_type == 'TEXT_NUMERIC'
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
    final isReadOnly = _data.field_special == 'none-edit' ||
        _data.field_read_only == '1' ||
        _isDisable;
    return Container(
      margin: marginBottomFrom,
      child: TextFormField(
        enabled: !isReadOnly,
        inputFormatters:
            _data.field_type == 'MONEY' || _data.field_type == 'TEXT_NUMERIC'
                ? AppStyle.inputPrice
                : null,
        controller: _textEditingController,
        minLines: _data.field_type == 'TEXTAREA' ? 2 : 1,
        maxLines: _data.field_type == 'TEXTAREA' ? 6 : 1,
        style: AppStyle.DEFAULT_14_BOLD,
        keyboardType: widget.typeInput ??
            (_data.field_special == 'numeric' ||
                    _data.field_type == 'MONEY' ||
                    _data.field_type == 'TEXT_NUMERIC'
                ? TextInputType.number
                : _data.field_special == 'default'
                    ? TextInputType.text
                    : _data.field_special == 'email-address'
                        ? TextInputType.emailAddress
                        : isReadOnly
                            ? TextInputType.none
                            : TextInputType.text),
        decoration: InputDecoration(
          contentPadding: paddingBaseForm,
          label: WidgetLabel(_data),
          counterText: '',
          counterStyle: TextStyle(fontSize: 0),
          hintStyle: hintTextStyle,
          hintText: getT(KeyT.enter) + ' ' + (_data.field_label ?? '').toLowerCase(),
          border: OutlineInputBorder(),
          isDense: true,
        ),
        textCapitalization: TextCapitalization.sentences,
      ),
    );
  }
}
