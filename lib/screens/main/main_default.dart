import 'package:flutter/material.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';
import '../../models/button_menu_model.dart';
import '../../src/src_index.dart';

class MainDefault extends StatelessWidget {
  const MainDefault({
    Key? key,
    required this.listMenu,
  }) : super(key: key);
  final List<ButtonMenuModel> listMenu;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Wrap(
        children: listMenu.asMap().entries.map((entry) {
          final value = entry.value;
          final i = entry.key;
          final hAll = MediaQuery.of(context).size.height -
              AppValue.heightsAppBar -
              MediaQuery.of(context).padding.top -
              16;
          final wAll = MediaQuery.of(context).size.width - 16;
          final h = hAll / (listMenu.length / 2).ceil();
          final w = (wAll / 2);
          bool isMaxWidth = false;
          if (listMenu.length % 2 != 0) {
            isMaxWidth = (i + 1) == listMenu.length;
          }
          return WidgetAnimator(
            key: Key(value.title.toString()+i.toString()),
            incomingEffect: WidgetTransitionEffects.incomingScaleDown(
              duration: Duration(milliseconds: 800),
            ),
            child: Container(
              height: h,
              width: isMaxWidth ? wAll : w,
              padding: EdgeInsets.all(8),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  backgroundColor: value.backgroundColor,
                  minimumSize: Size(0, 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        10,
                      ),
                    ),
                  ),
                ),
                onPressed: () => value.onTap(),
                child: Stack(
                  children: [
                    Positioned(
                      top: 8,
                      right: 0,
                      left: 0,
                      child: SizedBox(
                        width: (isMaxWidth ? wAll : w) - 16,
                        child: Text(
                          value.title,
                          style: AppStyle.DEFAULT_16_BOLD.copyWith(
                            color: isMaxWidth ? COLORS.WHITE : null,
                            fontSize: isMaxWidth ? 20 : null,
                          ),
                          maxLines: 2,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Image.asset(
                        ICONS.IC_NEXT_SCREEN_PNG,
                        height: 32,
                        color: isMaxWidth ? COLORS.WHITE : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
