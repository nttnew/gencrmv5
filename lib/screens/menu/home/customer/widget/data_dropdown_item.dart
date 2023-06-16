import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gen_crm/src/app_const.dart';
import 'package:gen_crm/widgets/widgets.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:tiengviet/tiengviet.dart';

import '../../../../../src/src_index.dart';
import '../../../../../widgets/line_horizontal_widget.dart';

class DataDropDownItem extends StatefulWidget {
  DataDropDownItem(
      {Key? key,
      required this.data,
      required this.onSuccess,
      this.onLoadMore,
      this.onTabSearch,
      this.isSearch})
      : super(key: key);

  List data;
  Function onSuccess;
  Function? onLoadMore;
  Function? onTabSearch;
  bool? isSearch = false;

  @override
  State<DataDropDownItem> createState() => _DataDropDownItemState();
}

class _DataDropDownItemState extends State<DataDropDownItem> {
  String search = "";
  ScrollController _scrollController = ScrollController();
  List listData = [];
  List data = [];
  int page = 1;
  Debounce debounce = Debounce();

  @override
  void initState() {
    setState(() {
      data = widget.data;
      listData = widget.data;
    });
    if (widget.onLoadMore != null) {
      _scrollController.addListener(() {
        if (_scrollController.offset ==
                _scrollController.position.maxScrollExtent &&
            data.length % 10 == 0) {
          widget.onLoadMore!(page + 1, search);
          setState(() {});
          page = page + 1;
        } else {}
      });
    }

    super.initState();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      setState(() {
        data = widget.data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            width: Get.width,
            child: WidgetText(
              title: "Chọn",
              style: AppStyle.DEFAULT_20_BOLD,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        margin: EdgeInsets.only(top: 8, bottom: 4),
                        child: WidgetSearch(
                          hintTextStyle: TextStyle(
                              fontFamily: "Quicksand",
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: HexColor("#707070")),
                          hint: "Tìm kiếm",
                          height: 48,
                          leadIcon: SvgPicture.asset(ICONS.IC_SEARCH_SVG),
                          onSubmit: (v) {
                            search = v;
                            debounce.run(() {
                              if (widget.isSearch == true) {
                                widget.onTabSearch!(search);
                                page = 1;
                              } else {
                                if (widget.isSearch == false) {
                                  data = listData.where((i) {
                                    String value = TiengViet.parse(i['label'])
                                        .toLowerCase();
                                    String search1 =
                                        TiengViet.parse(search).toLowerCase();
                                    if (value.contains(search1))
                                      return true;
                                    else
                                      return false;
                                  }).toList();
                                  setState(() {});
                                }
                                FocusManager.instance.primaryFocus?.unfocus();
                              }
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Container(
                      width: Get.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                            data.length,
                            (index) => GestureDetector(
                                  onTap: () {
                                    widget.onSuccess(data[index]['value'],
                                        data[index]['label']);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(
                                      top: 16,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: WidgetText(
                                            title: data[index]['label'] ?? '',
                                            style: (data[index]['value'] ==
                                                        CA_NHAN ||
                                                    data[index]['value'] ==
                                                        TO_CHUC)
                                                ? AppStyle.DEFAULT_18.copyWith(
                                                    color: COLORS.RED,
                                                    fontWeight: FontWeight.w500)
                                                : AppStyle.DEFAULT_18.copyWith(
                                                    color:
                                                        COLORS.TEXT_BLUE_BOLD,
                                                  ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 16,
                                        ),
                                        LineHorizontal()
                                      ],
                                    ),
                                  ),
                                )),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
