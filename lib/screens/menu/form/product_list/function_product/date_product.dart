import 'package:flutter/material.dart';
import '../../../../../l10n/l10n.dart';
import '../../../../../src/models/model_generator/products_response.dart';
import '../../../../../src/src_index.dart';
import '../../../../../storages/share_local.dart';
import '../../../../../widgets/date_time_picker/flutter_datetime_picker.dart';
import '../../../../../widgets/date_time_picker/src/i18n_model.dart';

class DateProduct extends StatefulWidget {
  DateProduct({
    Key? key,
    required this.formProduct,
    required this.onSelect,
    this.isDate = true,
  }) : super(key: key);

  final FormProduct formProduct;
  final Function(int dateTime) onSelect;
  final bool isDate;

  @override
  State<DateProduct> createState() => _DateProductState();
}

class _DateProductState extends State<DateProduct> {
  String dateText = '';

  @override
  void initState() {
    if (widget.formProduct.fieldSetValue != null &&
        widget.formProduct.fieldSetValue != '' &&
        widget.formProduct.fieldSetValue != 0) {
      dateText = widget.isDate
          ? AppValue.formatIntDate(widget.formProduct.fieldSetValue)
          : AppValue.formatIntDateTime(widget.formProduct.fieldSetValue);
    }
    super.initState();
  }

  LocaleType _checkLocaleType() {
    final lang = shareLocal.getString(PreferencesKey.LANGUAGE_NAME) ?? L10n.VN;
    switch (lang) {
      case L10n.VN:
        return LocaleType.vi;
      case L10n.MY:
        return LocaleType.my;
      case L10n.JA:
        return LocaleType.jp;
      case L10n.ZH:
        return LocaleType.zh;
      case L10n.KO:
        return LocaleType.ko;
      case L10n.EN:
        return LocaleType.en;
      default:
        return LocaleType.vi;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: EdgeInsets.symmetric(
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        color: COLORS.WHITE,
        borderRadius: BorderRadius.all(
          Radius.circular(
            4,
          ),
        ),
        border: Border.all(
          color: COLORS.BLUE,
        ),
      ),
      child: GestureDetector(
        onTap: () {
          widget.isDate
              ? DatePicker.showDatePicker(
                  context,
                  showTitleActions: true,
                  onConfirm: (DateTime date) {
                    setState(() {
                      dateText = AppValue.formatDate(date.toString());
                    });
                    int time = date.millisecondsSinceEpoch ~/ 1000;
                    widget.onSelect(time);
                  },
                  currentTime: DateTime.now(),
                  locale: _checkLocaleType(),
                )
              : DatePicker.showDateTimePicker(
                  context,
                  showTitleActions: true,
                  onConfirm: (DateTime date) {
                    setState(() {
                      dateText = AppValue.formatStringDateTime(date.toString());
                    });
                    int time = date.millisecondsSinceEpoch ~/ 1000;
                    widget.onSelect(time);
                  },
                  currentTime: DateTime.now(),
                  locale: _checkLocaleType(),
                );
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              (widget.formProduct.fieldLabel ?? '') +
                  '${dateText != '' ? ': $dateText' : ''}',
              style: AppStyle.DEFAULT_14_BOLD,
            ),
            AppValue.hSpaceTiny,
            WidgetContainerImage(
              image: ICONS.IC_DATE_PNG,
              width: 20,
              height: 20,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}
