import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:gen_crm/bloc/blocs.dart';
import 'package:gen_crm/screens/login/widget/index.dart';
import 'package:gen_crm/src/app_const.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/widgets/widgets.dart';
import 'package:get/get.dart';
import '../../l10n/l10n.dart';
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
                  Stack(
                    children: [
                      RoundedAppBar(),
                      Positioned(
                        top: 50,
                        right: 15,
                        child: DropdownButton2(
                          hint: StreamBuilder<Locale>(
                              stream: LoginBloc.of(context).locale,
                              builder: (context, snapshot) {
                                return Row(
                                  children: [
                                    Container(
                                      child: Image.asset(getFlagCountry(
                                        snapshot.data.toString(),
                                      )),
                                      height: 30,
                                      width: 30,
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    SizedBox(
                                      width: 20,
                                      child: Text(
                                        snapshot.data.toString().toUpperCase(),
                                        style: AppStyle.DEFAULT_16_BOLD,
                                      ),
                                    ),
                                  ],
                                );
                              }),
                          icon: Container(),
                          underline: Container(),
                          onChanged: (String? value) {},
                          dropdownWidth: 90,
                          barrierColor: Colors.grey.withOpacity(0.4),
                          items: L10n.all
                              .map((items) => DropdownMenuItem<String>(
                                    onTap: () {
                                      LoginBloc.of(context).locale.add(items);
                                      setState(() {
                                      });
                                    },
                                    value: items.toString(),
                                    child: Row(
                                      children: [
                                        Container(
                                          child: Image.asset(getFlagCountry(
                                            items.toString(),
                                          )),
                                          height: 30,
                                          width: 30,
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          items.toString().toUpperCase(),
                                          style: AppStyle.DEFAULT_16_BOLD,
                                        ),
                                      ],
                                    ),
                                  ))
                              .toList(),
                        ),
                      )
                    ],
                  ),
                  AppValue.vSpaceSmall,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(Get.context!)?.login??'',
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
