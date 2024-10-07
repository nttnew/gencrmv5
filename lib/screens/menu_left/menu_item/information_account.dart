import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/get_infor_acc/get_infor_acc_bloc.dart';
import 'package:gen_crm/bloc/information_account/information_account_bloc.dart';
import 'package:gen_crm/src/extensionss/common_ext.dart';
import 'package:gen_crm/widgets/btn_thao_tac.dart';
import 'package:gen_crm/widgets/form_input/form_input.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:formz/formz.dart';
import '../../../../l10n/key_text.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/appbar_base.dart';
import '../../widget/error_item.dart';

class InformationAccount extends StatefulWidget {
  const InformationAccount({Key? key}) : super(key: key);

  @override
  State<InformationAccount> createState() => _InformationAccountState();
}

class _InformationAccountState extends State<InformationAccount> {
  String name = '';
  String address = '';
  String phone = '';
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

  final _emailFocusNode = FocusNode();
  late String initEmail;
  late String initPhone;
  late String initFullName;
  late String initAddress;
  late String urlAvatar;

  @override
  void initState() {
    GetInfoAccBloc.of(context).add(InitGetInfoAcc(isLoading: true));
    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        context.read<InfoAccBloc>().add(EmailUnfocused());
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarBaseNormal(getT(KeyT.account_information)),
      body: GestureDetector(
        onTap: () => closeKey(),
        child: SingleChildScrollView(
            child: BlocListener<InfoAccBloc, InfoAccState>(
          listener: (context, state) {
            if (state.status.isSubmissionSuccess) {
              GetSnackBarUtils.removeSnackBar();
              ShowDialogCustom.showDialogBase(
                onTap1: () {
                  GetInfoAccBloc.of(context).add(InitGetInfoAcc(isLoading: true));
                  AppNavigator.navigateBack();
                },
                title: getT(KeyT.success),
                content: state.message,
              );
            }
            if (state.status.isSubmissionInProgress) {
              GetSnackBarUtils.createProgress();
            }
            if (state.status.isSubmissionFailure) {
              GetSnackBarUtils.removeSnackBar();
              ShowDialogCustom.showDialogBase(
                title: getT(KeyT.notification),
                content: state.message,
              );
            }
          },
          child: BlocBuilder<GetInfoAccBloc, GetInfoAccState>(
            builder: (context, state) {
              if (state is UpdateGetInfoAccState) {
                final bloc = InfoAccBloc.of(context);
                initEmail = state.infoAcc.email ?? '';
                initFullName = state.infoAcc.fullname ?? '';
                initAddress = state.infoAcc.address ?? '';
                initPhone = state.infoAcc.phone ?? '';
                urlAvatar = state.infoAcc.avatar ?? '';
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
                                    title: Text(getT(KeyT.avatar)),
                                    cancelButton: CupertinoActionSheetAction(
                                      child: Text(getT(KeyT.cancel)),
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
                                          getT(KeyT.pick_photo),
                                        ),
                                      ),
                                      CupertinoActionSheetAction(
                                        onPressed: () async {
                                          Get.back();
                                          getImageCamera();
                                        },
                                        child: Text(getT(KeyT.new_photo_shoot)),
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
                                    child: Container(
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: boxShadowVip,
                                        color: Colors.white,
                                      ),
                                      child: Image.file(
                                        image!,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: Container(
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: boxShadowVip,
                                        color: Colors.white,
                                      ),
                                      child: Image.network(
                                        urlAvatar,
                                        fit: BoxFit.contain,
                                        width: 100,
                                        height: 100,
                                        errorBuilder: (_, __, ___) => Container(
                                          width: 100,
                                          height: 100,
                                          child: Image.asset(
                                            ICONS.IC_PROFILE_ERROR_PNG,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                          Positioned(
                            left: AppValue.widths * 0.55,
                            top: AppValue.heights * 0.1,
                            child: Image.asset(
                              ICONS.IC_MAY_ANH_PNG,
                              height: 24,
                              width: 24,
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppValue.vSpaceSmall,
                          _buildFullNameField(bloc),
                          AppValue.vSpaceSmall,
                          _buildPhoneField(bloc),
                          AppValue.vSpaceSmall,
                          _buildEmailField(bloc),
                          AppValue.vSpaceSmall,
                          _buildAddressField(bloc),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: BlocBuilder<InfoAccBloc, InfoAccState>(
                        builder: (context, state) {
                          return ButtonCustom(
                            onTap: () async {
                              await _submit(bloc, state);
                            },
                            title: getT(KeyT.save),
                          );
                        },
                      ),
                    )
                  ],
                );
              } else if (state is Error) {
                return ErrorItem(
                  onPressed: () =>
                      GetInfoAccBloc.of(context).add(InitGetInfoAcc(isLoading: true)),
                  error: getT(KeyT.an_error_occurred),
                );
              } else {
                return SizedBox.shrink();
              }
            },
          ),
        )),
      ),
    );
  }

  _buildFullNameField(InfoAccBloc bloc) {
    return BlocBuilder<InfoAccBloc, InfoAccState>(builder: (context, state) {
      return FormInputBase(
        label: getT(KeyT.full_name),
        onChange: (value) {
          name = value;
        },
        textInputAction: TextInputAction.next,
        initText: initFullName,
      );
    });
  }

  _buildPhoneField(InfoAccBloc bloc) {
    return BlocBuilder<InfoAccBloc, InfoAccState>(builder: (context, state) {
      return FormInputBase(
        label: getT(KeyT.phone),
        onChange: (value) => phone = value,
        textInputType: TextInputType.number,
        textInputAction: TextInputAction.next,
        initText: initPhone,
      );
    });
  }

  _buildEmailField(InfoAccBloc bloc) {
    return BlocBuilder<InfoAccBloc, InfoAccState>(builder: (context, state) {
      return FormInputBase(
        textInputAction: TextInputAction.next,
        label: getT(KeyT.email),
        initText: initEmail,
        errorText:
            state.email.invalid ? getT(KeyT.this_account_is_invalid) : null,
        focusNode: _emailFocusNode,
        onChange: (v) {
          bloc.add(EmailChanged(v));
        },
      );
    });
  }

  _buildAddressField(InfoAccBloc bloc) {
    return FormInputBase(
      textInputAction: TextInputAction.done,
      label: getT(KeyT.address),
      initText: initAddress,
      onChange: (v) {
        address = v;
      },
    );
  }

  Future<void> _submit(InfoAccBloc bloc, InfoAccState state) async {
    closeKey();
    if (state.status.isValidated) {
      if (image != null) {
        bloc.add(FormInfoAccSubmitted(image!, name, address, phone));
      } else {
        bloc.add(FormInfoAccNoAvatarSubmitted(name, address, phone));
      }
    } else {
      ShowDialogCustom.showDialogBase(
        title: getT(KeyT.notification),
        content: getT(KeyT.check_the_information),
      );
    }
  }
}
