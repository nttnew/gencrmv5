// import 'package:double_back_to_close_app/double_back_to_close_app.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gen_crm/models/index.dart';
// import 'package:gen_crm/screens/screens.dart';
// import 'package:gen_crm/src/src_index.dart';
//
// class MainScreen extends StatefulWidget {
//
//   @override
//   _MainScreenState createState() => _MainScreenState();
// }
//
// class _MainScreenState extends State<MainScreen> {
//
//   //GlobalKey pageView = GlobalKey();
//   PageController controller = PageController(initialPage: 2, keepPage: false);
//
//   List<ButtonMenuModel> listMenu = [
//     ButtonMenuModel(title: MESSAGES.MENU_HOME, image: ICONS.MENU_HOME, isSelect: false),
//     ButtonMenuModel(title: MESSAGES.MENU_COURSE, image: ICONS.MENU_INTRODUCE, isSelect: false),
//     ButtonMenuModel(title: 'Trang chủ', image: IMAGES.LOGO_APP, isSelect: true),
//     ButtonMenuModel(title: MESSAGES.MENU_LOCATION, image: ICONS.MENU_MAP, isSelect: false),
//     ButtonMenuModel(title: MESSAGES.MENU_INTRODUCE, image: ICONS.MENU_USER, isSelect: false),
//     ButtonMenuModel(title: MESSAGES.MENU_INTRODUCE, image: ICONS.MENU_USER, isSelect: false),
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: DoubleBackToCloseApp(
//           snackBar: SnackBar(
//             content: Text(MESSAGES.BACK_TO_EXIT, style: AppStyle.DEFAULT_16.copyWith(color: COLORS.WHITE),),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Expanded(
//                   child: PageView(
//                     controller: controller,
//                     scrollDirection: Axis.horizontal,
//                     physics: const NeverScrollableScrollPhysics(),
//                     children: const [
//                       NewsScreen(),
//                       NewsScreen(),
//                       NewsScreen(),
//                       NewsScreen(),
//                       NewsScreen(),
//                     ],
//                   )
//
//               ),
//               _buildMenu()
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   int page = 2;
//
//   _buildMenu(){
//     return Container(
//       width: Get.width,
//       decoration: const BoxDecoration(
//         color: COLORS.WHITE,
//         borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: List.generate(listMenu.length, (index) {
//           List<ButtonMenuModel> list = [];
//           return GestureDetector(
//               onTap: () {
//                 for (var itemData in listMenu) {
//                   if (itemData.title == listMenu[index].title) {
//                     itemData = ButtonMenuModel(
//                         image: itemData.image,
//                         title: itemData.title,
//                         isSelect: true);
//                     setState(() {
//                       page = index;
//                       print('abc category page = $page');
//                     });
//                     list.add(itemData);
//                   } else {
//                     itemData = ButtonMenuModel(
//                         image: itemData.image,
//                         title: itemData.title,
//                         isSelect: false);
//                     list.add(itemData);
//                   }
//                 }
//                 setState(() => listMenu = list);
//                 controller.jumpToPage(index);
//               },
//               child: index == 2 ? const WidgetContainerImage(
//                 image: IMAGES.LOGO_APP,
//                 height: 65,
//                 width: 65,
//               ) : _buildItemMenu(data: listMenu[index], index: index)
//           );
//         }),
//       ),
//     );
//   }
//
//   _buildItemMenu({required ButtonMenuModel data, required int index}){
//     return Container(
//       color: Colors.white,
//       width: Get.width*0.15,
//       child: Column(
//         children: [
//           WidgetContainerImage(
//             image: data.image,
//             colorImage: index != 2 ? data.isSelect ? COLORS.PRIMARY_COLOR : null : null,
//           ),
//           AppValue.vSpaceTiny,
//           Text(data.title, style: AppStyle.DEFAULT_12.copyWith(color: data.isSelect ? COLORS.PRIMARY_COLOR : COLORS.BLACK), overflow: TextOverflow.ellipsis,)
//         ],
//       ),
//     );
//   }
//
// }