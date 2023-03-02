// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutter/material.dart';
// import 'package:gen_crm/bloc/add_job_chance/add_job_chance_bloc.dart';
// import 'package:gen_crm/widgets/widget_input.dart';
// import 'package:gen_crm/widgets/widget_line.dart';
// import 'package:get/get.dart';
// import 'package:hexcolor/hexcolor.dart';
//
//
// import '../../../../src/src_index.dart';
// import '../../../../widgets/widget_appbar.dart';
//
// class AddChanceScreen extends StatefulWidget {
//   const AddChanceScreen({Key? key}) : super(key: key);
//
//   @override
//   State<AddChanceScreen> createState() => _AddChanceScreenState();
// }
//
// class _AddChanceScreenState extends State<AddChanceScreen> {
//   bool isSelect =true;
//
//   List dropdownItemList = [
//     {'label': 'Chọn khách hàng', 'value': ''},
//     {'label': 'apple', 'value': 'apple'}, // label is required and unique
//     {'label': 'banana', 'value': 'banana'},
//     {'label': 'grape', 'value': 'grape'},
//     {'label': 'pineapple', 'value': 'pineapple'},
//     {'label': 'grape fruit', 'value': 'grape fruit'},
//     {'label': 'kiwi', 'value': 'kiwi'},
//   ];
//
//   String id=Get.arguments[0];
//
//
//   @override
//   void initState() {
//     AddJobChanceBloc.of(context).add(InitGetAddJobEventChance(1));
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         toolbarHeight: AppValue.heights * 0.1,
//         backgroundColor: HexColor("#D0F1EB"),
//         title: Text(MESSAGES.ADD_CHANCE, style: TextStyle(color: Colors.black,fontFamily: "Montserrat",fontWeight: FontWeight.w700,fontSize: 16)),
//         leading: _buildBack(),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(
//             bottom: Radius.circular(15),
//           ),
//         ),
//       ),
//       body: Container(
//         height: AppValue.heights,
//         padding: EdgeInsets.only(left: 20,right: 20,top: 5),
//         color: COLORS.WHITE,
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               AppValue.vSpaceTiny,
//               Text('Nhóm nội dung 1',style: AppStyle.DEFAULT_16_BOLD,),
//               AppValue.vSpaceMedium,
//               _buildTextField('Họ và tên', 'Nhập tên khách hàng'),
//               AppValue.vSpaceTiny,
//               Text('Khách hàng',style: AppStyle.DEFAULT_14.copyWith(color: COLORS.GREY),),
//               _dropdownCustomer(),
//               AppValue.vSpaceMedium,
//               _buildTextField('Ngày sinh', 'Nhập ngày sinh',
//                   endIcon: SvgPicture.asset('assets/icons/sinhnhat.svg'), onTap:(){}
//               ),
//               AppValue.vSpaceMedium,
//               _buildTextField('Số tiền', 'Nhập số tiền',
//                   widthIcon: 50,
//                   endIcon: Image.asset('assets/icons/VNĐ.png'),onTap:(){}
//               ),
//               AppValue.vSpaceMedium,
//               WidgetLine(color: Colors.grey,),
//               AppValue.vSpaceSmall,
//               Text('Nhóm nội dung 2',style: AppStyle.DEFAULT_16_BOLD,),
//               AppValue.vSpaceMedium,
//               _buildTextField('Số lương', 'Nhập số lượng',),
//               AppValue.vSpaceMedium,
//               _buildTextField('Hình ảnh', 'Tải hình ảnh',
//                   enabled: false,
//                   widthIcon: 50,
//                   endIcon: Image.asset('assets/icons/cameraa.png'),onTap:(){}
//               ),
//               AppValue.vSpaceTiny,
//              Text('Nhóm khách',style: AppStyle.DEFAULT_14.copyWith(color: COLORS.GREY),),
//              _dropDownGourp()
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: Container(
//         height: 60,color: Colors.white,
//         padding: EdgeInsets.symmetric(horizontal: 20),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             GestureDetector(
//               onTap: (){},
//               child: SvgPicture.asset('assets/icons/file.svg'),
//             ),
//             GestureDetector(
//               onTap: (){},
//               child: Container(
//                 width: 100,height: 35,
//                 decoration: BoxDecoration(
//                     color: Color(0xffF1A400).withOpacity(0.8),
//                     borderRadius: BorderRadius.circular(20)
//                 ),
//                 child: Center(child: Text('Lưu',style: AppStyle.DEFAULT_14.copyWith(color: Colors.white),),),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//   _buildBack() {
//     return IconButton(
//       onPressed: () {AppNavigator.navigateBack();},
//       icon: Image.asset(
//         ICONS.ICON_BACK,
//         height: 28, width: 28,
//         color: COLORS.BLACK,
//       ),);
//   }
//   _buildTextField(String labelText, String hintText,
//       {bool enabled = true,
//         Widget? endIcon,
//         double? widthIcon,
//         GestureTapCallback? onTap,
//         TextEditingController? controller}) {
//     return GestureDetector(
//       onTap: onTap,
//       child: WidgetInput(
//         colorFix: COLORS.WHITE,
//         height: 35,
//         endIcon: endIcon,
//         widthIcon: widthIcon,
//         inputController: controller,
//         enabled: enabled,
//         boxDecoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             border: Border.all(width: 1,color: COLORS.GREY.withOpacity(0.8))
//         ),
//         inputType: TextInputType.text,
//         focusNode: null,
//         hint: hintText,
//         Fix: Container(
//           width: 80,
//           height: 20,
//           decoration: BoxDecoration(
//             color: Colors.white,
//           ),
//           child: Stack(children: [
//             Container(
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   border: Border(
//                     top: BorderSide(color: Colors.white),
//                     left: BorderSide(color: Colors.white),
//                     right: BorderSide(color: Colors.white),
//                   ),
//                 ),
//                 height: 11),
//             Text(labelText,style: AppStyle.DEFAULT_14.copyWith(color: COLORS.GREY),),
//           ],
//           ),
//         ),
//
//       ),
//     );
//   }
//   _dropDownGourp(){
//     return Container(
//       height: 35,width: AppValue.widths,
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(width: 1,color: COLORS.GREY.withOpacity(0.9))
//       ),
//       child: CoolDropdown(
//         resultIconRotation: false,
//         defaultValue: dropdownItemList[0],
//         dropdownList: dropdownItemList,
//         resultBD: BoxDecoration(
//             color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(10)
//         ),
//         resultTS: AppStyle.DEFAULT_12.copyWith(color: COLORS.GREY,fontWeight: FontWeight.w600),
//         resultWidth: AppValue.widths*0.9,
//         resultIcon: Padding(padding: EdgeInsets.only(right: 5),child: SvgPicture.asset('assets/icons/Search.svg')),
//         dropdownWidth: AppValue.widths*0.9,
//         onChange: (){},
//       ),
//     );
//   }
// }
