import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:location/location.dart' as myLocation;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
      title: AppLocalizations.of(Get.context!)?.notification,
      content:
          AppLocalizations.of(Get.context!)?.have_not_granted_location_access,
      textButton2: AppLocalizations.of(Get.context!)?.go_to_setting,
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
  return checkData('${AppLocalizations.of(Get.context!)?.number}',
          '${placemarks.first.name},') +
      checkData('', '${placemarks.first.thoroughfare},') +
      checkData('', '${placemarks.first.subAdministrativeArea},') +
      checkData('', '${placemarks.first.administrativeArea}');
}

String checkData(String title, String value) {
  return value != '' ? title + ' ' + value : '';
}
