import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../l10n/key_text.dart';
import '../../../../../src/models/model_generator/response_ntc_filter.dart';
import '../../../../../src/src_index.dart';
import '../../../../../widgets/btn_thao_tac.dart';

class SelectKyTaiChinh extends StatefulWidget {
  const SelectKyTaiChinh({
    Key? key,
    required this.soQuy,
    required this.onSelect,
    this.yearSelect,
    this.kyTaiChinhSelect,
  }) : super(key: key);
  final List<DataNTCFilter> soQuy;
  final Function(DataNTCFilter?, KyTaiChinh?) onSelect;
  final DataNTCFilter? yearSelect;
  final KyTaiChinh? kyTaiChinhSelect;

  @override
  State<SelectKyTaiChinh> createState() => _SelectKyTaiChinhState();
}

class _SelectKyTaiChinhState extends State<SelectKyTaiChinh> {
  DataNTCFilter? yearSelect;
  late List<DataNTCFilter> soQuy;
  KyTaiChinh? kyTaiChinhSelect;

  @override
  void initState() {
    soQuy = widget.soQuy;
    soQuy.forEach((element) {
      if (element == widget.yearSelect) {
        yearSelect = element;
      }
    });
    if (yearSelect != null) kyTaiChinhSelect = widget.kyTaiChinhSelect;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 8,
        ),
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                getT(KeyT.nam_tai_chinh),
                style: AppStyle.DEFAULT_18_BOLD,
              ),
              GestureDetector(
                onTap: () {
                  kyTaiChinhSelect = null;
                  setState(() {});
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: COLORS.LIGHT_BLUE,
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        4,
                      ),
                    ),
                  ),
                  child: Text(
                    getT(KeyT.uncheck_all),
                    style: AppStyle.DEFAULT_14.copyWith(
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 36,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: 24,
            ),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: soQuy.length,
            itemBuilder: (context, i) => GestureDetector(
              onTap: () {
                yearSelect = soQuy[i];
                kyTaiChinhSelect = yearSelect?.kyTaiChinh?.first;
                setState(() {});
              },
              child: Container(
                width: MediaQuery.of(context).size.width / 5,
                margin: EdgeInsets.only(
                  right: 16,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      24,
                    ),
                  ),
                  border: Border.all(
                    width: yearSelect?.nam == soQuy[i].nam ? 2 : 1,
                    color: yearSelect?.nam == soQuy[i].nam
                        ? COLORS.BLUE
                        : COLORS.GREY_400,
                  ),
                ),
                child: Center(
                  child: Text(
                    soQuy[i].nam.toString(),
                    style: AppStyle.DEFAULT_14W600,
                  ),
                ),
              ),
            ),
          ),
        ),
        if ((yearSelect?.kyTaiChinh?.length ?? 0) > 0) ...[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              getT(KeyT.ky_ke_toan),
              style: AppStyle.DEFAULT_18_BOLD,
            ),
          ),
          GridView.builder(
            key: UniqueKey(),
            padding: EdgeInsets.symmetric(
              horizontal: 24,
            ),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              mainAxisExtent: 35,
            ),
            itemCount: yearSelect?.kyTaiChinh?.length,
            itemBuilder: (BuildContext context, int i) {
              return GestureDetector(
                onTap: () {
                  if (kyTaiChinhSelect == yearSelect?.kyTaiChinh?[i]) {
                    kyTaiChinhSelect = null;
                  } else {
                    kyTaiChinhSelect = yearSelect?.kyTaiChinh?[i];
                  }
                  setState(() {});
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        24,
                      ),
                    ),
                    border: Border.all(
                      width: kyTaiChinhSelect == yearSelect?.kyTaiChinh?[i]
                          ? 2
                          : 1,
                      color: kyTaiChinhSelect == yearSelect?.kyTaiChinh?[i]
                          ? COLORS.BLUE
                          : COLORS.GREY_400,
                    ),
                  ),
                  child: FittedBox(
                    child: Text(
                      yearSelect?.kyTaiChinh?[i].name ?? '',
                      style: AppStyle.DEFAULT_14W600,
                      maxLines: 1,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
        SizedBox(
          height: 32,
        ),
        ButtonThaoTac(
          onTap: () {
            if (yearSelect != null) {
              widget.onSelect(yearSelect, kyTaiChinhSelect);
            } else {
              Get.back();
            }
          },
          title: getT(KeyT.select),
          marginHorizontal: 16,
        ),
      ],
    );
  }
}
