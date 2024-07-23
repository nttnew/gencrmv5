// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// // ignore: import_of_legacy_library_into_null_safe
// import 'package:gen_crm/src/src_index.dart';
//
// class WidgetButton extends StatelessWidget {
//   final VoidCallback onTap;
//   final String? text;
//   final TextStyle? textStyle;
//   final Color? backgroundColor, textColor;
//   final double? height, width;
//   final EdgeInsets? padding;
//   final bool? enable;
//   final Widget? child;
//   final BoxDecoration? boxDecoration;
//
//   const WidgetButton({
//     Key? key,
//     required this.onTap,
//     this.text,
//     this.backgroundColor,
//     this.textColor = COLORS.WHITE,
//     this.height = 55,
//     this.padding,
//     this.width,
//     this.enable = true,
//     this.child,
//     this.boxDecoration,
//     this.textStyle,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Padding(
//         padding: padding ?? EdgeInsets.symmetric(vertical: 16),
//         child: WidgetContainerCenter(
//             width: width ?? AppValue.widths,
//             height: height ?? 35,
//             boxDecoration: boxDecoration ??
//                 BoxDecoration(
//                     color: backgroundColor ?? COLORS.PRIMARY_COLOR,
//                     borderRadius: BorderRadius.circular(12)),
//             child: child ??
//                 Text(
//                   text!,
//                   style: textStyle ??
//                       AppStyle.DEFAULT_18.copyWith(
//                           color: textColor, fontWeight: FontWeight.w800),
//                 )),
//       ),
//     );
//   }
// }
