import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as Dio;
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/get_infor_acc/get_infor_acc_bloc.dart';
import 'package:gen_crm/bloc/infor/infor_bloc.dart';
import 'package:gen_crm/bloc/information_account/information_account_bloc.dart';
import 'package:gen_crm/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as Path;
import 'package:get/get.dart';
import 'package:formz/formz.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../src/models/model_generator/login_response.dart';
import '../../../../src/src_index.dart';
import '../../../../storages/share_local.dart';

class InformationAccount extends StatefulWidget {
  const InformationAccount({Key? key}) : super(key: key);

  @override
  State<InformationAccount> createState() => _InformationAccountState();
}

class _InformationAccountState extends State<InformationAccount> {
  String name="";
  String address="";
  File? image;


  Future getImageCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);

      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Error: $e');
    }
  }

  Future getImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return;
      print("AnhThuVien${image.path}");
      final imageTemp = File(image.path);

      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Error: $e');
    }
  }


  final _nameFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();
  late String initEmail ;
  late String initPhone;
  late String initFullName ;
  late String initAddress;
  late String urlAvatar;
  @override
  void initState()  {
    GetInforAccBloc.of(context).add(InitGetInforAcc());

    _phoneFocusNode.addListener(() {
      if (!_phoneFocusNode.hasFocus) {
        context.read<InforAccBloc>().add(PhoneUnfocused());
      }
    });
    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        context.read<InforAccBloc>().add(EmailUnfocused());
      }
    });



    super.initState();
  }

  @override
  void didChangeDependencies() {

  }


  @override
  void dispose() {
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: COLORS.PRIMARY_COLOR,
        title: Text(
          MESSAGES.INFORMATION_ACCOUNT,
          style: AppStyle.DEFAULT_18_BOLD,
        ),
        leading: _buildBack(),
        toolbarHeight: AppValue.heights * 0.1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: BlocListener<InforAccBloc, InforAccState>(
        listener: (context, state) {
          if (state.status.isSubmissionSuccess) {
            GetSnackBarUtils.removeSnackBar();
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return WidgetDialog(
                  onTap1: (){
                    GetInforAccBloc.of(context).add(InitGetInforAcc());
                    AppNavigator.navigateBack();
                  },
                  textButton1: "OK",
                  title: MESSAGES.SUCCESS,
                  content: state.message,
                );
              },
            );
          }
          if (state.status.isSubmissionInProgress) {
            GetSnackBarUtils.createProgress();
          }
          if (state.status.isSubmissionFailure) {
            GetSnackBarUtils.removeSnackBar();
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return WidgetDialog(
                  title: MESSAGES.NOTIFICATION,
                  content: state.message,
                );
              },
            );
            //GetSnackBarUtils.createFailure(message: state.message);
          }
        },
        child: BlocBuilder<GetInforAccBloc,GetInforAccState>(

          builder:(context,state){


            if(state is UpdateGetInforAccState){
              final bloc = InforAccBloc.of(context);
              initEmail = state.inforAcc.email ?? "";
              initFullName = state.inforAcc.fullname ?? "";
              initAddress = state.inforAcc.address ?? "";
              initPhone = state.inforAcc.phone ?? "";
              urlAvatar = state.inforAcc.avatar ?? "";
              bloc.add(EmailChanged(initEmail));
              bloc.add(PhoneChanged(initPhone));
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppValue.vSpaceSmall,
                  GestureDetector(
                    onTap: () {
                      showCupertinoModalPopup(
                          context: Get.context!,
                          builder: (context) => CupertinoActionSheet(
                              title: Text('Ảnh đại diện'),
                              cancelButton: CupertinoActionSheetAction(
                                child: Text('Huỷ'),
                                onPressed: () {
                                  AppNavigator.navigateBack();
                                },
                              ),
                              actions: [
                                CupertinoActionSheetAction(
                                  onPressed: () async {
                                    Get.back();
                                    getImage();
                                  },
                                  child: Text('Chọn ảnh có sẵn'),
                                ),
                                CupertinoActionSheetAction(
                                  onPressed: () async {
                                    Get.back();
                                    getImageCamera();
                                  },
                                  child: Text('Chụp ảnh mới'),
                                )
                              ]));
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        AspectRatio(
                          aspectRatio: 3.8,
                          child: image != null
                              ? Center(
                            child: ClipOval(
                              child: Image.file(
                                image!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                              :  Center(
                            child: ClipOval(
                              child: Image.network(
                                urlAvatar,
                                fit: BoxFit.cover,
                                width: 100,
                                height: 100,
                              ),
                            ),
                          )

                          ,
                        ),
                        Positioned(
                            left: AppValue.widths * 0.55,
                            top: AppValue.heights * 0.1,
                            child: Image.asset('assets/icons/mayanh.png'))
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Họ và tên',
                          style: AppStyle.DEFAULT_16.copyWith(color: COLORS.GREY),
                        ),
                        SizedBox(height: 15,),
                        _buildFullNameField(bloc),
                        AppValue.vSpaceSmall,
                        Text('Số điện thoại',
                            style: AppStyle.DEFAULT_16.copyWith(color: COLORS.GREY)),
                        SizedBox(height: 15,),
                        _buildPhoneField(bloc),
                        AppValue.vSpaceSmall,
                        Text('Email',
                            style: AppStyle.DEFAULT_16.copyWith(color: COLORS.GREY)),
                        SizedBox(height: 15,),
                        _buildEnailField(bloc),
                        AppValue.vSpaceSmall,
                        Text('Địa chỉ',
                            style: AppStyle.DEFAULT_16.copyWith(color: COLORS.GREY)),
                        SizedBox(height: 15,),
                        _buildAddressField(bloc)
                      ],
                    ),
                  ),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: BlocBuilder<InforAccBloc,InforAccState>(
                          builder:(context,state){
                            return  WidgetButton
                              (
                                onTap: () async {
                                  if(state.status.isValidated) {

                                    if(image!= null){
                                      bloc.add(FormInforAccSubmitted(image!, name, address));
                                    }
                                    else{
                                      bloc.add(FormInforAccNoAvatarSubmitted(name, address));
                                    }

                                  }
                                  else{
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return const WidgetDialog(
                                          title: MESSAGES.NOTIFICATION,
                                          content: 'Kiểm tra lại thông tin',
                                        );
                                      },
                                    );
                                  }

                                },
                                height: 35,
                                width: 120,
                                padding: EdgeInsets.only(
                                    right: 20, bottom: 20, top: AppValue.heights * 0.2),
                                text: MESSAGES.SAVE,
                                textStyle: AppStyle.DEFAULT_14.copyWith(
                                    fontWeight: FontWeight.w700, color: Colors.white),
                                backgroundColor: Color(0xffF1A400));
                          }

                      )
                  )

                ],
              );
            }
            else if(state is Error){
              return Center(
                child: WidgetText(
                  title: 'Lỗi kết nối ',
                  style: AppStyle.DEFAULT_18_BOLD,
                ),
              );
            }else{
              return Container();
            }
          },

        ),
      )),
    );
  }

  _buildBack() {
    return IconButton(
      onPressed: () {
        AppNavigator.navigateBack();
      },
      icon: Image.asset(
        ICONS.ICON_BACK,
        height: 28,
        width: 28,
        color: COLORS.BLACK,
      ),
    );
  }

  _buildFullNameField(InforAccBloc bloc) {
    return BlocBuilder<InforAccBloc,InforAccState>(
        builder: (context,state) {
          return GestureDetector(
            onTap: null,
            child: SizedBox(
              height: 30,
              child: TextFormField(
                onChanged: (value){
                   name= value;
                },
                focusNode: _nameFocusNode,
                textInputAction: TextInputAction.next,
                initialValue: initFullName,
                style: AppStyle.DEFAULT_16
                    .copyWith(
                    fontFamily: 'Roboto', fontWeight: FontWeight.w500),
              ),
            ),
          );
        });
    }


  _buildPhoneField(InforAccBloc bloc) {
    return BlocBuilder<InforAccBloc,InforAccState>(
        builder: (context,state)
    {
      return GestureDetector(
        onTap: null,
        child: SizedBox(
          height: 30,
          child: TextFormField(
            keyboardType: TextInputType.number,
            onChanged: (value) =>

                bloc.add(PhoneChanged(value)),
            decoration: InputDecoration(
              errorText: state.phone.invalid?MESSAGES.PHONE_ERROR:null
            ),
            focusNode: _phoneFocusNode,
            textInputAction: TextInputAction.next,
            initialValue: initPhone,
            style: AppStyle.DEFAULT_16
                .copyWith(fontFamily: 'Roboto', fontWeight: FontWeight.w500),
          ),
        ),
      );
    }
    );
    }
    _buildEnailField(InforAccBloc bloc) {
    return BlocBuilder<InforAccBloc,InforAccState>(
        builder: (context,state)
    {
      return GestureDetector(
        onTap: null,
        child: SizedBox(
          height: 30,
          child: TextFormField(
            decoration: InputDecoration(
              errorText: state.email.invalid?MESSAGES.EMAIL_ERROR:null,
            ),
            onChanged: (value) =>
                bloc.add(EmailChanged( value)),
            focusNode: _emailFocusNode,
            textInputAction: TextInputAction.next,
            initialValue: initEmail,
            style: AppStyle.DEFAULT_16
                .copyWith(fontFamily: 'Roboto', fontWeight: FontWeight.w500),
          ),
        ),
      );
    }
    );
  }

  _buildAddressField(InforAccBloc bloc) {
    return GestureDetector(
      onTap: null,
      child: SizedBox(
        height: 30,
        child: TextFormField(
          onChanged: (value){
            address = value;
          },

          textInputAction: TextInputAction.next,
          initialValue: initAddress,
          style: AppStyle.DEFAULT_16
              .copyWith(fontFamily: 'Roboto', fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
