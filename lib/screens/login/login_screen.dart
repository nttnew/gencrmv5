import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:gen_crm/bloc/blocs.dart';
import 'package:gen_crm/screens/login/widget/index.dart';
import 'package:gen_crm/src/app_const.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/widgets/widgets.dart';
import 'package:get/get.dart';
import '../../storages/share_local.dart';
import '../../widgets/rounder_bootom_appbar.dart';
import '../../l10n/key_text.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? tokenFirebase;
  late bool isLogin;

  @override
  void initState() {
    shareLocal.putString(PreferencesKey.REGISTER_MSG, LoginBloc.UNREGISTER);
    isLogin = Get.arguments == LOGIN;
    super.initState();
  }

  reload() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(
          content: Text(
            getT(KeyT.press_again_to_exit),
            style: AppStyle.DEFAULT_16.copyWith(color: COLORS.WHITE),
          ),
        ),
        child: WidgetTouchHideKeyBoard(
          child: SingleChildScrollView(
            child: Column(
              children: [
                RoundedAppBar(),
                AppValue.vSpaceTiny,
                WidgetLoginForm(
                  reload: reload,
                  isLogin: isLogin,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
