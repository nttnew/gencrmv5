import 'package:flutter/material.dart';
import '../../../l10n/key_text.dart';
import '../../../src/app_const.dart';
import '../../../src/src_index.dart';
import '../../../widgets/btn_thao_tac.dart';

showModalSelectMulti(
  BuildContext context,
  List<String> title,
  List<List<List<dynamic>>> listData,
  Function(List<List<dynamic>>?) onTap, {
  List<String?>? init,
}) {
  return showBottomGenCRM(
    child: SelectBodyMulti(
      init: init,
      title: title,
      listData: listData,
      onTap: onTap,
    ),
  );
}

class SelectBodyMulti extends StatefulWidget {
  const SelectBodyMulti({
    Key? key,
    required this.init,
    required this.title,
    required this.listData,
    required this.onTap,
  }) : super(key: key);
  final List<String?>? init;
  final List<String> title;
  final List<List<List<dynamic>>> listData;
  final Function(List<List<dynamic>>?) onTap;

  @override
  State<SelectBodyMulti> createState() => _SelectBodyMultiState();
}

class _SelectBodyMultiState extends State<SelectBodyMulti> {
  List<List<dynamic>> dataSelect = [];

  @override
  void initState() {
    widget.listData.forEach((element) {
      dataSelect.add(['', '']);
    });

    for (int i = 0; i < widget.listData.length; i++) {
      for (final vl2 in widget.init ?? []) {
        for (final vl3 in widget.listData[i]) {
          if (vl2 == vl3[1]) {
            dataSelect[i] = vl3;
          }
        }
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 4),
      padding: EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListView.builder(
              shrinkWrap: true,
              itemCount: widget.listData.length,
              itemBuilder: (context, i) {
                final itemData = widget.listData[i];
                final title = widget.title[i];
                final isEnable = dataSelect.first.first != '' ||
                    i == 0; // phải chọn người làm mới chọn được tiến độ
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: AppStyle.DEFAULT_18_BOLD.copyWith(
                        color: COLORS.TEXT_BLUE_BOLD,
                      ),
                    ),
                    AppValue.vSpace24,
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: itemData.asMap().entries.map((entry) {
                        final e = entry.value;
                        return GestureDetector(
                          onTap: () {
                            if (isEnable) {
                              dataSelect[i] = e;
                              setState(() {});
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: dataSelect[i] == e
                                  ? COLORS.ORANGE.withOpacity(0.5)
                                  : COLORS.LIGHT_GREY,
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  12,
                                ),
                              ),
                            ),
                            child: Text(
                              e[1],
                              style: AppStyle.DEFAULT_16_T.copyWith(
                                color: isEnable ? null : COLORS.GREY,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    AppValue.vSpaceMedium,
                  ],
                );
              }),
          AppValue.vSpaceSmall,
          Row(
            children: [
              Expanded(
                child: ButtonSmall(
                    title: getT(KeyT.close),
                    onTap: () {
                      Navigator.pop(context);
                    }),
              ),
              AppValue.hSpaceSmall,
              Expanded(
                child: ButtonSmall(
                  title: getT(KeyT.save),
                  onTap: () {
                    widget.onTap(dataSelect);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
