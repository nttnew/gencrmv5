import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/api_resfull/user_repository.dart';
import 'package:gen_crm/bloc/blocs.dart';
import 'package:gen_crm/src/models/model_generator/login_response.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/storages/storages.dart';
import '../api_resfull/dio_provider.dart';

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
    LoginBloc.of(context).getLanguageAPI();
    super.initState();
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
    if (response != null && response != '') {
      setState(() {
        try {
          user = LoginData.fromJson(jsonDecode(response));
        } catch (e) {}
      });
    }
  }

  getBaseUrl() async {
    baseUrl = await shareLocal.getString(PreferencesKey.URL_BASE) ?? '';
    String? sess = await shareLocal.getString(PreferencesKey.SESS);
    String? token = await shareLocal.getString(PreferencesKey.TOKEN);
    DioProvider.instance(
        sess: sess ?? '', baseUrl: baseUrl, token: token ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) async {
        switch (state.status) {
          case AuthenticationStatus.authenticated:
            _timer = Timer(const Duration(seconds: 1),
                () => AppNavigator.navigateMain(data: user));
            break;
          case AuthenticationStatus.unauthenticated:
            _timer = Timer(
                const Duration(seconds: 1), () => AppNavigator.navigateLogin());
            break;
          default:
            break;
        }
      },
      child: Scaffold(
        body: AnimatedLogo(
          animation: animation,
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    _timer.cancel();
    super.dispose();
  }
}

class AnimatedLogo extends AnimatedWidget {
  AnimatedLogo({Key? key, required Animation<double> animation})
      : super(key: key, listenable: animation);
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          child: Image.asset(
            ICONS.IC_LOGO_PNG,
            fit: BoxFit.contain,
          ),
        ),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            COLORS.ff89F0DD,
            COLORS.ffC5EDFF,
          ],
        ),
      ),
    );
  }
}
