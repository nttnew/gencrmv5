import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:gen_crm/screens/home/notification/widget/selectable_container.dart';
import '../../../../../src/models/model_generator/list_notification.dart';
import '../../../../../src/src_index.dart';
import '../../../../../widgets/widget_text.dart';

class ItemNotification extends StatefulWidget {
  const ItemNotification({
    Key? key,
    required this.item,
    required this.isSelect,
    required this.onChange,
    required this.onLongPress,
    required this.onTap,
  }) : super(key: key);
  final DataNotification item;
  final bool isSelect;
  final Function(DataNotification, bool) onChange;
  final Function(DataNotification, bool) onLongPress;
  final Function(DataNotification) onTap;

  @override
  State<ItemNotification> createState() => _ItemNotificationState();
}

class _ItemNotificationState extends State<ItemNotification> {
  DataNotification? _item;

  @override
  void initState() {
    _item = widget.item;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ItemNotification oldWidget) {
    _item = widget.item;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return widget.isSelect
        ? SelectableContainer(
            selectedBorderColor: Colors.transparent,
            selectedBackgroundColor: Colors.transparent,
            unselectedBorderColor: Colors.transparent,
            unselectedBackgroundColor: Colors.transparent,
            iconAlignment: Alignment.topLeft,
            unselectedIcon: null,
            selected: _item?.isSelect ?? false,
            onValueChanged: (bool value) {
              _item?.isSelect = value;
              setState(() {});
              widget.onChange(_item!, value);
            },
            child: _widgetLess(),
          )
        : _widgetItem();
  }

  Widget _widgetItem() {
    return InkWell(
      onLongPress: () {
        _item?.isSelect = true;
        widget.onLongPress(_item!, true);
      },
      onTap: () {
        widget.onTap(_item!);
      },
      child: _widgetLess(),
    );
  }

  _widgetLess() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: 10,
        right: 16,
        bottom: 10,
        top: 16,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: COLORS.GREY_400,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 6),
            child: WidgetText(
              title: _item?.title ?? '',
              style: AppStyle.DEFAULT_16_BOLD,
            ),
          ),
          AppValue.vSpaceTiny,
          Html(
            data: _item?.content ?? '',
          ),
        ],
      ),
    );
  }
}
