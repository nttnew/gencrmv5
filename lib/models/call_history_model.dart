import 'dart:convert';

import 'package:gen_crm/src/preferences_key.dart';
import 'package:gen_crm/storages/share_local.dart';

class CallHistoryModel {
  String name = '';
  String phone = '';
  String time = '';

  CallHistoryModel({
    this.name = '',
    this.phone = '',
    this.time = '',
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> mapData = {
      'name': this.name,
      'phone': this.phone,
      'time': this.time,
    };
    return mapData;
  }

  CallHistoryModel.fromJson(Map<String, dynamic> json) {
    this.name = json['name'] ?? '';
    this.phone = json['phone'] ?? '';
    this.time = json['time'] ?? '';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CallHistoryModel &&
          runtimeType == other.runtimeType &&
          phone == other.phone;

  @override
  int get hashCode => phone.hashCode;
}

void saveHistoryCall(CallHistoryModel callHistoryModel) {
  final res = shareLocal.getString(PreferencesKey.HISTORY_CALL);

  if (res == null || res == [] || res == '') {
    _saveHistoryCallLocal([callHistoryModel]);
  } else {
    final listDynamic = jsonDecode(res) as List<dynamic>;
    List<CallHistoryModel> listCallHistory =
        listDynamic.map((e) => CallHistoryModel.fromJson(e)).toList();

    _saveHistoryCallLocal([
      ...[callHistoryModel],
      ...listCallHistory
    ]);
  }
}

String getName(String phone) {
  List<CallHistoryModel> listCall = getListHistoryCall();
  for (int i = 0; i < listCall.length; i++) {
    if (listCall[i].phone == phone && listCall[i].name != '') {
      return listCall[i].name;
    }
  }
  return '';
}

List<CallHistoryModel> getListHistoryCall() {
  final res = shareLocal.getString(PreferencesKey.HISTORY_CALL);

  if (res == null || res == [] || res == '') {
    return [];
  }

  final listDynamic = jsonDecode(res) as List<dynamic>;
  List<CallHistoryModel> listCallHistory =
      listDynamic.map((e) => CallHistoryModel.fromJson(e)).toList();

  return listCallHistory;
}

List<CallHistoryModel> searchListHistory(String phone) {
  List<CallHistoryModel> searchList = [];
  List<CallHistoryModel> listCall = getListHistoryCall();
  listCall.forEach((element) {
    if (element.phone.contains(phone)) {
      searchList.add(element);
    }
  });
  return searchList;
}

_saveHistoryCallLocal(List<CallHistoryModel> list) => shareLocal.putString(
    PreferencesKey.HISTORY_CALL,
    jsonEncode(list.map((e) => e.toJson()).toList()));
