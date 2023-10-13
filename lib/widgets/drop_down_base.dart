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
  }) : super(key: key);

  final BehaviorSubject<List<dynamic>> stream;
  final Function(dynamic item) onTap;
  final bool isName;
  @override
  State<DropDownBase> createState() => _DropDownBaseState();
}

class _DropDownBaseState extends State<DropDownBase> {
  BehaviorSubject<String?> typeStream = BehaviorSubject.seeded(null);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<dynamic>>(
        stream: widget.stream,
        builder: (context, snapshot) {
          final listFilter = snapshot.data ?? [];
          return listFilter.isNotEmpty
              ? StreamBuilder<String?>(
                  stream: typeStream,
                  builder: (context, snapshot) {
                    final filter = snapshot.data;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DropdownButton2(
                          isExpanded: true,
                          buttonPadding: EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          buttonDecoration: BoxDecoration(
                              border: Border.all(
                                color: COLORS.GREY_400,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4))),
                          dropdownMaxHeight:
                              MediaQuery.of(context).size.height / 2,
                          hint: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                filter ??
                                    (!widget.isName
                                        ? getT(KeyT.select_type)
                                        : getT(KeyT.select_filter)),
                                style: AppStyle.DEFAULT_16
                                    .copyWith(fontWeight: FontWeight.w600),
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
                                  ))
                            ],
                          ),
                          icon: Container(),
                          underline: Container(),
                          onChanged: (String? value) {},
                          items: listFilter
                              .map((items) => DropdownMenuItem<String>(
                                    onTap: () {
                                      typeStream.add(widget.isName
                                          ? items.name
                                          : items.label ?? '');
                                      widget.onTap(items);
                                    },
                                    value: widget.isName
                                        ? items.name
                                        : items.label ?? '',
                                    child: Text(
                                      widget.isName
                                          ? items.name
                                          : items.label ?? '',
                                      style: AppStyle.DEFAULT_16_BOLD,
                                    ),
                                  ))
                              .toList(),
                        ),
                      ],
                    );
                  })
              : SizedBox();
        });
  }
}
