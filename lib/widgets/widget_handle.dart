import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gen_crm/src/src_index.dart';

class WidgetContainerImage extends StatelessWidget {
  final double? width, height, padding, margin;
  final String? image;
  final BoxDecoration? boxDecoration;
  final Color? colorImage;
  final bool? isRadius;
  final BoxFit? fit;
  final GestureTapCallback? onTap;
  final BorderRadius? borderRadius;

  const WidgetContainerImage(
      {this.width = 30,
      this.height = 30,
      this.padding = 0,
      this.margin = 0,
      this.borderRadius,
      this.image,
      this.boxDecoration,
      this.colorImage,
      this.isRadius,
      this.onTap,
      this.fit = BoxFit.fill});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: boxDecoration,
        padding: EdgeInsets.all(padding!),
        margin: EdgeInsets.all(margin!),
        child: ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.circular(0),
          child: Center(
              child: Image.asset(
            image!,
            color: colorImage,
            fit: fit,
            height: height,
            width: width,
          )),
        ),
      ),
    );
  }
}

class WidgetNetworkImage extends StatelessWidget {
  final double? width, height, borderRadius;
  final BorderRadiusGeometry? borderRadiusCustom;
  final String image;
  final BoxDecoration? boxDecoration;
  final BoxFit? fit;
  final GestureTapCallback? onTap;
  final bool isAvatar;

  const WidgetNetworkImage({
    this.width,
    this.height,
    this.borderRadius,
    this.borderRadiusCustom,
    required this.image,
    this.boxDecoration,
    this.onTap,
    this.fit = BoxFit.fill,
    this.isAvatar = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecoration,
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius:
              borderRadiusCustom ?? BorderRadius.circular(borderRadius ?? 100),
          child: Image.network(
            image,
            height: height,
            width: width,
            fit: fit,
            errorBuilder: (context, url, error) => isAvatar
                ? Container(
                    width: width,
                    height: height,
                    child: Image.asset(
                      ICONS.IC_PROFILE_ERROR_PNG,
                      fit: BoxFit.contain,
                    ))
                : Container(
                    width: width,
                    height: height,
                    child: const Icon(Icons.error)),
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                width: width,
                height: height,
                child: Center(
                  child: Container(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class WidgetNetworkCacheImage extends StatelessWidget {
  final double? width, height, borderRadius;
  final BorderRadiusGeometry? borderRadiusCustom;
  final String image;
  final BoxDecoration? boxDecoration;
  final BoxFit? fit;
  final GestureTapCallback? onTap;

  const WidgetNetworkCacheImage({
    this.width,
    this.height,
    this.borderRadius,
    this.borderRadiusCustom,
    required this.image,
    this.boxDecoration,
    this.onTap,
    this.fit = BoxFit.fill,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecoration,
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius:
              borderRadiusCustom ?? BorderRadius.circular(borderRadius ?? 100),
          child: CachedNetworkImage(
            imageUrl: image,
            fit: fit,
            height: height,
            width: width,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: fit,
                ),
              ),
            ),
            placeholder: (context, url) => CupertinoActivityIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
      ),
    );
  }
}

class WidgetContainerImageFile extends StatelessWidget {
  final double? width, height, borderRadius;
  final File? image;
  final BoxDecoration? boxDecoration;
  final Color? colorImage;
  final bool? isRadius;
  final BoxFit? fit;
  final GestureTapCallback? onTap;
  final EdgeInsets? padding, margin;

  const WidgetContainerImageFile(
      {this.width = 30,
      this.height = 30,
      this.padding,
      this.margin,
      this.borderRadius,
      this.image,
      this.boxDecoration,
      this.colorImage,
      this.isRadius,
      this.onTap,
      this.fit = BoxFit.fill});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: boxDecoration,
        padding: padding,
        margin: margin,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius ?? 100),
          child: Center(
              child: Image.file(
            image!,
            color: colorImage,
            fit: fit,
            height: height,
            width: width,
          )),
        ),
      ),
    );
  }
}

class WidgetContainerColor extends StatelessWidget {
  final Color? color;
  final double? width, height, radius;
  final bool? isCircle, isBorder;

  const WidgetContainerColor(
      {Key? key,
      this.color = COLORS.BLACK,
      this.width = 25,
      this.height = 25,
      this.radius = 5,
      this.isCircle = false,
      this.isBorder = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          shape: isCircle == true ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: BorderRadius.circular(radius ?? 0),
          color: color,
          border: isBorder == true ? Border.all(color: COLORS.GREY) : null),
    );
  }
}

class WidgetContainerIcon extends StatelessWidget {
  final double? width, height;
  final IconData? icon;
  final Color? backgroundColor, iconColor;

  const WidgetContainerIcon(
      {this.width = 35,
      this.height = 35,
      this.icon,
      this.backgroundColor = COLORS.WHITE,
      this.iconColor = COLORS.BLACK});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        width: width,
        decoration:
            BoxDecoration(shape: BoxShape.circle, color: backgroundColor),
        child: Center(child: Icon(icon, color: iconColor)));
  }
}

class WidgetCircleProgress extends StatelessWidget {
  final Color? backgroundColor;
  final Color? valueColor;

  const WidgetCircleProgress({this.backgroundColor, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      padding: EdgeInsets.all(5),
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(valueColor ?? Colors.blue),
        backgroundColor: backgroundColor ?? Colors.grey,
      ),
    );
  }
}

class WidgetContainerCenter extends StatelessWidget {
  final double? width, height;
  final Widget? child;
  final BoxDecoration? boxDecoration;

  WidgetContainerCenter(
      {this.width, this.height, this.child, this.boxDecoration});

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        height: height,
        decoration: boxDecoration,
        child: Center(child: child),
      );
}

class UnicornOutlineButton extends StatelessWidget {
  final _GradientPainter? _painter;
  final Widget _child;
  final double _radius;
  final double? height, width;
  final Color backgroundColor;
  final bool? check;

  UnicornOutlineButton({
    required double strokeWidth,
    required double radius,
    required Gradient gradient,
    required Widget child,
    required Color backgroundColor,
    double? height,
    double? width,
    bool? check = false,
  })  : this._painter = _GradientPainter(
            strokeWidth: strokeWidth, radius: radius, gradient: gradient),
        this._child = child,
        this.backgroundColor = backgroundColor,
        this.height = height,
        this.width = width,
        this.check = check,
        this._radius = radius;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _painter,
      child: Container(
        height: height ?? 40,
        width: width ?? 40,
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(_radius)),
        margin: EdgeInsets.all(2),
        child: _child,
      ),
    );
  }
}

class _GradientPainter extends CustomPainter {
  final Paint _paint = Paint();
  final double radius;
  final double strokeWidth;
  final Gradient gradient;

  _GradientPainter(
      {required double strokeWidth,
      required double radius,
      required Gradient gradient})
      : this.strokeWidth = strokeWidth,
        this.radius = radius,
        this.gradient = gradient;

  @override
  void paint(Canvas canvas, Size size) {
    // create outer rectangle equals size
    Rect outerRect = Offset.zero & size;
    var outerRRect =
        RRect.fromRectAndRadius(outerRect, Radius.circular(radius));

    // create inner rectangle smaller by strokeWidth
    Rect innerRect = Rect.fromLTWH(strokeWidth, strokeWidth,
        size.width - strokeWidth * 2, size.height - strokeWidth * 2);
    var innerRRect = RRect.fromRectAndRadius(
        innerRect, Radius.circular(radius - strokeWidth));

    // apply gradient shader
    _paint.shader = gradient.createShader(outerRect);

    // create difference between outer and inner paths and draw it
    Path path1 = Path()..addRRect(outerRRect);
    Path path2 = Path()..addRRect(innerRRect);
    var path = Path.combine(PathOperation.difference, path1, path2);
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => oldDelegate != this;
}
