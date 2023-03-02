// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:cool_dropdown/cool_dropdown.dart';
// import 'package:gen_crm/widgets/line_horizontal_widget.dart';
// import 'package:gen_crm/widgets/widget_input.dart';
// import 'package:hexcolor/hexcolor.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_dropdown/flutter_dropdown.dart';
// import '../../../../src/src_index.dart';
//
// class AddWork extends StatelessWidget {
//   const AddWork({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     List dropdownItemList = [
//       {'label': 'Chọn loại khách ', 'value': ''},
//       {'label': 'apple', 'value': 'apple'}, // label is required and unique
//       {'label': 'banana', 'value': 'banana'},
//       {'label': 'grape', 'value': 'grape'},
//       {'label': 'pineapple', 'value': 'pineapple'},
//       {'label': 'grape fruit', 'value': 'grape fruit'},
//       {'label': 'kiwi', 'value': 'kiwi'},
//     ];
//     return Scaffold(
//         appBar: AppBar(
//           toolbarHeight: AppValue.heights * 0.1,
//           backgroundColor: HexColor("#D0F1EB"),
//           centerTitle: false,
//           title: Text("Thêm công việc", style: TextStyle(color: Colors.black,fontFamily: "Montserrat",fontWeight: FontWeight.w700,fontSize: 16)),
//           leading: Padding(
//               padding: EdgeInsets.only(left: 30),
//               child: InkWell(onTap:()=>AppNavigator.navigateBack(),child: Icon(Icons.arrow_back,color:Colors.black))),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.vertical(
//               bottom: Radius.circular(15),
//             ),
//           ),
//
//         ),
//         body: Column(
//           children: [
//             Container(
//               margin: EdgeInsets.only(
//                   left: AppValue.widths * 0.05,
//                   right: AppValue.widths * 0.05,
//                   top: AppValue.heights * 0.02),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(
//                     height: AppValue.heights * 0.01,
//                   ),
//                   Text("Nhóm nội dung 1",style:TextStyle(color:HexColor("#263238"),fontFamily: "Quicksand",fontWeight: FontWeight.w700,fontSize: 18)),
//                   SizedBox(
//                     height: AppValue.heights * 0.01,
//                   ),
//                   _fieldInputCustomer(),
//                   SizedBox(
//                     height: AppValue.heights * 0.01,
//                   ),
//                   _fieldInputCustomerType(dropdownItemList, context),
//                   SizedBox(
//                     height: AppValue.heights * 0.01,
//                   ),
//                   _fieldInputBirthDay(),
//                   SizedBox(
//                     height: AppValue.heights * 0.01,
//                   ),
//                   _fieldInputMoney(),
//                   SizedBox(
//                     height: AppValue.heights * 0.03,
//                   ),
//                   LineHorizontal(),
//                   SizedBox(
//                     height: AppValue.heights * 0.03,
//                   ),
//                   Text("Nhóm nội dung 2",style:TextStyle(color:HexColor("#263238"),fontFamily: "Quicksand",fontWeight: FontWeight.w700,fontSize: 18)),
//                   SizedBox(
//                     height: AppValue.heights * 0.01,
//                   ),
//                   _fieldInputAmount(),
//                   SizedBox(
//                     height: AppValue.heights * 0.01,
//                   ),
//                   fieldInputImage(),
//                   SizedBox(
//                     height: AppValue.heights * 0.01,
//                   ),
//                   fieldInputCustomerTypeOnetoMultiple(dropdownItemList, context),
//                   SizedBox(
//                     height: AppValue.heights * 0.03,
//                   ),
//                   Row(
//                     children: [
//                       SvgPicture.asset("assets/icons/attack.svg"),
//                       Spacer(),
//                       Container(
//                         height: AppValue.widths*0.1,
//                         width: AppValue.widths*0.25,
//                         decoration:  BoxDecoration(
//                             color: HexColor("#F1A400"),
//                             borderRadius: BorderRadius.circular(20.5)
//                         ),
//                         child: Center(child: Text("Lưu",style: TextStyle(color:Colors.white),)),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ));
//   }
//
//   Column fieldInputCustomerTypeOnetoMultiple(List<dynamic> dropdownItemList, BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text("Nhóm khách (chọn 1 nhiều)",style: titlestyle(),),
//         SizedBox(height: AppValue.heights*0.005,),
//         Container(
//             width: double.infinity,
//             height: AppValue.heights * 0.05,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(5),
//                 border: Border.all(color: HexColor("#BEB4B4"))),
//             child: CoolDropdown(
//                 resultIconRotation: false,
//                 resultWidth: AppValue.widths * 0.9,
//                 resultIcon: Icon(Icons.search),
//                 dropdownList: dropdownItemList,
//                 onChange: (_) {},
//                 resultTS: TextStyle(
//                   fontSize: 11,
//                   fontFamily: "Roboto",
//                   fontWeight: FontWeight.w500,
//                   color: HexColor("#838A91"),
//                 ),
//                 defaultValue: dropdownItemList[0],
//                 resultBD: BoxDecoration(
//                   color: Theme.of(context).scaffoldBackgroundColor,
//                   borderRadius: BorderRadius.circular(5),
//                 )
//               // placeholder: 'insert...',
//             )),
//       ],
//     );
//   }
//
//   Column fieldInputImage() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text("Hình ảnh",style: titlestyle(),),
//         SizedBox(
//           height: AppValue.heights * 0.005,
//         ),
//         Container(
//           width: double.infinity,
//           height: AppValue.heights * 0.05,
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(5),
//               border: Border.all(color: HexColor("#BEB4B4"))),
//           child: Row(children: [
//             SizedBox(
//               width: 10,
//             ),
//             Expanded(
//               child: Container(
//                 margin: EdgeInsets.symmetric(vertical: 10),
//                 child: TextFormField(
//                   decoration: InputDecoration(
//                     hintText: "Tải hình ảnh",
//                     hintStyle: hintTextStyle(),
//                     focusedBorder: InputBorder.none,
//                     enabledBorder: InputBorder.none,
//                     disabledBorder: InputBorder.none,
//                   ),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.only(right: 15),
//               child: Center(
//                   child: Container(
//                       height: 50,
//                       width: 50,
//                       child: SvgPicture.asset(
//                           "assets/icons/iconInputImg.svg"))),
//             )
//           ]),
//         ),
//       ],
//     );
//   }
//   Column _fieldInputAmount() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text("Số lượng",style: titlestyle(),),
//         SizedBox(height: AppValue.heights*0.005,),
//         Container(
//           width: double.infinity,
//           height: AppValue.heights * 0.05,
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(5),
//               border: Border.all(color: HexColor("#BEB4B4"))),
//           child: Padding(
//             padding: EdgeInsets.only(left: 10),
//             child: Container(
//               margin: EdgeInsets.symmetric(vertical: 10),
//               child: TextFormField(
//                 decoration: InputDecoration(
//                   hintText: "Nhâp số lượng",
//                   hintStyle: hintTextStyle(),
//                   focusedBorder: InputBorder.none,
//                   enabledBorder: InputBorder.none,
//                   disabledBorder: InputBorder.none,
//                 ),
//               ),
//             ),
//           ),
//         ),
//         SizedBox(
//           height: AppValue.heights * 0.01,
//         ),
//       ],
//     );
//   }
//
//   Column _fieldInputMoney() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text("Số tiền",style: titlestyle(),),
//         SizedBox(
//           height: AppValue.heights * 0.005,
//         ),
//         Container(
//           width: double.infinity,
//           height: AppValue.heights * 0.05,
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(5),
//               border: Border.all(color: HexColor("#BEB4B4"))),
//           child: Row(
//             children: [
//               SizedBox(
//                 width: 10,
//               ),
//               Expanded(
//                 child: Container(
//                   margin: EdgeInsets.symmetric(vertical: 10),
//                   child: TextFormField(
//                     decoration: InputDecoration(hintText: "Nhập số tiền",
//                       hintStyle: hintTextStyle(),
//                       focusedBorder: InputBorder.none,
//                       enabledBorder: InputBorder.none,
//                       disabledBorder: InputBorder.none,
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.only(right: 15),
//                 child: Center(
//                     child: Container(
//                         height: 50,
//                         width: 50,
//                         child: SvgPicture.asset(
//                             "assets/icons/iconInputMoney.svg"))),
//               )
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Column _fieldInputBirthDay() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text("Ngày sinh",style: titlestyle(),),
//         SizedBox(
//           height: AppValue.heights * 0.005,
//         ),
//         Container(
//           width: double.infinity,
//           height: AppValue.heights * 0.05,
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(5),
//               border: Border.all(color: HexColor("#BEB4B4"))),
//           child: Row(
//             children: [
//               SizedBox(
//                 width: 10,
//               ),
//               Expanded(
//                 child: Container(
//                   margin: EdgeInsets.symmetric(vertical: 10),
//                   child: TextFormField(
//                     decoration: InputDecoration(
//                       hintText: "Nhập ngày sinh",
//                       hintStyle: hintTextStyle(),
//                       focusedBorder: InputBorder.none,
//                       enabledBorder: InputBorder.none,
//                       disabledBorder: InputBorder.none,
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.only(right: 15),
//                 child: Center(
//                     child: Container(
//                         height: 20,
//                         width: 20,
//                         child: SvgPicture.asset(
//                             "assets/icons/iconInputBirthday.svg"))),
//               )
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Column _fieldInputCustomerType(List<dynamic> dropdownItemList, BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text("Loại khách hàng",style: titlestyle(),),
//         SizedBox(
//           height: AppValue.heights * 0.005,
//         ),
//         Container(
//             width: double.infinity,
//             height: AppValue.heights * 0.05,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(5),
//                 border: Border.all(color: HexColor("#BEB4B4"))),
//             child: CoolDropdown(
//                 resultWidth: AppValue.widths * 0.9,
//                 resultIcon:
//                 SvgPicture.asset("assets/icons/iconDropDown.svg"),
//                 dropdownList: dropdownItemList,
//                 onChange: (_) {},
//                 resultTS: TextStyle(
//                   fontSize: 11,
//                   fontFamily: "Roboto",
//                   fontWeight: FontWeight.w500,
//                   color: HexColor("#838A91"),
//                 ),
//                 defaultValue: dropdownItemList[0],
//                 resultBD: BoxDecoration(
//                   color: Theme.of(context).scaffoldBackgroundColor,
//                   borderRadius: BorderRadius.circular(10),
//                 )
//               // placeholder: 'insert...',
//             )),
//       ],
//     );
//   }
//
//   Column _fieldInputCustomer() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         RichText(
//           text: TextSpan(
//             text: 'Tên khách hàng ',
//             style: titlestyle(),
//             children: const <TextSpan>[
//               TextSpan(text: '*', style:TextStyle(fontFamily: "Roboto",fontSize: 12,fontWeight: FontWeight.w500,color: Colors.red) ),
//             ],
//           ),
//         ),
//         SizedBox(
//           height: AppValue.heights * 0.005,
//         ),
//         Container(
//           width: double.infinity,
//           height: AppValue.heights * 0.05,
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(5),
//               border: Border.all(color: HexColor("#BEB4B4"))),
//           child: Padding(
//             padding: EdgeInsets.only(left: 10),
//             child: Container(
//               margin: EdgeInsets.symmetric(vertical: 10),
//               child: TextFormField(
//                 decoration: InputDecoration(
//                   hintText: "Nhập tên khách hàng",
//                   hintStyle: hintTextStyle(),
//                   focusedBorder: InputBorder.none,
//                   enabledBorder: InputBorder.none,
//                   disabledBorder: InputBorder.none,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//   TextStyle hintTextStyle() => TextStyle(fontFamily: "Roboto",fontSize: 11,fontWeight: FontWeight.w500,color: HexColor("#838A91"));
//   TextStyle titlestyle() => TextStyle(fontFamily: "Roboto",fontSize: 12,fontWeight: FontWeight.w500,color:HexColor("#697077"));
// }
