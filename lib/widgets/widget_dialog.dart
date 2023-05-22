// import 'package:flutter/material.dart';
// import 'package:gen_crm/src/src_index.dart';
//
// class WidgetDialog extends StatelessWidget {
//   final VoidCallback? onTap2, onTap1;
//   final String? title;
//   final String? content;
//   final String? textButton1;
//   final String? textButton2;
//   final Color? backgroundButton1;
//   final Color? textColorButton1;
//   final Color? backgroundButton2;
//   final Color? textColorButton2;
//   final bool? twoButton;
//
//   const WidgetDialog(
//       {Key? key,
//       this.onTap1,
//       this.onTap2,
//       this.title,
//       this.content,
//       this.textButton1 = MESSAGES.CANCEL,
//       this.textButton2 = MESSAGES.OK,
//       this.textColorButton1 = COLORS.BLACK,
//       this.textColorButton2 = COLORS.BLACK,
//       this.backgroundButton1 = COLORS.GREY,
//       this.backgroundButton2 = COLORS.PRIMARY_COLOR,
//       this.twoButton = false})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//         top: false,
//         child: AlertDialog(
//           contentPadding: EdgeInsets.only(top: 10.0),
//           content: Container(
//             width: AppValue.widths - 30,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 Container(
//                   margin: EdgeInsets.symmetric(horizontal: 15),
//                   child: Column(
//                     children: [
//                       Text(title!, style: AppStyle.DEFAULT_16_BOLD),
//                       AppValue.vSpaceSmall,
//                       Text(
//                         content!,
//                         style: AppStyle.DEFAULT_16,
//                         textAlign: TextAlign.center,
//                       ),
//                     ],
//                   ),
//                 ),
//                 AppValue.vSpaceSmall,
//                 // if (twoButton == false)
//                   Divider(
//                     height: 1,
//                     color: COLORS.GREY,
//                   ),
//                 twoButton == false
//                     ? GestureDetector(
//                         onTap: onTap1 ?? () => AppNavigator.navigateBack(),
//                         child: Container(
//                           padding: EdgeInsets.all(15.0),
//                           margin:EdgeInsets.all(15.0),
//                           decoration: BoxDecoration(
//                             color: COLORS.PRIMARY_COLOR,
//                             borderRadius:
//                                 BorderRadius.all(Radius.circular(10.0)),
//                           ),
//                           child: Text(
//                             textButton1!,
//                             style: AppStyle.DEFAULT_16_BOLD
//                                 .copyWith(color: textColorButton1!),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                       )
//                     : Padding(
//                         padding: const EdgeInsets.all(15.0),
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: InkWell(
//                                 onTap:
//                                     onTap1 ?? () => AppNavigator.navigateBack(),
//                                 child: Container(
//                                   padding:
//                                       EdgeInsets.only(top: 15.0, bottom: 15.0),
//                                   decoration: BoxDecoration(
//                                     color: backgroundButton1,
//                                     borderRadius:
//                                         BorderRadius.all(Radius.circular(10.0)),
//                                   ),
//                                   child: Text(
//                                     textButton1!,
//                                     style: AppStyle.DEFAULT_16_BOLD
//                                         .copyWith(color: textColorButton1!),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 16,
//                             ),
//                             Expanded(
//                               child: InkWell(
//                                 onTap:
//                                     onTap2 ?? () => AppNavigator.navigateBack(),
//                                 child: Container(
//                                   padding:
//                                       EdgeInsets.only(top: 15.0, bottom: 15.0),
//                                   decoration: BoxDecoration(
//                                     color: backgroundButton2,
//                                     borderRadius:
//                                         BorderRadius.all(Radius.circular(10.0)),
//                                   ),
//                                   child: Text(
//                                     textButton2!,
//                                     style: AppStyle.DEFAULT_16_BOLD
//                                         .copyWith(color: textColorButton2!),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//               ],
//             ),
//           ),
//         ));
//   }
// }
