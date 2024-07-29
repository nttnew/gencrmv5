import 'dart:math';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import '../src/src_index.dart';
import '../../l10n/key_text.dart';

class DropDownBase extends StatefulWidget {
  const DropDownBase({
    Key? key,
    required this.stream,
    required this.onTap,
    this.isName = false,
    this.isPadding = true,
    this.isMarginRight = false,
    this.isExpand = false,
    this.title,
  }) : super(key: key);

  final BehaviorSubject<List<dynamic>> stream;
  final Function(dynamic item) onTap;
  final bool isName;
  final bool isPadding;
  final bool isMarginRight;
  final bool isExpand;
  final String? title;
  @override
  State<DropDownBase> createState() => _DropDownBaseState();
}

class _DropDownBaseState extends State<DropDownBase> {
  BehaviorSubject<String?> typeStream = BehaviorSubject.seeded(null);
  BehaviorSubject itemStream = BehaviorSubject();

  @override
  void initState() {
    itemStream.listen((value) {
      if (value != null) {
        widget.onTap(value);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    itemStream.close();
    typeStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<dynamic>>(
        stream: widget.stream,
        builder: (context, snapshot) {
          final _listFilter = snapshot.data ?? [];
          return _listFilter.isNotEmpty
              ? StreamBuilder<String?>(
                  stream: typeStream,
                  builder: (context, snapshot) {
                    final _filter = snapshot.data;
                    if (widget.isExpand)
                      return Expanded(
                          child:
                              _item(filter: _filter, listFilter: _listFilter));
                    return _item(filter: _filter, listFilter: _listFilter);
                  })
              : SizedBox();
        });
  }

  _item({
    String? filter,
    required List<dynamic> listFilter,
  }) =>
      Container(
        margin: widget.isMarginRight
            ? EdgeInsets.only(
                left: 8,
              )
            : null,
        padding: widget.isPadding
            ? const EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 16,
              )
            : null,
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButton2(
              dropdownElevation: 2,
              dropdownDecoration: BoxDecoration(
                color: COLORS.WHITE,
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    6,
                  ),
                ),
              ),
              isExpanded: true,
              buttonPadding: EdgeInsets.symmetric(
                horizontal: 10,
              ),
              buttonDecoration: BoxDecoration(
                border: Border.all(
                  color: COLORS.GREY_400,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(6),
                ),
              ),
              dropdownMaxHeight: MediaQuery.of(context).size.height / 2,
              hint: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Text(
                      filter ??
                          widget.title ??
                          ((!widget.isName
                              ? getT(KeyT.select_type)
                              : getT(KeyT.select_filter))),
                      style: AppStyle.DEFAULT_16
                          .copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Transform.rotate(
                    angle: -4.5 * pi,
                    child: Icon(
                      Icons.arrow_back_ios_new_sharp,
                      size: 16,
                      // color: COLORS.TEXT_COLOR,
                    ),
                  )
                ],
              ),
              icon: SizedBox.shrink(),
              underline: SizedBox.shrink(),
              onChanged: (String? value) {},
              items: listFilter
                  .map(
                    (items) => DropdownMenuItem<String>(
                      onTap: () {
                        typeStream.add(_getName(items));
                        itemStream.add(items);
                      },
                      value: _getName(items),
                      child: Text(
                        _getName(items),
                        style: AppStyle.DEFAULT_16_BOLD.copyWith(
                          color: filter == _getName(items) ? COLORS.RED : null,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      );

  _getName(items) => widget.isName ? items.name : items.label ?? '';
}
