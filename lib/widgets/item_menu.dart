import 'package:flutter/material.dart';
import '../models/button_menu_model.dart';
import '../src/src_index.dart';

class ItemMenu extends StatelessWidget {
  const ItemMenu({
    Key? key,
    required this.data,
    this.isLast = false,
    required this.onTap,
  }) : super(key: key);
  final ButtonMenuModel data;
  final bool isLast;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onTap(),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: data.backgroundColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              child: Center(
                child: Container(
                  width: isLast ? 90 : 80,
                  height: isLast ? 90 : 80,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: COLORS.WHITE),
                  child: WidgetContainerImage(
                    image: data.image,
                    fit: BoxFit.contain,
                    width: isLast ? 45 : 40,
                    height: isLast ? 45 : 40,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    data.title,
                    style: isLast
                        ? AppStyle.DEFAULT_14.copyWith(
                            fontSize: 24,
                            color: COLORS.WHITE,
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.w700)
                        : AppStyle.DEFAULT_14.copyWith(
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
