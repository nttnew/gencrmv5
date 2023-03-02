import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController with SingleGetTickerProviderMixin {
  late AnimationController _animationController;
  late Animation<double> animationLogo;
  late Animation<double> animationTextFieldUser;
  final duration = const Duration(milliseconds: 1200);

  @override
  void onInit() {
    _animationController = AnimationController(duration: duration, vsync: this);

    animationLogo = Tween<double>(begin: 0, end: 150).animate(_animationController)
      ..addListener(() => update());
    animationTextFieldUser = Tween<double>(begin: Get.width, end: 0).animate(_animationController)
      ..addListener(() => update());

    _animationController.forward();
    super.onInit();
  }

  @override
  void onClose() {
    _animationController.dispose();
    super.onClose();
  }
}
class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LoginController());
  }
}
class ScaleRoute extends CustomTransition {
  @override
  Widget buildTransition(
      BuildContext context,
      Curve? curve,
      Alignment? alignment,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.fastOutSlowIn,
        ),
      ),
      child: child,
    );
  }
}
class BounceInNavigation extends CustomTransition {
    @override
    Widget buildTransition(
        BuildContext context,
        Curve? curve,
        Alignment? alignment,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child) {
      Widget fadeChild;
      if (animation.status == AnimationStatus.dismissed) {
        fadeChild = ScaleTransition(
          scale: Tween<double>(begin: 0.95, end: 1).animate(animation),
          child: child,
        );
      } else {
        fadeChild = child;
      }
      return FadeTransition(
        opacity: animation,
        child: fadeChild,
      );
    }
}
class SizeRoute extends CustomTransition {
  @override
  Widget buildTransition(
      BuildContext context,
      Curve? curve,
      Alignment? alignment,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return Scaffold(
      body: SizeTransition(
        sizeFactor: CurvedAnimation(
          curve: Curves.bounceOut,
          parent: animation,
        ),
        child: child,
      ),
    );
  }
}
