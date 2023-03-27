import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../api_resfull/user_repository.dart';
import '../../src/base.dart';
import '../../src/messages.dart';
import '../../src/models/model_generator/clue.dart';
import '../../src/models/model_generator/list_notification.dart';
import '../../src/preferences_key.dart';
import '../../storages/share_local.dart';
import '../../widgets/loading_api.dart';
import '../../src/messages.dart';

part 'unread_list_notifi_event.dart';
part 'unread_list_notifi_state.dart';

class GetListUnReadNotifiBloc
    extends Bloc<ListUnReadNotifiEvent, UnReadListNotifiState> {
  final UserRepository userRepository;

  GetListUnReadNotifiBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetUnReadListNotifiState()) {
    getVersionInfoCar();
  }

  @override
  Stream<UnReadListNotifiState> mapEventToState(
      ListUnReadNotifiEvent event) async* {
    if (event is InitGetListUnReadNotifiEvent) {
      yield* _getListNotifi(page: event.page);
    } else if (event is DeleteUnReadListNotifiEvent) {
      try {
        final response =
            await userRepository.deleteNotification(event.id, event.type);
        if ((response.code == BASE_URL.SUCCESS) ||
            (response.code == BASE_URL.SUCCESS_200)) {
          yield DeleteUnReadListNotifiState();
        } else
          yield ErrorDeleteUnReadListNotifiState(response.msg ?? "");
      } catch (e) {
        yield ErrorDeleteUnReadListNotifiState(MESSAGES.CONNECT_ERROR);
        throw e;
      }
    } else if (event is ReadNotifiEvent) {
      try {
        final response = await userRepository.readNotification(
            id: event.id, type: event.type);
        if ((response.code == BASE_URL.SUCCESS) ||
            (response.code == BASE_URL.SUCCESS_200)) {
          yield ReadUnReadListNotifiState();
        } else
          yield ErrorReadUnReadListNotifiState(response.msg ?? "");
      } catch (e) {
        yield ErrorReadUnReadListNotifiState(MESSAGES.CONNECT_ERROR);
        throw e;
      }
    } else if (event is CheckNotification) {
      try {
        final response = await userRepository.getListUnReadNotification(1);
        if ((response.code == BASE_URL.SUCCESS) ||
            (response.code == BASE_URL.SUCCESS_200)) {
          if (response.data.list!.length > 0) {
            LoadingApi().popLoading();
            yield NotificationNeedRead();
          }
        } else {
          LoadingApi().popLoading();
          yield ErrorGetUnReadListNotifiState(response.msg ?? "");
        }
      } catch (e) {
        LoadingApi().popLoading();
        yield ErrorGetUnReadListNotifiState(MESSAGES.CONNECT_ERROR);
        throw e;
      }
    }
  }

  Future<void> getVersionInfoCar() async {
    try {
      final response = await userRepository.getVersionInfoCar();
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        await shareLocal.putString(
            PreferencesKey.INFO_VERSION, jsonEncode(response.data));
      } else {}
    } catch (e) {
      throw e;
    }
  }

  List<DataNotification>? listNotifi;
  Stream<UnReadListNotifiState> _getListNotifi({required int page}) async* {
    LoadingApi().pushLoading();
    try {
      final response = await userRepository.getListUnReadNotification(page);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        int page = int.parse(response.data.page!);
        if (page == 1) {
          listNotifi = response.data.list;
        } else {
          listNotifi!.addAll(response.data.list!);
        }

        yield UpdateUnReadListNotifiState(
            list: listNotifi!,
            total: response.data.total!,
            limit: response.data.limit!,
            page: page);
        LoadingApi().popLoading();
      } else {
        yield ErrorGetUnReadListNotifiState(response.msg ?? "");
        LoadingApi().popLoading();
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorGetUnReadListNotifiState(MESSAGES.CONNECT_ERROR);
      throw e;
    }
    LoadingApi().popLoading();
  }

  static GetListUnReadNotifiBloc of(BuildContext context) =>
      BlocProvider.of<GetListUnReadNotifiBloc>(context);
}
