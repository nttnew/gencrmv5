import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../api_resfull/user_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import '../../src/base.dart';
import '../../src/models/model_generator/list_notification.dart';
import '../../src/preferences_key.dart';
import '../../storages/share_local.dart';
import '../../widgets/loading_api.dart';

part 'unread_list_notifi_event.dart';
part 'unread_list_notifi_state.dart';

class GetNotificationBloc
    extends Bloc<ListUnReadNotificationEvent, NotificationState> {
  final UserRepository userRepository;
  BehaviorSubject<int> total = BehaviorSubject.seeded(0);
  List<DataNotification>? listNotification;

  GetNotificationBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetNotificationState()) {
    getVersionInfoCar();
  }

  @override
  Stream<NotificationState> mapEventToState(
      ListUnReadNotificationEvent event) async* {
    if (event is InitGetListUnReadNotificationEvent) {
      yield* _getListNotification(page: event.page);
    } else if (event is DeleteUnReadListNotificationEvent) {
      yield* _deleteNotification(id: event.id, type: event.type);
    } else if (event is ReadNotificationEvent) {
      yield* _readNotification(id: event.id, type: event.type);
    } else if (event is CheckNotification) {
      yield* _checkNotification();
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

  Stream<NotificationState> _getListNotification({required int page}) async* {
    LoadingApi().pushLoading();
    try {
      final response = await userRepository.getListUnReadNotification(page);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        total.add(int.parse(response.data.total ?? '0'));
        int page = int.parse(response.data.page!);
        if (page == 1) {
          listNotification = response.data.list;
        } else {
          listNotification!.addAll(response.data.list!);
        }
        LoadingApi().popLoading();
        yield UpdateNotificationState(
            list: listNotification!,
            total: response.data.total!,
            limit: response.data.limit!,
            page: page);
      } else {
        LoadingApi().popLoading();
        yield ErrorGetNotificationState(response.msg ?? "");
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorGetNotificationState(
          AppLocalizations.of(Get.context!)?.an_error_occurred ?? '');
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<NotificationState> _deleteNotification(
      {required int id, required String type}) async* {
    try {
      final response = await userRepository.deleteNotification(id, type);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield DeleteNotificationState();
      } else {
        LoadingApi().popLoading();
        yield ErrorDeleteNotificationState(response.msg ?? "");
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorDeleteNotificationState(
          AppLocalizations.of(Get.context!)?.an_error_occurred ?? '');
      throw e;
    }
  }

  Stream<NotificationState> _readNotification(
      {required String id, required String type}) async* {
    try {
      final response =
          await userRepository.readNotification(id: id, type: type);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield ReadNotificationState();
      } else {
        LoadingApi().popLoading();
        yield ErrorNotificationState(response.msg ?? "");
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorNotificationState(
          AppLocalizations.of(Get.context!)?.an_error_occurred ?? '');
      throw e;
    }
  }

  Stream<NotificationState> _checkNotification() async* {
    try {
      final response = await userRepository.getListUnReadNotification(1);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        if (response.data.list!.length > 0) {
          total.add(int.parse(response.data.total ?? '0'));
          LoadingApi().popLoading();
          yield NotificationNeedRead();
        }
      } else {
        LoadingApi().popLoading();
        yield ErrorGetNotificationState(response.msg ?? "");
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorGetNotificationState(
          AppLocalizations.of(Get.context!)?.an_error_occurred ?? '');
      throw e;
    }
  }

  static GetNotificationBloc of(BuildContext context) =>
      BlocProvider.of<GetNotificationBloc>(context);
}
