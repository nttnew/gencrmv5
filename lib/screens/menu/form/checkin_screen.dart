import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gen_crm/bloc/checkin_bloc/checkin_bloc.dart';
import 'package:gen_crm/screens/menu/widget/widget_label.dart';
import 'package:gen_crm/src/models/model_generator/add_customer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import '../../../l10n/key_text.dart';
import '../../../src/app_const.dart';
import '../../../src/src_index.dart';
import '../../../widgets/appbar_base.dart';
import '../../../widgets/btn_save.dart';
import '../../../widgets/loading_api.dart';
import '../../../widgets/location_base.dart';
import '../../../widgets/widget_text.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({Key? key}) : super(key: key);

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  late final BehaviorSubject<String> nameLocation;
  late final TextEditingController controllerNote;
  String id = Get.arguments[0];
  String module = Get.arguments[1];
  String type = Get.arguments[2];
  Position? position;
  late final CheckInBloc _blocCheckIn;

  getNameLocation() async {
    Loading().showLoading();
    position = await determinePosition(context);
    if (position != null) {
      nameLocation.add(LOADING);
      try {
        final location = await getLocationName(
            position?.latitude ?? 0, position?.longitude ?? 0);
        nameLocation.add(location);
        Loading().popLoading();
      } catch (e) {
        Loading().popLoading();
        ShowDialogCustom.showDialogBase(
          title: getT(KeyT.notification),
          content: getT(KeyT.an_error_occurred),
        );
      }
    }
  }

  @override
  void initState() {
    _blocCheckIn =
        CheckInBloc(userRepository: CheckInBloc.of(context).userRepository);
    nameLocation = BehaviorSubject.seeded('');
    controllerNote = TextEditingController();
    nameLocation.listen((value) {
      if (value != '' && value != LOADING && controllerNote.text != value) {
        controllerNote.text = value;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isCheckIn = type == TypeCheckIn.CHECK_IN;
    return BlocListener<CheckInBloc, CheckInState>(
      bloc: _blocCheckIn,
      listener: (BuildContext context, state) {
        if (state is SuccessCheckInState) {
          Loading().popLoading();
          ShowDialogCustom.showDialogBase(
            title: getT(KeyT.notification),
            content: getT(KeyT.new_data_added_successfully),
            onTap1: () {
              Navigator.of(context)
                ..pop()
                ..pop(true);
            },
          );
        } else if (state is ErrorCheckInState) {
          Loading().popLoading();
          ShowDialogCustom.showDialogBase(
            title: getT(KeyT.notification),
            content: state.msg,
          );
        }
      },
      child: Scaffold(
        backgroundColor: COLORS.WHITE,
        appBar: AppbarBaseNormal(
          isCheckIn ? getT(KeyT.check_in) : getT(KeyT.check_out),
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          child: StreamBuilder<String>(
            stream: nameLocation,
            builder: (context, snapshot) {
              final location = snapshot.data ?? '';
              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: [
                              WidgetText(
                                title: getT(KeyT.your_position),
                                style: AppStyle.DEFAULT_18_BOLD,
                              ),
                              WidgetText(
                                title: '*',
                                style: AppStyle.DEFAULT_18_BOLD.copyWith(
                                  color: COLORS.RED,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (location != '') ...[
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            children: [
                              Container(
                                height: 16,
                                width: 16,
                                child: SvgPicture.asset(
                                  ICONS.IC_LOCATION_SVG,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              location != LOADING
                                  ? Expanded(
                                      child: WidgetText(
                                          title: location,
                                          style: AppStyle.DEFAULT_14W600),
                                    )
                                  : SizedBox(
                                      height: 12,
                                      width: 12,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1.4,
                                      ),
                                    ),
                            ],
                          ),
                        ],
                        AppValue.vSpaceSmall,
                        if (location == '')
                          _buttonCheck(
                            isCheckIn
                                ? getT(KeyT.check_in)
                                : getT(KeyT.check_out),
                            () async {
                              await getNameLocation();
                            },
                          ),
                        if (location != '')
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buttonCheck(
                                isCheckIn
                                    ? getT(KeyT.check_in_again)
                                    : getT(KeyT.check_out_again),
                                () async {
                                  await getNameLocation();
                                },
                                backGround: COLORS.TEXT_BLUE_BOLD,
                              ),
                              AppValue.hSpace10,
                              _buttonCheck(
                                getT(KeyT.delete),
                                () {
                                  nameLocation.add('');
                                },
                                backGround: COLORS.RED,
                              ),
                            ],
                          ),
                        AppValue.vSpaceSmall,
                        if (location != '') ...[
                          Container(
                            child: TextFormField(
                              textCapitalization: TextCapitalization.sentences,
                              controller: controllerNote,
                              style: AppStyle.DEFAULT_14_BOLD,
                              onChanged: (text) {},
                              decoration: InputDecoration(
                                contentPadding: paddingBaseForm,
                                label: WidgetLabelPo(
                                  data: CustomerIndividualItemData.two(
                                    field_label: getT(KeyT.location),
                                    field_require: 1,
                                  ),
                                ),
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                            ),
                          ),
                        ],
                        AppValue.vSpaceSmall,
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ButtonSave(
                          onTap: () {
                            if (controllerNote.text.trim() == '') {
                              ShowDialogCustom.showDialogBase(
                                title: getT(KeyT.notification),
                                content:
                                    getT(KeyT.please_enter_all_required_fields),
                              );
                            } else {
                              _blocCheckIn.add(
                                SaveCheckIn(
                                  '${position?.longitude ?? ''}',
                                  '${position?.latitude ?? ''}',
                                  controllerNote.text,
                                  id,
                                  module,
                                  type,
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  _buttonCheck(
    String title,
    Function onTap, {
    Color? backGround,
  }) {
    bool isBackG = backGround != null;
    return ElevatedButton(
      onPressed: () {
        onTap();
      },
      style: ElevatedButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        backgroundColor: isBackG ? COLORS.WHITE : COLORS.TEXT_COLOR,
        minimumSize: Size(0, 0),
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        shape: RoundedRectangleBorder(
          side: isBackG
              ? BorderSide(
                  color: backGround,
                )
              : BorderSide.none,
          borderRadius: BorderRadius.all(
            Radius.circular(
              16,
            ),
          ),
        ),
      ),
      child: WidgetText(
        title: title,
        style: AppStyle.DEFAULT_14W600.copyWith(
          color: backGround ?? COLORS.WHITE,
        ),
      ),
    );
  }
}
