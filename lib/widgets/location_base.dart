import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:location/location.dart' as myLocation;
import '../src/messages.dart';
import 'show_dialog.dart';

Future<Position?> determinePosition(BuildContext context) async {
  LocationPermission permission;
  myLocation.Location location = new myLocation.Location();
  bool _serviceEnabled;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return null;
    }
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
    ShowDialogCustom.showDialogBase(
      title: MESSAGES.NOTIFICATION,
      content: 'Bạn chưa cấp quyền truy cập vào vị trí?',
      textButton2: 'Đi đến cài đặt',
      onTap2: () async {
        if (isDevice) {
          await Geolocator.openLocationSettings();
        } else {
          await Geolocator.openAppSettings();
        }
        Get.back();
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
      checkData('', '${placemarks.first.administrativeArea}');
}

String checkData(String title, String value) {
  return value != '' ? title + ' ' + value : '';
}
