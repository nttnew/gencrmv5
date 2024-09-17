import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gen_crm/screens/widget/widget_label.dart';
import '../l10n/key_text.dart';
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
    _init();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant InputMultipleWidget oldWidget) {
    _init();
    super.didUpdateWidget(oldWidget);
  }

  _init(){
    if (widget.value?.isNotEmpty ?? false) {
      arr = widget.value ?? [];
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: marginBottomFrom,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: boxDecorationBaseForm,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: paddingBaseForm,
                  decoration: arr.isEmpty
                      ? null
                      : BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: COLORS.BLUE, width: 2),
                          ),
                        ),
                  child: Focus(
                    onFocusChange: (status) {
                      if (status == false) {
                        if (_editingController.text != '') {
                          arr.add(_editingController.text);
                          widget.onSelect(arr);
                          setState(() {
                            check = !check;
                          });
                        }
                        _editingController.text = '';
                        _focusNode.unfocus();
                      }
                    },
                    child: TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      controller: _editingController,
                      onEditingComplete: () {
                        if (_editingController.text != '') {
                          arr.add(_editingController.text);
                          widget.onSelect(arr);
                          setState(() {
                            check = !check;
                          });
                        }
                        _editingController.text = '';
                        _focusNode.unfocus();
                      },
                      focusNode: _focusNode,
                      style: AppStyle.DEFAULT_14_BOLD,
                      keyboardType: widget.data.field_special == 'default'
                          ? TextInputType.text
                          : widget.data.field_special == 'numeric'
                              ? TextInputType.number
                              : widget.data.field_special == 'email-address'
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
                        hintStyle: hintTextStyle,
                        hintText: getT(KeyT.enter) +
                            ' ' +
                            widget.data.field_label.toString().toLowerCase(),
                        contentPadding: EdgeInsets.zero,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                ),
                if (arr.isNotEmpty)
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: arr
                          .map(
                            (e) => ConstrainedBox(
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
                                            MediaQuery.of(context).size.width -
                                                90,
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
                                        widget.onSelect(arr);
                                      },
                                      child: Image.asset(
                                        ICONS.IC_REMOVE_TXT_PNG,
                                        height: 20,
                                        width: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  )
              ],
            ),
          ),
          WidgetLabelPo(
            data: widget.data,
          ),
        ],
      ),
    );
  }
}
