import 'package:flutter/material.dart';
import 'package:gen_crm/widgets/widget_dialog.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../src/messages.dart';

Future<Position?> determinePosition(BuildContext context) async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    showDialogPermissionLocation(context, isDevice: true);
    return null;
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      showDialogPermissionLocation(context);
      return null;
    } else if (permission == LocationPermission.deniedForever) {
      showDialogPermissionLocation(context);
      return null;
    }
  }

  return await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.best,
  );
}

void showDialogPermissionLocation(BuildContext context,
        {bool isDevice = false}) =>
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WidgetDialog(
          twoButton: true,
          title: MESSAGES.NOTIFICATION,
          content: 'Bạn chưa cấp quyền truy cập vào vị trí?',
          textButton2: 'Đi đến cài đặt',
          textButton1: 'Ok',
          onTap2: () async {
            if (isDevice) {
              await Geolocator.openLocationSettings();
            } else {
              await Geolocator.openAppSettings();
            }
            Get.back();
          },
          onTap1: () {
            Get.back();
          },
        );
      },
    );
Future<String> getLocationName(double latitude, double longitude) async {
  List<Placemark> placemarks =
      await placemarkFromCoordinates(latitude, longitude);
  print(placemarks.toString());
  print('$latitude+' + '+$longitude');
  return checkData('Số', '${placemarks.first.name},') +
      checkData('', '${placemarks.first.thoroughfare},') +
      checkData('', '${placemarks.first.subAdministrativeArea},') +
      checkData('', '${placemarks.first.administrativeArea},') +
      checkData('', '${placemarks.first.country}');
}

String checkData(String title, String value) {
  return value != '' ? title + ' ' + value : '';
}
