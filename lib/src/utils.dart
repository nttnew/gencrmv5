import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gen_crm/src/device_size.dart';
import 'package:local_auth/local_auth.dart';

import '../bloc/login/login_bloc.dart';

class Utils {
  static final context = App.navigatorKey!.currentContext!;
  static loginWithFingerPrint(String? tokenFirebase) async {
    final LocalAuthentication auth = LocalAuthentication();
    try {
      final didAuthenticate = await auth.authenticate(localizedReason: 'Đăng nhập bằng vân tay', options: const AuthenticationOptions(biometricOnly: true));
      if (didAuthenticate) {
        LoginBloc.of(context).add(LoginWithFingerPrint(device_token: tokenFirebase ?? ''));
      } else {
        // showDialog(
        //     context: context,
        //     builder: (context) {
        //       return AlertDialog(
        //         title: Text("Thử lại sau 30 giây"),
        //       );
        //     });
        // Timer(const Duration(milliseconds: 2), () {
        //   if (Navigator.canPop(context)) {
        //     Navigator.pop(context);
        //   }
        // });
        return;
      }
    } catch (e) {
      print(e);
      return;
    }
  }
}
