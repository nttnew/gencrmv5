import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../src/app_const.dart';
import '../../../src/base.dart';
import '../../../src/color.dart';
import '../../../src/models/model_generator/customer_clue.dart';
import '../../../src/navigator.dart';
import '../../../src/styles.dart';
import '../../../widgets/widgets.dart';
import '../form/add_service_voucher/add_service_voucher_screen.dart';

floatingActionButton(
  _key,
  List<Customer> listMenuPlus,
) {
  return listMenuPlus.isNotEmpty
      ? ExpandableFab(
          key: _key,
          distance: 65,
          type: ExpandableFabType.up,
          child: Icon(Icons.add, size: 40),
          closeButtonStyle: const ExpandableFabCloseButtonStyle(
            child: Icon(Icons.close),
            foregroundColor: COLORS.WHITE,
            backgroundColor: COLORS.ff1AA928,
          ),
          backgroundColor: COLORS.ff1AA928,
          overlayStyle: ExpandableFabOverlayStyle(
            blur: 5,
          ),
          children: listMenuPlus.reversed
              .map(
                (e) => GestureDetector(
                  onTap: () async {
                    final state = _key.currentState;
                    if (state != null) {
                      if (state.isOpen) {
                        await _handelRouterMenuPlus(e);
                        state.toggle();
                      }
                    }
                  },
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: COLORS.WHITE,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: COLORS.BLACK.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                            )
                          ],
                        ),
                        child: WidgetText(
                          title: e.name ?? '',
                          style: AppStyle.DEFAULT_18_BOLD.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          left: 8,
                          right: 8,
                        ),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: COLORS.WHITE,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: COLORS.BLACK.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                            )
                          ],
                        ),
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: Image.asset(
                            ModuleText.getIconMenu(e.id.toString()),
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => SvgPicture.asset(
                              ModuleText.getIconMenu(e.id.toString()),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
              .toList(),
        )
      : SizedBox();
}

_handelRouterMenuPlus(Customer customer) {
  final id = customer.id ?? '';
  final name = customer.name?.toLowerCase() ?? '';
  final add = ((customer.danh_xung?.toLowerCase() ?? '') + ' ' + name).trim();
  if (ModuleText.CUSTOMER == id) {
    AppNavigator.navigateForm(
      title: add,
      type: ADD_CUSTOMER,
    );
  } else if (ModuleText.CUSTOMER_ORGANIZATION == id) {
    AppNavigator.navigateForm(
      title: add,
      type: ADD_CUSTOMER_OR,
    );
  } else if (ModuleText.CALL == id) {
    AppNavigator.navigateCall(title: name);
  } else if (ModuleText.DAU_MOI == id) {
    AppNavigator.navigateForm(title: name, type: ADD_CLUE);
  } else if (ModuleText.LICH_HEN == id) {
    AppNavigator.navigateForm(title: name, type: ADD_CHANCE);
  } else if (ModuleText.HOP_DONG_FLASH == id) {
    Navigator.of(Get.context!).push(MaterialPageRoute(
        builder: (context) => AddServiceVoucherScreen(
              title: name.toUpperCase().capitalizeFirst ?? '',
            )));
  } else if (ModuleText.HOP_DONG == id) {
    AppNavigator.navigateForm(
      title: name.toUpperCase().capitalizeFirst ?? '',
      type: ADD_CONTRACT,
    );
  } else if (ModuleText.CONG_VIEC == id) {
    AppNavigator.navigateForm(title: name, type: ADD_JOB);
  } else if (ModuleText.CONG_VIEC_CHECK_IN == id) {
    AppNavigator.navigateForm(title: name, type: ADD_JOB, isCheckIn: true);
  } else if (ModuleText.SUPPORT == id) {
    AppNavigator.navigateForm(title: name, type: ADD_SUPPORT);
  } else if (ModuleText.SUPPORT_CHECK_IN == id) {
    AppNavigator.navigateForm(title: name, type: ADD_SUPPORT, isCheckIn: true);
  }
}
//////////////////////
