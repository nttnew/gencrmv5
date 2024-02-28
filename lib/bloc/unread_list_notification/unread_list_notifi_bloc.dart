import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../api_resfull/user_repository.dart';
import '../../l10n/key_text.dart';
import '../../src/base.dart';
import '../../src/models/model_generator/list_notification.dart';
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
        super(InitGetNotificationState());

  @override
  Stream<NotificationState> mapEventToState(
      ListUnReadNotificationEvent event) async* {
    if (event is InitGetListUnReadNotificationEvent) {
      yield* _getListNotification(page: event.page, isLoading: event.isLoading);
    } else if (event is DeleteUnReadListNotificationEvent) {
      yield* _deleteNotification(id: event.id, type: event.type);
    } else if (event is ReadNotificationEvent) {
      yield* _readNotification(id: event.id, type: event.type);
    } else if (event is CheckNotification) {
      yield* _checkNotification(event.isLoading ?? true);
    }
  }

  Stream<NotificationState> _getListNotification({
    required int page,
    bool isLoading = true,
  }) async* {
    if (isLoading) LoadingApi().pushLoading();
    try {
      final response = await userRepository.getListUnReadNotification(page);
      if (isSuccess(response.code)) {
        total.add(int.parse(response.data.total ?? '0'));
        int page = int.parse(response.data.page!);
        if (page == 1) {
          listNotification = response.data.list;
        } else {
          listNotification!.addAll(response.data.list!);
        }
        if (isLoading) LoadingApi().popLoading();
        yield UpdateNotificationState(
            list: listNotification!,
            total: response.data.total!,
            limit: response.data.limit!,
            page: page);
      } else {
        if (isLoading) LoadingApi().popLoading();
        yield ErrorGetNotificationState(response.msg ?? '');
      }
    } catch (e) {
      if (isLoading) LoadingApi().popLoading();
      yield ErrorGetNotificationState(getT(KeyT.an_error_occurred));
    }
  }

  Stream<NotificationState> _deleteNotification(
      {required int id, required String type}) async* {
    try {
      final response = await userRepository.deleteNotification(id, type);
      if (isSuccess(response.code)) {
        yield DeleteNotificationState();
      } else {
        LoadingApi().popLoading();
        yield ErrorDeleteNotificationState(response.msg ?? '');
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorDeleteNotificationState(getT(KeyT.an_error_occurred));
      throw e;
    }
  }

  Stream<NotificationState> _readNotification(
      {required String id, required String type}) async* {
    try {
      final response =
          await userRepository.readNotification(id: id, type: type);
      if (isSuccess(response.code)) {
        yield ReadNotificationState();
      } else {
        LoadingApi().popLoading();
        yield ErrorNotificationState(response.msg ?? '');
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorNotificationState(getT(KeyT.an_error_occurred));
    }
  }

  Stream<NotificationState> _checkNotification(bool isLoading) async* {
    try {
      if (isLoading) LoadingApi().pushLoading();
      final response = await userRepository.getListUnReadNotification(1);
      if (isSuccess(response.code)) {
        if (isLoading) LoadingApi().popLoading();
        if (response.data.list!.length > 0) {
          total.add(int.parse(response.data.total ?? '0'));
          yield NotificationNeedRead();
        }
      } else {
        if (isLoading) LoadingApi().popLoading();
        yield ErrorGetNotificationState(response.msg ?? '');
      }
    } catch (e) {
      if (isLoading) LoadingApi().popLoading();
      yield ErrorGetNotificationState(getT(KeyT.an_error_occurred));
    }
  }

  static GetNotificationBloc of(BuildContext context) =>
      BlocProvider.of<GetNotificationBloc>(context);
}
