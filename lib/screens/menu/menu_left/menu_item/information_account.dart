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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../src/src_index.dart';
import '../../../../storages/share_local.dart';
import '../../../../widgets/appbar_base.dart';

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
      appBar: AppbarBaseNormal(
          AppLocalizations.of(Get.context!)?.account_information ?? ''),
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
              title: AppLocalizations.of(Get.context!)?.success,
              content: state.message,
            );
          }
          if (state.status.isSubmissionInProgress) {
            GetSnackBarUtils.createProgress();
          }
          if (state.status.isSubmissionFailure) {
            GetSnackBarUtils.removeSnackBar();
            ShowDialogCustom.showDialogBase(
              title: AppLocalizations.of(Get.context!)?.notification,
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
                                  title: Text(AppLocalizations.of(Get.context!)
                                          ?.avatar ??
                                      ''),
                                  cancelButton: CupertinoActionSheetAction(
                                    child: Text(
                                        AppLocalizations.of(Get.context!)
                                                ?.cancel ??
                                            ''),
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
                                      child: Text(
                                          AppLocalizations.of(Get.context!)
                                                  ?.pick_photo ??
                                              ''),
                                    ),
                                    CupertinoActionSheetAction(
                                      onPressed: () async {
                                        Get.back();
                                        getImageCamera();
                                      },
                                      child: Text(
                                          AppLocalizations.of(Get.context!)
                                                  ?.new_photo_shoot ??
                                              ''),
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
                          AppLocalizations.of(Get.context!)?.full_name ?? '',
                          style:
                              AppStyle.DEFAULT_16.copyWith(color: COLORS.GREY),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        _buildFullNameField(bloc),
                        AppValue.vSpaceSmall,
                        Text(
                            AppLocalizations.of(Get.context!)?.number_phone ??
                                '',
                            style: AppStyle.DEFAULT_16
                                .copyWith(color: COLORS.GREY)),
                        SizedBox(
                          height: 15,
                        ),
                        _buildPhoneField(bloc),
                        AppValue.vSpaceSmall,
                        Text(AppLocalizations.of(Get.context!)?.email ?? '',
                            style: AppStyle.DEFAULT_16
                                .copyWith(color: COLORS.GREY)),
                        SizedBox(
                          height: 15,
                        ),
                        _buildEnailField(bloc),
                        AppValue.vSpaceSmall,
                        Text(AppLocalizations.of(Get.context!)?.address ?? '',
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
                                  title: AppLocalizations.of(Get.context!)
                                      ?.notification,
                                  content: AppLocalizations.of(Get.context!)
                                      ?.check_the_information,
                                );
                              }
                            },
                            height: 35,
                            width: 120,
                            padding: EdgeInsets.only(
                                right: 20,
                                bottom: 20,
                                top: AppValue.heights * 0.1),
                            text: AppLocalizations.of(Get.context!)?.save,
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
                  title: AppLocalizations.of(Get.context!)?.an_error_occurred,
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
                .copyWith(fontFamily: 'Quicksand', fontWeight: FontWeight.w600),
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
                errorText: state.phone.invalid
                    ? AppLocalizations.of(Get.context!)?.invalid_phone_number
                    : null),
            focusNode: _phoneFocusNode,
            textInputAction: TextInputAction.next,
            initialValue: initPhone,
            style: AppStyle.DEFAULT_16
                .copyWith(fontFamily: 'Quicksand', fontWeight: FontWeight.w600),
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
              errorText: state.email.invalid
                  ? AppLocalizations.of(Get.context!)?.this_account_is_invalid
                  : null,
            ),
            onChanged: (value) => bloc.add(EmailChanged(value)),
            focusNode: _emailFocusNode,
            textInputAction: TextInputAction.next,
            initialValue: initEmail,
            style: AppStyle.DEFAULT_16
                .copyWith(fontFamily: 'Quicksand', fontWeight: FontWeight.w600),
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
              .copyWith(fontFamily: 'Quicksand', fontWeight: FontWeight.w600),
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
                        title:
                            "${AppLocalizations.of(Get.context!)?.login_with_fingerprint_face_id}: ",
                        style:
                            AppStyle.DEFAULT_16.copyWith(color: COLORS.GREY)),
                    !(snapshot.data ?? false)
                        ? WidgetText(
                            title: AppLocalizations.of(Get.context!)?.no,
                            style: AppStyle.DEFAULT_16.copyWith(
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.w600))
                        : WidgetText(
                            title: AppLocalizations.of(Get.context!)?.yes,
                            style: AppStyle.DEFAULT_16.copyWith(
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.w600)),
                  ],
                ),
                Switch(
                  value: snapshot.data ?? false,
                  onChanged: (value) {
                    if (!(supportBiometric.data ?? false)) {
                      ShowDialogCustom.showDialogBase(
                        title: AppLocalizations.of(Get.context!)?.notification,
                        content: AppLocalizations.of(Get.context!)
                            ?.the_device_has_not_setup_fingerprint_face,
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
      final String reason =
          AppLocalizations.of(Get.context!)?.login_with_fingerprint_face_id ??
              '';
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
          title: AppLocalizations.of(Get.context!)?.notification,
          content:
              AppLocalizations.of(Get.context!)?.login_fail_please_try_again ??
                  '',
        );
      }
    } catch (e) {
      return;
    }
  }
}
