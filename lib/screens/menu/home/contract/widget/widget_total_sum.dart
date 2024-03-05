import 'package:flutter/material.dart';
import 'package:gen_crm/widgets/widgets.dart';
import '../../../../../src/src_index.dart';

class WidgetTotalSum extends StatefulWidget {
  WidgetTotalSum({Key? key, required this.label, required this.value})
      : super(key: key);

  final String? label;
  final String? value;

  @override
  State<WidgetTotalSum> createState() => _WidgetTotalSumState();
}

class _WidgetTotalSumState extends State<WidgetTotalSum> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            text: TextSpan(
              text: widget.label ?? '',
              style: AppStyle.DEFAULT_14W600,
              children: <TextSpan>[
                TextSpan(),
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: COLORS.LIGHT_GREY,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: COLORS.ffBEB4B4,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 10, top: 14, bottom: 14),
              child: Container(
                child: WidgetText(
                  title: widget.value,
                  style: AppStyle.DEFAULT_14_BOLD,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
