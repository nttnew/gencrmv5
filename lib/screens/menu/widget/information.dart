import 'package:flutter/material.dart';
import 'package:gen_crm/src/models/model_generator/work.dart';
import '../../../l10n/key_text.dart';
import '../../../src/app_const.dart';
import '../../../src/models/model_generator/detail_customer.dart';
import '../../../src/src_index.dart';
import '../../../widgets/line_horizontal_widget.dart';
import '../../../widgets/widget_text.dart';

class InfoBase extends StatelessWidget {
  const InfoBase({
    Key? key,
    required this.listData,
    this.isLine = true,
    this.checkIn,
    this.checkOut,
  }) : super(key: key);
  final List<InfoDataModel> listData;
  final bool isLine;
  final CheckInLocation? checkIn, checkOut;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ...List.generate(
        listData.length,
        (index) => Column(
          children: [
            ItemInfo(
              data: listData[index],
            ),
            if (isLine)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: LineHorizontal(),
              ),
          ],
        ),
      ),
      _itemLocation(checkIn, true),
      _itemLocation(checkOut, false),
      if (isCheckDataLocation(checkIn))
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 20,
          ),
          child: LineHorizontal(),
        ),
    ]);
  }

  Widget _itemLocation(
    CheckInLocation? data,
    bool isCheckIn,
  ) =>
      isCheckDataLocation(data)
          ? Container(
              margin: EdgeInsets.only(
                top: 20,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isCheckIn ? getT(KeyT.check_in) : getT(KeyT.check_out),
                    style: AppStyle.DEFAULT_16_BOLD,
                  ),
                  itemTextIcon(
                    text: data?.note_location ?? '',
                    icon: ICONS.IC_LOCATION_SVG,
                    styleText: AppStyle.DEFAULT_14_BOLD,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24),
                    child: Text(
                      data?.time ?? '',
                      style: AppStyle.DEFAULT_14.copyWith(
                        color: COLORS.TEXT_GREY,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : SizedBox();
}

class ItemInfo extends StatelessWidget {
  const ItemInfo({
    Key? key,
    required this.data,
  }) : super(key: key);
  final InfoDataModel data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WidgetText(
            title: data.group_name,
            style: AppStyle.DEFAULT_16_BOLD,
          ),
          AppValue.vSpace10,
          ((data.data
                          ?.where((e) =>
                              e.value_field != '' && e.value_field != null)
                          .toList()
                          .length ??
                      0) >
                  0)
              ? Column(
                  children: List.generate(
                    data.data?.length ?? 0,
                    (index) {
                      final InfoItem? item = data.data?[index];
                      bool isNameSP = data.data?[index].name_field == 'name' ||
                          data.data?[index].field_name == 'name';

                      if (item?.field_type == 'LINE') {
                        return Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: LineHorizontal());
                      } else
                        return item?.value_field?.trim() != '' &&
                                item?.value_field != null
                            ? Container(
                                margin: EdgeInsets.symmetric(vertical: 5),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: WidgetText(
                                        title: item?.label_field ?? '',
                                        style: AppStyle.DEFAULT_14.copyWith(
                                          color: COLORS.TEXT_GREY,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: GestureDetector(
                                        onTap: () {
                                          if (item?.is_link == true) {
                                            _navigateTypeScreen(item);
                                          }
                                        },
                                        child: WidgetText(
                                          title: item?.value_field ?? '',
                                          textAlign: TextAlign.right,
                                          style: AppStyle.DEFAULT_14.copyWith(
                                            decoration: item?.is_link == true
                                                ? TextDecoration.underline
                                                : null,
                                            color: item?.is_link == true
                                                ? Colors.blue
                                                : isNameSP
                                                    ? COLORS.ORANGE_IMAGE
                                                    : null,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox.shrink();
                    },
                  ),
                )
              : Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: WidgetText(
                    title: getT(KeyT.no_data),
                    style: AppStyle.DEFAULT_14.copyWith(
                      color: COLORS.GREY,
                    ),
                  ),
                ),
          AppValue.vSpace20,
        ],
      ),
    );
  }
}
//KH => Khách hàng
// HD => Hợp đồng
// CH => Cơ hội (Lịch hẹn)
// DMLL => Đầu mối liên lạc
// SPKH => Sản phẩm kh (Xe của khách)
// SP => Sản phẩm
// HT => Hỗ trợ
// CV => Công việc

_navigateTypeScreen(InfoItem? data) {
  String id = data?.link ?? '';
  String title = data?.value_field ?? '';
  switch (data?.is_type) {
    case 'KH':
      AppNavigator.navigateDetailCustomer(id, title);
      break;

    case 'HD':
      AppNavigator.navigateDetailContract(id, title);
      break;

    case 'CH':
      AppNavigator.navigateDetailChance(id, title);
      break;

    case 'DMLL':
      AppNavigator.navigateDetailClue(id, title);
      break;
    case 'DM':
      AppNavigator.navigateDetailClue(id, title);
      break;

    case 'SPKH':
      AppNavigator.navigateDetailProductCustomer(title, id);
      break;

    case 'SP':
      AppNavigator.navigateDetailProduct(title, id);
      break;

    case 'HT':
      AppNavigator.navigateDetailSupport(id, title);
      break;

    case 'CV':
      AppNavigator.navigateDetailWork(int.tryParse(id) ?? 0, title);
      break;

    default:
      break;
  }
}

bool isCheckDataLocation(
  CheckInLocation? data,
) {
  return data != null &&
      (data.time ?? '') != '' &&
      (data.note_location ?? '') != '';
}
