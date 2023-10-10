import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:gen_crm/bloc/blocs.dart';
import 'package:gen_crm/screens/login/widget/index.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/widgets/widgets.dart';
import 'package:get/get.dart';
import '../../storages/share_local.dart';
import '../../widgets/rounder_bootom_appbar.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? tokenFirebase;
  late final ScrollController scrollController;
  late bool isLogin;

  @override
  void initState() {
    LoginBloc.of(context).getLanguage();
    shareLocal.putString(PreferencesKey.REGISTER_MSG, LoginBloc.UNREGISTER);
    scrollController = ScrollController();
    isLogin = Get.arguments == 'login';
    KeyboardVisibilityController().onChange.listen((visible) {
      if (visible) {
        scrollController.jumpTo(150);
      } else {
        scrollController.jumpTo(0);
      }
    });
    super.initState();
  }

  reload() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      drawerEnableOpenDragGesture: false,
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(
          content: Text(
            AppLocalizations.of(Get.context!)?.press_again_to_exit ?? '',
            style: AppStyle.DEFAULT_16.copyWith(color: COLORS.WHITE),
          ),
        ),
        child: SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: WidgetTouchHideKeyBoard(
              child: Column(
                children: [
                  RoundedAppBar(),
                  AppValue.vSpaceSmall,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(Get.context!)?.login ?? '',
                        style: AppStyle.DEFAULT_18_BOLD,
                      )
                    ],
                  ),
                  AppValue.vSpaceSmall,
                  WidgetLoginForm(
                    reload: reload,
                    isLogin: isLogin,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
