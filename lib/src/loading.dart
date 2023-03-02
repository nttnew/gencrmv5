import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class TrailLoading extends StatelessWidget {
  final double height;
  final double width;
  const TrailLoading({Key? key, this.height = 70, this.width = 70}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Lottie.asset(
          'assets/lottie/loading.json',
        ),
      ),
    );
  }
}

class TrailError extends StatelessWidget {
  final double height;
  final double width;
  const TrailError({Key? key, this.height = 50, this.width = 50}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: height,
        width: width,
        child: Lottie.asset(
          'assets/lottie/44656_error.json',
        ),
      ),
    );
  }
}
