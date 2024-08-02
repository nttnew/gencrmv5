import 'package:flutter/material.dart';
import '../../../../src/models/model_generator/add_customer.dart';
import '../../widget/widget_label.dart';

class RenderCheckBox extends StatefulWidget {
  RenderCheckBox({
    Key? key,
    required this.onChange,
    required this.data,
    this.init,
  }) : super(key: key);

  final Function onChange;
  final CustomerIndividualItemData data;
  final bool? init;

  @override
  State<RenderCheckBox> createState() => _RenderCheckBoxState();
}

class _RenderCheckBoxState extends State<RenderCheckBox> {
  bool isCheck = false;

  @override
  void initState() {
    isCheck = widget.init ?? false;
    widget.onChange(isCheck);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: marginBottomFrom,
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            margin: EdgeInsets.only(
              right: 8,
            ),
            child: Checkbox(
              value: isCheck,
              onChanged: (bool? value) {
                widget.onChange(value);
                setState(() {
                  isCheck = value!;
                });
              },
            ),
          ),
          WidgetLabel(widget.data),
        ],
      ),
    );
  }
}
