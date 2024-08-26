import 'package:flutter/material.dart';
import '../../../src/color.dart';

class BoxItem extends StatelessWidget {
  const BoxItem({
    Key? key,
    required this.child,
    required this.onTap,
  }) : super(key: key);
  final Widget child;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        margin: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 16,
        ),
        padding: EdgeInsets.all(
          16,
        ),
        decoration: BoxDecoration(
          color: COLORS.WHITE,
          borderRadius: BorderRadius.all(
            Radius.circular(
              10,
            ),
          ),
          border: Border.all(
            color: COLORS.GREY_400,
            width: 0.5,
          ),
        ),
        child: child,
      ),
    );
  }
}
