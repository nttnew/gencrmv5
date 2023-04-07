// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_dotenv/flutter_dotenv.dart'; // ignore: import_of_legacy_library_into_null_safe
import 'dart:core';
import 'package:gen_crm/src/preferences_key.dart';
import 'package:gen_crm/storages/storages.dart';

class EventRepositoryStorage implements EventRepository {
  const EventRepositoryStorage();
  @override
  Future<String> loadEvent() async {
    final response = await shareLocal.getString("DEV");
    if (response != null) {
      return response;
    } else {
      final response = await shareLocal.getString("DEV");
      return response;
    }
  }

  @override
  Future saveEvent(String todos) async {
    await shareLocal.putString("DEV", todos.toString());
  }

  @override
  Future<String> loadUser() async {
    final response = await shareLocal.getString(PreferencesKey.USER);
    if (response != null) {
      return response;
    } else {
      await shareLocal.putString(
          PreferencesKey.USER, dotenv.env[PreferencesKey.TOKEN]!);
      return await shareLocal.getString(PreferencesKey.USER);
    }
  }

  @override
  Future saveUser(String user) async {
    await shareLocal.putString(PreferencesKey.USER, user.toString());
  }

  @override
  Future<String> loadInforUser() async {
    final response = await shareLocal.getString(PreferencesKey.INFOR_USER);
    if (response != null) {
      return response;
    } else {
      await shareLocal.putString(PreferencesKey.INFOR_USER, "");
      return await shareLocal.getString(PreferencesKey.USER);
    }
  }

  @override
  Future saveInforUser(String inforUser) async {
    await shareLocal.putString(PreferencesKey.USER, inforUser.toString());
  }

  @override
  Future saveUserID(String userID) async {
    await shareLocal.putString(PreferencesKey.USER_ID, userID);
  }
}
