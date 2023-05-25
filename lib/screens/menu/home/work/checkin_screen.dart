import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gen_crm/bloc/checkin_bloc/checkin_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../bloc/support/detail_support_bloc.dart';
import '../../../../bloc/work/detail_work_bloc.dart';
import '../../../../src/app_const.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/loading_api.dart';
import '../../../../widgets/location_base.dart';
import '../../../../widgets/widget_text.dart';

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
  Position? position;

  getNameLocation() async {
    LoadingApi().pushLoading();
    position = await determinePosition(context);
    if (position != null) {
      nameLocation.add(LOADING);
      final location = await getLocationName(
          position?.latitude ?? 0, position?.longitude ?? 0);
      nameLocation.add(location);
    }
    LoadingApi().popLoading();
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
            title: MESSAGES.NOTIFICATION,
            content: "Thêm mới check in thành công",
            onTap1: () {
              Get.back();
              if (module == ModuleMy.CSKH) {
                DetailSupportBloc.of(context)
                    .add(InitGetDetailSupportEvent(id));
              } else if (module == ModuleMy.CONG_VIEC) {
                DetailWorkBloc.of(context)
                    .add(InitGetDetailWorkEvent(int.parse(id)));
              }
              Navigator.pop(context);
            },
          );
        } else if (state is ErrorCheckInState) {
          LoadingApi().popLoading();
          ShowDialogCustom.showDialogBase(
            title: MESSAGES.NOTIFICATION,
            content: state.msg,
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: GestureDetector(
          onTap: () {
            if (controllerNote.text.trim() == '') {
              ShowDialogCustom.showDialogBase(
                title: MESSAGES.NOTIFICATION,
                content: "Hãy nhập đủ các trường bắt buộc (*)",
              );
            } else {
              CheckInBloc.of(context).add(SaveCheckIn(
                '${position?.longitude ?? ''}',
                '${position?.latitude ?? ''}',
                controllerNote.text,
                id,
                module,
              ));
            }
          },
          child: Container(
            height: AppValue.widths * 0.1,
            width: AppValue.widths * 0.25,
            decoration: BoxDecoration(
                color: HexColor("#F1A400"),
                borderRadius: BorderRadius.circular(20.5)),
            child: Center(
                child: Text(
              "Lưu",
              style: TextStyle(color: Colors.white),
            )),
          ),
        ),
        appBar: AppBar(
          toolbarHeight: AppValue.heights * 0.1,
          backgroundColor: HexColor("#D0F1EB"),
          centerTitle: false,
          title: WidgetText(
              title: "Checkin",
              style: AppStyle.DEFAULT_16.copyWith(fontWeight: FontWeight.w700)),
          leading: Padding(
              padding: EdgeInsets.only(left: 30),
              child: InkWell(
                  onTap: () => AppNavigator.navigateBack(),
                  child: Icon(Icons.arrow_back, color: Colors.black))),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(15),
            ),
          ),
        ),
        body: Container(
            padding: EdgeInsets.all(16),
            child: StreamBuilder<String>(
                stream: nameLocation,
                builder: (context, snapshot) {
                  final location = snapshot.data ?? '';
                  return Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            WidgetText(
                                title: 'Vị trí của bạn',
                                style: AppStyle.DEFAULT_18_BOLD),
                            WidgetText(
                                title: '*',
                                style: AppStyle.DEFAULT_18_BOLD
                                    .copyWith(color: Colors.red)),
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
                                            color: COLORS.BLACK)))
                                : SizedBox(
                                    height: 12,
                                    width: 12,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1.4,
                                    )),
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
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                                color: COLORS.TEXT_COLOR,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                                border: Border.all(
                                  color: COLORS.TEXT_COLOR,
                                )),
                            child: WidgetText(
                                title: 'Check in',
                                style: TextStyle(
                                    fontFamily: "Quicksand",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white)),
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
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16)),
                                    border: Border.all(
                                      color: COLORS.TEXT_COLOR,
                                    )),
                                child: WidgetText(
                                    title: 'Check in lại',
                                    style: TextStyle(
                                      fontFamily: "Quicksand",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: COLORS.TEXT_COLOR,
                                    )),
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
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16)),
                                    border: Border.all(
                                      color: Colors.red,
                                    )),
                                child: WidgetText(
                                    title: 'Xoá',
                                    style: TextStyle(
                                        fontFamily: "Quicksand",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.red)),
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
                              text: 'Vị trí',
                              style: titlestyle(),
                              children: <TextSpan>[
                                TextSpan(
                                    text: '*',
                                    style: TextStyle(
                                        fontFamily: "Quicksand",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.red))
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
                              border: Border.all(color: HexColor("#BEB4B4"))),
                          child: Padding(
                            padding:
                                EdgeInsets.only(left: 10, top: 5, bottom: 5),
                            child: Container(
                              child: TextFormField(
                                controller: controllerNote,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
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
                  );
                })),
      ),
    );
  }
}
