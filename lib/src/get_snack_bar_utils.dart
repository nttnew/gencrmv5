import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gen_crm/src/color.dart';
import 'package:gen_crm/widgets/widget_handle.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GetSnackBarUtils {
  static SnackStyle _snackStyle = SnackStyle.FLOATING;
  static SnackPosition _snackPosition = SnackPosition.BOTTOM;
  static bool _isDismissible = false;
  static Duration _progressDuration = Duration(seconds: 15);
  static Duration _stateDuration = Duration(seconds: 1);
  static Duration _stateDurationDelay = Duration(seconds: 2);
  static Color _backgroundColor = COLORS.PRIMARY_COLOR;
  static Color _successColor = Colors.green;
  static Color _failureColor = Colors.orange;
  static Color _errorColor = COLORS.RED;
  static Color _warningColor = Colors.yellow;
  static Color _informationColor = Colors.blue;

  static createProgress() {
    if (Get.isSnackbarOpen) {
      Get.back();
    }
    Get.rawSnackbar(
        title: AppLocalizations.of(Get.context!)?.processing_the_request,
        message: AppLocalizations.of(Get.context!)?.please_wait_a_moment,
        icon: Center(child: WidgetCircleProgress()),
        duration: _progressDuration,
        backgroundColor: _backgroundColor,
        snackStyle: _snackStyle,
        snackPosition: _snackPosition,
        isDismissible: _isDismissible);
  }

  static Future<void> createSuccess({String? message}) async {
    if (Get.isSnackbarOpen) {
      Get.back();
    }
    Get.rawSnackbar(
        title: AppLocalizations.of(Get.context!)?.processing_the_request,
        message: message != null && message.isNotEmpty
            ? message
            : AppLocalizations.of(Get.context!)?.success,
        icon: Center(
            child: Icon(
          Icons.check,
          color: _successColor,
        )),
        duration: _stateDuration,
        backgroundColor: _backgroundColor,
        snackStyle: _snackStyle,
        snackPosition: _snackPosition,
        isDismissible: _isDismissible);
    return await Future.delayed(_stateDurationDelay);
  }

  static createFailure({String? message}) {
    if (Get.isSnackbarOpen) {
      Get.back();
    }
    Get.rawSnackbar(
        title: AppLocalizations.of(Get.context!)?.fail,
        message: message != null && message.isNotEmpty
            ? message
            : AppLocalizations.of(Get.context!)?.fail,
        icon: Center(
            child: Icon(
          Icons.error,
          color: _failureColor,
        )),
        duration: Duration(seconds: 2),
        backgroundColor: _backgroundColor,
        snackStyle: _snackStyle,
        snackPosition: _snackPosition,
        isDismissible: _isDismissible);
  }

  static createError({String? message}) {
    if (Get.isSnackbarOpen) {
      Get.back();
    }
    Get.rawSnackbar(
        title: AppLocalizations.of(Get.context!)?.notification,
        message: message != null && message.isNotEmpty
            ? message
            : AppLocalizations.of(Get.context!)?.fail,
        icon: Center(
            child: Icon(
          Icons.error,
          color: _errorColor,
        )),
        duration: Duration(seconds: 2),
        backgroundColor: _backgroundColor,
        snackStyle: _snackStyle,
        snackPosition: _snackPosition,
        isDismissible: _isDismissible);
  }

  static createWarning({String? message}) {
    if (Get.isSnackbarOpen) {
      Get.back();
    }
    Get.rawSnackbar(
        title: AppLocalizations.of(Get.context!)?.warning,
        message: message != null && message.isNotEmpty
            ? message
            : AppLocalizations.of(Get.context!)?.warning,
        icon: Center(
            child: Icon(
          Icons.warning,
          color: _warningColor,
        )),
        duration: Duration(seconds: 2),
        backgroundColor: _backgroundColor,
        snackStyle: _snackStyle,
        snackPosition: _snackPosition,
        isDismissible: _isDismissible);
  }

  static createInformation({String? message}) {
    if (Get.isSnackbarOpen) {
      Get.back();
    }
    Get.rawSnackbar(
        title: AppLocalizations.of(Get.context!)?.notification,
        message: message != null && message.isNotEmpty
            ? message
            : AppLocalizations.of(Get.context!)?.notification,
        icon: Center(
            child: Icon(
          Icons.notifications,
          color: _informationColor,
        )),
        duration: Duration(seconds: 2),
        backgroundColor: _backgroundColor,
        snackStyle: _snackStyle,
        snackPosition: _snackPosition,
        isDismissible: _isDismissible);
  }

  static removeSnackBar() {
    if (Get.isSnackbarOpen) {
      Get.back();
    }
  }
}
