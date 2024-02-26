import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gen_crm/bloc/checkin_bloc/checkin_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import '../../../l10n/key_text.dart';
import '../../../src/app_const.dart';
import '../../../src/src_index.dart';
import '../../../widgets/appbar_base.dart';
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

  getNameLocation() async {
    position = await determinePosition(context);
    if (position != null) {
      nameLocation.add(LOADING);
      final location = await getLocationName(
          position?.latitude ?? 0, position?.longitude ?? 0);
      nameLocation.add(location);
    }
  }

  @override
  void initState() {
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
    return BlocListener<CheckInBloc, CheckInState>(
      listener: (BuildContext context, state) {
        if (state is SuccessCheckInState) {
          LoadingApi().popLoading();
          ShowDialogCustom.showDialogBase(
            title: getT(KeyT.notification),
            content: getT(KeyT.new_data_added_successfully),
            onTap1: () {
              Get.back();
              Get.back();
            },
          );
        } else if (state is ErrorCheckInState) {
          LoadingApi().popLoading();
          ShowDialogCustom.showDialogBase(
            title: getT(KeyT.notification),
            content: state.msg,
          );
        }
      },
      child: Scaffold(
        appBar: AppbarBaseNormal(
          getT(KeyT.check_in),
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
                                        style: TextStyle(
                                          fontFamily: "Quicksand",
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: COLORS.BLACK,
                                        ),
                                      ),
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
                        SizedBox(
                          height: 16,
                        ),
                        if (location == '')
                          GestureDetector(
                            onTap: () async {
                              await getNameLocation();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                  color: COLORS.TEXT_COLOR,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(
                                      16,
                                    ),
                                  ),
                                  border: Border.all(
                                    color: COLORS.TEXT_COLOR,
                                  )),
                              child: WidgetText(
                                title: getT(KeyT.check_in),
                                style: TextStyle(
                                  fontFamily: "Quicksand",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: COLORS.WHITE,
                                ),
                              ),
                            ),
                          ),
                        if (location != '')
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  await getNameLocation();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        16,
                                      ),
                                    ),
                                    border: Border.all(
                                      color: COLORS.TEXT_COLOR,
                                    ),
                                  ),
                                  child: WidgetText(
                                    title: getT(KeyT.check_in_again),
                                    style: TextStyle(
                                      fontFamily: "Quicksand",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: COLORS.TEXT_COLOR,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  nameLocation.add('');
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        16,
                                      ),
                                    ),
                                    border: Border.all(
                                      color: COLORS.RED,
                                    ),
                                  ),
                                  child: WidgetText(
                                    title: getT(KeyT.delete),
                                    style: TextStyle(
                                      fontFamily: "Quicksand",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: COLORS.RED,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        SizedBox(
                          height: 16,
                        ),
                        if (location != '') ...[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: RichText(
                              textScaleFactor:
                                  MediaQuery.of(context).textScaleFactor,
                              text: TextSpan(
                                text: getT(KeyT.location),
                                style: AppStyle.DEFAULT_14W600,
                                children: <TextSpan>[
                                  TextSpan(
                                    text: '*',
                                    style: TextStyle(
                                      fontFamily: "Quicksand",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: COLORS.RED,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: COLORS.ffBEB4B4,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: 10,
                                top: 5,
                                bottom: 5,
                              ),
                              child: Container(
                                child: TextFormField(
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  controller: controllerNote,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  onChanged: (text) {},
                                  decoration: InputDecoration(
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    isDense: true,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                        SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (controllerNote.text.trim() == '') {
                            ShowDialogCustom.showDialogBase(
                              title: getT(KeyT.notification),
                              content:
                                  getT(KeyT.please_enter_all_required_fields),
                            );
                          } else {
                            CheckInBloc.of(context).add(
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
                        child: widgetSave(),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
