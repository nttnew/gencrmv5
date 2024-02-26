import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../src/models/model_generator/add_customer.dart';
import '../src/src_index.dart';
import 'widget_text.dart';

// ignore: must_be_immutable
class InputMultipleWidget extends StatefulWidget {
  InputMultipleWidget({
    Key? key,
    required this.data,
    required this.onSelect,
    this.value,
  }) : super(key: key);

  final CustomerIndividualItemData data;
  final Function onSelect;
  final List<String>? value;

  @override
  State<InputMultipleWidget> createState() => _InputMultipleWidgetState();
}

class _InputMultipleWidgetState extends State<InputMultipleWidget> {
  List<String> arr = [];
  TextEditingController _editingController = TextEditingController();
  bool check = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    _focusNode = FocusNode();
    if (widget.value?.isNotEmpty ?? false) {
      arr = widget.value ?? [];
    }
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

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
              text: widget.data.field_label ?? '',
              style: TextStyle(
                fontFamily: "Quicksand",
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: COLORS.BLACK,
              ),
              children: <TextSpan>[
                widget.data.field_require == 1
                    ? TextSpan(
                        text: '*',
                        style: TextStyle(
                            fontFamily: "Quicksand",
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: COLORS.RED))
                    : TextSpan(),
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: COLORS.ffBEB4B4)),
            child: Padding(
              padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
              child: Focus(
                onFocusChange: (status) {
                  if (status == false) {
                    if (_editingController.text != "") {
                      arr.add(_editingController.text);
                      widget.onSelect(arr);
                      setState(() {
                        check = !check;
                      });
                    }
                    _editingController.text = "";
                    _focusNode.unfocus();
                  }
                },
                child: TextField(
                  textCapitalization: TextCapitalization.sentences,
                  controller: _editingController,
                  onEditingComplete: () {
                    if (_editingController.text != "") {
                      arr.add(_editingController.text);
                      widget.onSelect(arr);
                      setState(() {
                        check = !check;
                      });
                    }
                    _editingController.text = "";
                    _focusNode.unfocus();
                  },
                  focusNode: _focusNode,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  keyboardType: widget.data.field_special == "default"
                      ? TextInputType.text
                      : widget.data.field_special == "numberic"
                          ? TextInputType.number
                          : widget.data.field_special == "email-address"
                              ? TextInputType.emailAddress
                              : TextInputType.text,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(
                        widget.data.field_maxlength != null
                            ? int.parse(widget.data.field_maxlength!)
                            : null),
                  ],
                  maxLengthEnforcement:
                      MaxLengthEnforcement.truncateAfterCompositionEnds,
                  decoration: InputDecoration(
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      isDense: true),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 8),
            child: Wrap(
              spacing: 8,
              runSpacing: 6,
              children: arr
                  .map((e) => ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: double.maxFinite,
                          maxWidth: MediaQuery.of(context).size.width,
                          minHeight: 0,
                          minWidth: 0,
                        ),
                        child: Container(
                          padding: EdgeInsets.only(
                            right: 4,
                            bottom: 4,
                            left: 8,
                            top: 4,
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: COLORS.BACKGROUND),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxHeight: double.maxFinite,
                                  maxWidth:
                                      MediaQuery.of(context).size.width - 90,
                                  minHeight: 0,
                                  minWidth: 0,
                                ),
                                child: WidgetText(
                                  maxLine: 1,
                                  overflow: TextOverflow.ellipsis,
                                  title: e,
                                  style: AppStyle.DEFAULT_14,
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              InkWell(
                                  onTap: () {
                                    arr.remove(e);
                                    setState(() {
                                      check = !check;
                                    });
                                  },
                                  child: Image.asset(
                                    ICONS.IC_REMOVE_TXT_PNG,
                                    height: 20,
                                    width: 20,
                                  )),
                            ],
                          ),
                        ),
                      ))
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
}
