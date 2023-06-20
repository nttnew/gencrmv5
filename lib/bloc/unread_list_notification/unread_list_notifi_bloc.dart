import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../api_resfull/user_repository.dart';
import '../../src/base.dart';
import '../../src/messages.dart';
import '../../src/models/model_generator/list_notification.dart';
import '../../src/preferences_key.dart';
import '../../storages/share_local.dart';
import '../../widgets/loading_api.dart';

part 'unread_list_notifi_event.dart';
part 'unread_list_notifi_state.dart';

class GetNotificationBloc
    extends Bloc<ListUnReadNotificationEvent, NotificationState> {
  final UserRepository userRepository;
  int total = 0;

  GetNotificationBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetNotificationState()) {
    getVersionInfoCar();
  }

  @override
  Stream<NotificationState> mapEventToState(
      ListUnReadNotificationEvent event) async* {
    if (event is InitGetListUnReadNotificationEvent) {
      yield* _getListNotifi(page: event.page);
    } else if (event is DeleteUnReadListNotificationEvent) {
      try {
        final response =
            await userRepository.deleteNotification(event.id, event.type);
        if ((response.code == BASE_URL.SUCCESS) ||
            (response.code == BASE_URL.SUCCESS_200)) {
          yield DeleteNotificationState();
        } else {
          LoadingApi().popLoading();
          yield ErrorDeleteNotificationState(response.msg ?? "");
        }
      } catch (e) {
        LoadingApi().popLoading();
        yield ErrorDeleteNotificationState(MESSAGES.CONNECT_ERROR);
        throw e;
      }
    } else if (event is ReadNotificationEvent) {
      try {
        final response = await userRepository.readNotification(
            id: event.id, type: event.type);
        if ((response.code == BASE_URL.SUCCESS) ||
            (response.code == BASE_URL.SUCCESS_200)) {
          yield ReadNotificationState();
        } else {
          LoadingApi().popLoading();
          yield ErrorNotificationState(response.msg ?? "");
        }
      } catch (e) {
        LoadingApi().popLoading();
        yield ErrorNotificationState(MESSAGES.CONNECT_ERROR);
        throw e;
      }
    } else if (event is CheckNotification) {
      try {
        final response = await userRepository.getListUnReadNotification(1);
        if ((response.code == BASE_URL.SUCCESS) ||
            (response.code == BASE_URL.SUCCESS_200)) {
          if (response.data.list!.length > 0) {
            total = int.parse(response.data.total ?? '0');
            LoadingApi().popLoading();
            yield NotificationNeedRead();
          }
        } else {
          LoadingApi().popLoading();
          yield ErrorGetNotificationState(response.msg ?? "");
        }
      } catch (e) {
        LoadingApi().popLoading();
        yield ErrorGetNotificationState(MESSAGES.CONNECT_ERROR);
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
  Stream<NotificationState> _getListNotifi({required int page}) async* {
    LoadingApi().pushLoading();
    try {
      final response = await userRepository.getListUnReadNotification(page);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        total = int.parse(response.data.total ?? '0');
        int page = int.parse(response.data.page!);
        if (page == 1) {
          listNotifi = response.data.list;
        } else {
          listNotifi!.addAll(response.data.list!);
        }
        LoadingApi().popLoading();
        yield UpdateNotificationState(
            list: listNotifi!,
            total: response.data.total!,
            limit: response.data.limit!,
            page: page);
      } else {
        LoadingApi().popLoading();
        yield ErrorGetNotificationState(response.msg ?? "");
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorGetNotificationState(MESSAGES.CONNECT_ERROR);
      throw e;
    }
    LoadingApi().popLoading();
  }

  static GetNotificationBloc of(BuildContext context) =>
      BlocProvider.of<GetNotificationBloc>(context);
}
