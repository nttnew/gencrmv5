import 'package:flutter/material.dart';

import '../models/button_menu_model.dart';
import '../src/src_index.dart';

class ItemMenu extends StatelessWidget {
  const ItemMenu({
    Key? key,
    required this.data,
  }) : super(key: key);
  final ButtonMenuModel data;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: data.backgroundColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              child: Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                  child: WidgetContainerImage(
                    image: data.image,
                    fit: BoxFit.contain,
                    width: 40,
                    height: 40,
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
                    style: AppStyle.DEFAULT_12.copyWith(
                        fontFamily: 'Roboto', fontWeight: FontWeight.w500),
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
