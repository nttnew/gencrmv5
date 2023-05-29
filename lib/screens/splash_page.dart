import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gen_crm/api_resfull/user_repository.dart';
import 'package:gen_crm/bloc/blocs.dart';
import 'package:gen_crm/src/image_constants.dart';
import 'package:gen_crm/src/models/model_generator/login_response.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/storages/storages.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nb_utils/nb_utils.dart';

import '../api_resfull/dio_provider.dart';

class AnimatedLogo extends AnimatedWidget {
  static final _opacityTween = Tween<double>(begin: 0.1, end: 1);
  static final _sizeTween = Tween<double>(begin: 0, end: 300);
  AnimatedLogo({Key? key, required Animation<double> animation})
      : super(key: key, listenable: animation);
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Container(
        height: double.infinity,
        width: double.infinity,
        child: Center(
            child: Container(
          width: MediaQuery.of(context).size.width / 2,
          child: Image.asset(
            "assets/icons/logo.png",
            fit: BoxFit.contain,
          ),
        )),
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            HexColor("89F0DD"),
            HexColor("C5EDFF"),
          ],
        )));
  }
}

// ignore: use_key_in_widget_constructors
class SplashPage extends StatefulWidget {
  @override
  _LogoAppState createState() => _LogoAppState();
}

class _LogoAppState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  late Timer _timer;
  LoginData user = LoginData();
  String? baseUrl = "";
  @override
  void initState() {
    super.initState();
    //GetLogoBloc.of(context)..add(InitGetLogoEvent());
    getBaseUrl();
    loadUser();
    controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
    controller.forward();
  }

  loadUser() async {
    final response = await shareLocal.getString(PreferencesKey.USER);
    if (response != null) {
      setState(() {
        user = LoginData.fromJson(jsonDecode(response));
      });
    }
  }

  getBaseUrl() async {
    baseUrl = await shareLocal.getString("baseUrl");
    String? sess = await shareLocal.getString(PreferencesKey.SESS);
    String? token = await shareLocal.getString(PreferencesKey.TOKEN);
    if (baseUrl != dotenv.env[PreferencesKey.BASE_URL]) {
      dotenv.env[PreferencesKey.BASE_URL] = baseUrl ?? "";
      DioProvider.instance(
          sess: sess ?? "", baseUrl: baseUrl, token: token ?? "");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) async {
          var firstTime = await shareLocal.getBools(PreferencesKey.FIRST_TIME);
          switch (state.status) {
            case AuthenticationStatus.authenticated:
              _timer = Timer(const Duration(seconds: 1),
                  () => AppNavigator.navigateMain(data: user));
              break;
            case AuthenticationStatus.unauthenticated:
              _timer = Timer(const Duration(seconds: 1),
                  () => AppNavigator.navigateLogin());
              break;
            default:
              break;
          }
          // if (firstTime == false || firstTime == null)
          //   _timer = new Timer(
          //       const Duration(seconds: 1), () => AppNavigator.navigateLogin());
          // else
          //   _timer = new Timer(
          //       const Duration(seconds: 1), () => AppNavigator.navigateMain());
        },
        child: Scaffold(body: AnimatedLogo(animation: animation)));
  }

  @override
  void dispose() {
    controller.dispose();
    _timer.cancel();
    super.dispose();
  }
}
