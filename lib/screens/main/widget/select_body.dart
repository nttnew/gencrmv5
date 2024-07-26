import 'package:flutter/material.dart';
import '../../../src/app_const.dart';
import '../../../src/src_index.dart';

showModalSelect(
  BuildContext context,
  String title,
  List<List<dynamic>> listData,
  Function(List<dynamic>?) onTap, {
  String? init,
}) {
  return showBottomGenCRM(
    child: SelectBody(
      init: init,
      title: title,
      listData: listData,
      onTap: onTap,
    ),
  );
}

class SelectBody extends StatefulWidget {
  const SelectBody({
    Key? key,
    required this.init,
    required this.title,
    required this.listData,
    required this.onTap,
  }) : super(key: key);
  final String? init;
  final String title;
  final List<List<dynamic>> listData;
  final Function(List<dynamic>?) onTap;

  @override
  State<SelectBody> createState() => _SelectBodyState();
}

class _SelectBodyState extends State<SelectBody> {
  List<dynamic>? dataSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 4),
      padding: EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.title,
            style: AppStyle.DEFAULT_18_BOLD.copyWith(
              color: COLORS.TEXT_BLUE_BOLD,
            ),
          ),
          AppValue.vSpace24,
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: widget.listData.asMap().entries.map((entry) {
              final e = entry.value;
              return GestureDetector(
                onTap: () {
                  widget.onTap(e);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: widget.init == e[1]
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
                    style: AppStyle.DEFAULT_16_T,
                  ),
                ),
              );
            }).toList(),
          ),
          AppValue.vSpaceMedium,
        ],
      ),
    );
  }
}
