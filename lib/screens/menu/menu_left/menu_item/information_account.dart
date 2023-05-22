import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/get_infor_acc/get_infor_acc_bloc.dart';
import 'package:gen_crm/bloc/information_account/information_account_bloc.dart';
import 'package:gen_crm/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:formz/formz.dart';
import 'package:local_auth/local_auth.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../src/src_index.dart';
import '../../../../storages/share_local.dart';

class InformationAccount extends StatefulWidget {
  const InformationAccount({Key? key}) : super(key: key);

  @override
  State<InformationAccount> createState() => _InformationAccountState();
}

class _InformationAccountState extends State<InformationAccount> {
  String name = "";
  String address = "";
  File? image;

  Future getImageCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);

      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      throw e;
    }
  }

  Future getImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return;
      final imageTemp = File(image.path);

      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      throw e;
    }
  }

  final _nameFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  late String initEmail;
  late String initPhone;
  late String initFullName;
  late String initAddress;
  late String urlAvatar;
  String? canLoginWithFingerPrint;
  late final LocalAuthentication auth;
  late final BehaviorSubject<bool> supportBiometric;
  late final BehaviorSubject<bool> fingerPrintIsCheck;

  @override
  void initState() {
    auth = LocalAuthentication();
    fingerPrintIsCheck = BehaviorSubject();
    supportBiometric = BehaviorSubject();
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

    canLoginWithFingerPrint =
        shareLocal.getString(PreferencesKey.LOGIN_FINGER_PRINT);
    if (canLoginWithFingerPrint == null ||
        canLoginWithFingerPrint == "" ||
        canLoginWithFingerPrint == "false") {
      fingerPrintIsCheck.add(false);
    } else {
      if (canLoginWithFingerPrint == "true") {
        fingerPrintIsCheck.add(true);
      }
    }
    checkBiometricEnable();

    super.initState();
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
            ShowDialogCustom.showDialogBase(
              onTap1: () {
                GetInforAccBloc.of(context).add(InitGetInforAcc());
                AppNavigator.navigateBack();
              },
              title: MESSAGES.SUCCESS,
              content: state.message,
            );
          }
          if (state.status.isSubmissionInProgress) {
            GetSnackBarUtils.createProgress();
          }
          if (state.status.isSubmissionFailure) {
            GetSnackBarUtils.removeSnackBar();
            ShowDialogCustom.showDialogBase(
              title: MESSAGES.NOTIFICATION,
              content: state.message,
            );
          }
        },
        child: BlocBuilder<GetInforAccBloc, GetInforAccState>(
          builder: (context, state) {
            if (state is UpdateGetInforAccState) {
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
                mainAxisSize: MainAxisSize.max,
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
                              : Center(
                                  child: ClipOval(
                                    child: Image.network(
                                      urlAvatar,
                                      fit: BoxFit.cover,
                                      width: 100,
                                      height: 100,
                                    ),
                                  ),
                                ),
                        ),
                        Positioned(
                            left: AppValue.widths * 0.55,
                            top: AppValue.heights * 0.1,
                            child: Image.asset(ICONS.IC_MAY_ANH_PNG))
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
                          style:
                              AppStyle.DEFAULT_16.copyWith(color: COLORS.GREY),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        _buildFullNameField(bloc),
                        AppValue.vSpaceSmall,
                        Text('Số điện thoại',
                            style: AppStyle.DEFAULT_16
                                .copyWith(color: COLORS.GREY)),
                        SizedBox(
                          height: 15,
                        ),
                        _buildPhoneField(bloc),
                        AppValue.vSpaceSmall,
                        Text('Email',
                            style: AppStyle.DEFAULT_16
                                .copyWith(color: COLORS.GREY)),
                        SizedBox(
                          height: 15,
                        ),
                        _buildEnailField(bloc),
                        AppValue.vSpaceSmall,
                        Text('Địa chỉ',
                            style: AppStyle.DEFAULT_16
                                .copyWith(color: COLORS.GREY)),
                        SizedBox(
                          height: 15,
                        ),
                        _buildAddressField(bloc),
                        SizedBox(
                          height: 15,
                        ),
                        _buildFingerPrintSwitch()
                      ],
                    ),
                  ),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: BlocBuilder<InforAccBloc, InforAccState>(
                          builder: (context, state) {
                        return WidgetButton(
                            onTap: () async {
                              print('$image!, $name, $address');
                              if (state.status.isValidated) {
                                if (image != null) {
                                  bloc.add(FormInforAccSubmitted(
                                      image!, name, address));
                                } else {
                                  bloc.add(FormInforAccNoAvatarSubmitted(
                                      name, address));
                                }
                              } else {
                                ShowDialogCustom.showDialogBase(
                                  title: MESSAGES.NOTIFICATION,
                                  content: 'Kiểm tra lại thông tin',
                                );
                              }
                            },
                            height: 35,
                            width: 120,
                            padding: EdgeInsets.only(
                                right: 20,
                                bottom: 20,
                                top: AppValue.heights * 0.1),
                            text: MESSAGES.SAVE,
                            textStyle: AppStyle.DEFAULT_14.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                            backgroundColor: Color(0xffF1A400));
                      }))
                ],
              );
            } else if (state is Error) {
              return Center(
                child: WidgetText(
                  title: 'Lỗi kết nối ',
                  style: AppStyle.DEFAULT_18_BOLD,
                ),
              );
            } else {
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
        ICONS.IC_BACK_PNG,
        height: 28,
        width: 28,
        color: COLORS.BLACK,
      ),
    );
  }

  _buildFullNameField(InforAccBloc bloc) {
    return BlocBuilder<InforAccBloc, InforAccState>(builder: (context, state) {
      return GestureDetector(
        onTap: null,
        child: SizedBox(
          height: 30,
          child: TextFormField(
            onChanged: (value) {
              name = value;
            },
            focusNode: _nameFocusNode,
            textInputAction: TextInputAction.next,
            initialValue: initFullName,
            style: AppStyle.DEFAULT_16
                .copyWith(fontFamily: 'Quicksand', fontWeight: FontWeight.w500),
          ),
        ),
      );
    });
  }

  _buildPhoneField(InforAccBloc bloc) {
    return BlocBuilder<InforAccBloc, InforAccState>(builder: (context, state) {
      return GestureDetector(
        onTap: null,
        child: SizedBox(
          height: 30,
          child: TextFormField(
            keyboardType: TextInputType.number,
            onChanged: (value) => bloc.add(PhoneChanged(value)),
            decoration: InputDecoration(
                errorText: state.phone.invalid ? MESSAGES.PHONE_ERROR : null),
            focusNode: _phoneFocusNode,
            textInputAction: TextInputAction.next,
            initialValue: initPhone,
            style: AppStyle.DEFAULT_16
                .copyWith(fontFamily: 'Quicksand', fontWeight: FontWeight.w500),
          ),
        ),
      );
    });
  }

  _buildEnailField(InforAccBloc bloc) {
    return BlocBuilder<InforAccBloc, InforAccState>(builder: (context, state) {
      return GestureDetector(
        onTap: null,
        child: SizedBox(
          height: 30,
          child: TextFormField(
            decoration: InputDecoration(
              errorText: state.email.invalid ? MESSAGES.EMAIL_ERROR : null,
            ),
            onChanged: (value) => bloc.add(EmailChanged(value)),
            focusNode: _emailFocusNode,
            textInputAction: TextInputAction.next,
            initialValue: initEmail,
            style: AppStyle.DEFAULT_16
                .copyWith(fontFamily: 'Quicksand', fontWeight: FontWeight.w500),
          ),
        ),
      );
    });
  }

  _buildAddressField(InforAccBloc bloc) {
    return GestureDetector(
      onTap: null,
      child: SizedBox(
        height: 30,
        child: TextFormField(
          onChanged: (value) {
            address = value;
          },
          textInputAction: TextInputAction.next,
          initialValue: initAddress,
          style: AppStyle.DEFAULT_16
              .copyWith(fontFamily: 'Quicksand', fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  _buildFingerPrintSwitch() {
    return StreamBuilder<bool>(
      stream: supportBiometric,
      builder: (_, supportBiometric) {
        return StreamBuilder<bool>(
          stream: fingerPrintIsCheck,
          builder: (context, snapshot) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    WidgetText(
                        title: "Đăng nhập vân tay, khuôn mặt: ",
                        style:
                            AppStyle.DEFAULT_16.copyWith(color: COLORS.GREY)),
                    !(snapshot.data ?? false)
                        ? WidgetText(
                            title: "NO",
                            style: AppStyle.DEFAULT_16.copyWith(
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.w500))
                        : WidgetText(
                            title: "YES",
                            style: AppStyle.DEFAULT_16.copyWith(
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.w500)),
                  ],
                ),
                Switch(
                  value: snapshot.data ?? false,
                  onChanged: (value) {
                    if (!(supportBiometric.data ?? false)) {
                      ShowDialogCustom.showDialogBase(
                        title: MESSAGES.NOTIFICATION,
                        content: "Thiết bị chưa thiết lập vân tay, khuôn mặt",
                      );
                    } else {
                      useBiometric(value: value);
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> checkBiometricEnable() async {
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    if (!canAuthenticateWithBiometrics) {
      return;
    }

    final List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();
    if (availableBiometrics.isNotEmpty) {
      supportBiometric.add(true);
    }
  }

  Future<void> useBiometric({required bool value}) async {
    if (!value) {
      fingerPrintIsCheck.sink.add(false);
      shareLocal.putString(PreferencesKey.LOGIN_FINGER_PRINT, "false");
      return;
    }
    try {
      final String reason = "Đăng nhập vân tay, khuôn mặt";
      final bool didAuthenticate = await auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          useErrorDialogs: false,
          stickyAuth: true,
        ),
      );
      if (didAuthenticate) {
        fingerPrintIsCheck.add(true);
        shareLocal.putString(PreferencesKey.LOGIN_FINGER_PRINT, "true");
      } else {
        ShowDialogCustom.showDialogBase(
          title: MESSAGES.NOTIFICATION,
          content: "Đăng nhập thất bại bạn vui lòng thử lại",
        );
      }
    } catch (e) {
      return;
    }
  }
}
