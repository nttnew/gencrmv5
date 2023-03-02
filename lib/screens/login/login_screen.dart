import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:gen_crm/screens/login/index.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/widgets/widgets.dart';

import '../../widgets/rounder_bootom_appbar.dart';

class LoginScreen extends StatefulWidget {

  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  String? tokenFirebase;

  @override
  void initState() {
    // fireBase();
    super.initState();
  }



  reload(){
    setState((){

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(
          content: Text(MESSAGES.BACK_TO_EXIT, style: AppStyle.DEFAULT_16.copyWith(color: COLORS.WHITE),),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              WidgetTouchHideKeyBoard(
                child: Column(
                  children: [
                    RoundedAppBar(),
                    SingleChildScrollView(
                      child: Container(
                        child: Column(
                          children: [
                            AppValue.vSpaceMedium,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Đăng nhập",style: TextStyle(fontFamily: "Quicksand", fontWeight: FontWeight.bold,fontSize: 20),)
                              ],
                            ),
                            AppValue.vSpaceMedium,
                            WidgetLoginForm(reload: reload),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
