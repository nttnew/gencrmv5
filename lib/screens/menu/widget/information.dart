import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gen_crm/src/models/model_generator/work.dart';
import 'package:gen_crm/storages/share_local.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../l10n/key_text.dart';
import '../../../src/app_const.dart';
import '../../../src/models/model_generator/detail_customer.dart';
import '../../../src/src_index.dart';
import '../../../widgets/line_horizontal_widget.dart';
import '../../../widgets/widget_text.dart';
import '../form/widget/preview_image.dart';

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
  ItemInfo({
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
                              e.value_field != '' &&
                              e.value_field != null &&
                              e.value_field != [])
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
                      bool isImage = data.data?[index].is_image == 1;
                      bool isCheckBox = data.data?[index].data_type == 'CHECK';

                      if (item?.field_type == 'LINE') {
                        return Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: LineHorizontal());
                      } else if (isImage) {
                        final List<String> listImage =
                            item?.value_field.toString().split(',') ?? [];
                        if (listImage.length == 0 ||
                            listImage.firstOrNull == '')
                          return SizedBox.shrink();
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              WidgetText(
                                title: item?.label_field ?? '',
                                style: AppStyle.DEFAULT_14.copyWith(
                                  color: COLORS.TEXT_GREY,
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: listImage
                                      .map(
                                        (e) => GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    PreviewImage(
                                                  file: File(
                                                      shareLocal.getString(
                                                              PreferencesKey
                                                                  .URL_BASE) +
                                                          e),
                                                  isNetwork: true,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(
                                              right: 10,
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl: shareLocal.getString(
                                                      PreferencesKey.URL_BASE) +
                                                  e,
                                              fit: BoxFit.contain,
                                              height: 100,
                                              errorWidget: (_, ___, __) =>
                                                  SizedBox.shrink(),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
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
                                    child: isCheckBox
                                        ? Align(
                                            alignment: Alignment.centerRight,
                                            child: Container(
                                              width: 20,
                                              height: 20,
                                              child: Checkbox(
                                                value: item?.value_field
                                                        .toString() ==
                                                    '1',
                                                onChanged: null,
                                              ),
                                            ),
                                          )
                                        : GestureDetector(
                                            onTap: () {
                                              if (item?.is_link == true) {
                                                _navigateTypeScreen(item);
                                              }
                                            },
                                            child: WidgetText(
                                              title: item?.value_field ?? '',
                                              textAlign: TextAlign.right,
                                              style:
                                                  AppStyle.DEFAULT_14.copyWith(
                                                decoration: item?.is_link ==
                                                        true
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
  switch (data?.is_type) {
    case 'KH':
      AppNavigator.navigateDetailCustomer(id);
      break;

    case 'HD':
      AppNavigator.navigateDetailContract(id);
      break;

    case 'CH':
      AppNavigator.navigateDetailChance(id);
      break;

    case 'DMLL':
      AppNavigator.navigateDetailClue(id);
      break;
    case 'DM':
      AppNavigator.navigateDetailClue(id);
      break;

    case 'SPKH':
      AppNavigator.navigateDetailProductCustomer(id);
      break;

    case 'SP':
      AppNavigator.navigateDetailProduct(id);
      break;

    case 'HT':
      AppNavigator.navigateDetailSupport(id);
      break;

    case 'CV':
      AppNavigator.navigateDetailWork(int.tryParse(id) ?? 0);
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

loadInfo({bool isTitle = true}) {
  return Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: 16,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isTitle) _itemLoading(w: 3),
        _itemLoadingContent(),
        _itemLoadingContent(),
        _itemLoadingContent(),
        _itemLoadingContent(),
        _itemLoadingContent(),
        _itemLoadingContent(),
        _itemLoadingContent(),
        AppValue.vSpaceSmall,
        LineHorizontal(),
      ],
    ),
  );
}

_itemLoadingContent() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      _itemLoading(w: 3),
      AppValue.hSpaceSmall,
      _itemLoading(w: 1.5),
    ],
  );
}

_itemLoading({double w = 2}) => Shimmer.fromColors(
      baseColor: Colors.black12,
      highlightColor: Colors.white,
      child: Container(
        margin: EdgeInsets.only(
          bottom: 10,
        ),
        height: 20,
        width: (MediaQuery.of(Get.context!).size.width - 48) / w,
        decoration: BoxDecoration(
          color: Colors.cyan,
          borderRadius: BorderRadius.all(
            Radius.circular(
              4,
            ),
          ),
        ),
      ),
    );
