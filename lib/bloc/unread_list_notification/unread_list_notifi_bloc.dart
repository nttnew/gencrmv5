import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:rxdart/rxdart.dart';
import '../../api_resfull/user_repository.dart';
import '../../l10n/key_text.dart';
import '../../src/base.dart';
import '../../src/models/model_generator/list_notification.dart';
import '../../widgets/loading_api.dart';

part 'unread_list_notifi_event.dart';
part 'unread_list_notifi_state.dart';

class UnreadNotificationBloc
    extends Bloc<UnReadNotificationEvent, UnReadNotificationState> {
  final UserRepository userRepository;
  BehaviorSubject<int> total = BehaviorSubject.seeded(0);
  List<DataNotification>? listNotification;
  BehaviorSubject<bool> showSelectAll = BehaviorSubject.seeded(false);
  bool isShowBtnAll = true;

  UnreadNotificationBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetNotificationState());

  @override
  Stream<UnReadNotificationState> mapEventToState(
    UnReadNotificationEvent event,
  ) async* {
    if (event is InitGetListUnReadNotificationEvent) {
      yield* _getUnreadNotification(
          page: event.page, isLoading: event.isLoading);
    } else if (event is DeleteUnReadListNotificationEvent) {
      yield* _deleteNotification(
        id: event.id,
      );
    } else if (event is ReadNotificationEvent) {
      yield* _readNotification(
        id: event.id,
      );
    } else if (event is CheckNotification) {
      yield* _checkNotification(event.isLoading);
    } else if (event is ShowSelectOrUnselectAll) {
      yield* selectOrUnselectAll(isSelect: event.isSelect ?? true);
    }
  }

  readAll() {
    String ids = _getId();
    if (ids != '') {
      String dataIds = ids.splitBefore(',');
      this.add(ReadNotificationEvent(dataIds));
    }
  }

  deleteAll() {
    String ids = _getId();
    if (ids != '') {
      String dataIds = ids.splitBefore(',');
      this.add(DeleteUnReadListNotificationEvent(dataIds));
    }
  }

  String _getId() {
    final idsSelect =
        listNotification?.where((element) => element.isSelect == true).toList();
    String ids = '';
    idsSelect?.forEach((element) {
      ids += '${element.id},';
    });
    return ids;
  }

  resetSelect() {
    showSelectAll.add(false);
    isShowBtnAll = true;
  }

  Stream<UnReadNotificationState> selectOrUnselectAll({
    bool isSelect = true,
  }) async* {
    List<DataNotification> listS = [];
    if ((listNotification?.length ?? 0) > 0) {
      for (int i = 0; i < listNotification!.length; i++) {
        listS.add(DataNotification(
          id: listNotification![i].id,
          type: listNotification![i].type,
          title: listNotification![i].title,
          content: listNotification![i].content,
          link: listNotification![i].link,
          module: listNotification![i].module,
          recordId: listNotification![i].recordId,
          isSelect: isSelect,
        ));
      }
      listNotification = listS;
      yield UpdateNotificationState(
        list: listS,
      );
    }
  }

  selectOrUnselectOne({
    bool isSelect = true,
    required DataNotification value,
  }) {
    if (listNotification?.isNotEmpty ?? false) {
      int index = listNotification!.indexWhere((element) =>
          element.id == value.id && element.recordId == element.recordId);
      if (index != -1) {
        listNotification![index].isSelect = isSelect;
      }
    }
  }

  Stream<UnReadNotificationState> _getUnreadNotification({
    required int page,
    bool isLoading = true,
  }) async* {
    if (isLoading) Loading().showLoading();
    try {
      final response = await userRepository.getListUnReadNotification(page);
      if (isSuccess(response.code)) {
        total.add(int.parse(response.data?.total ?? '0'));
        if (page == BASE_URL.PAGE_DEFAULT) {
          listNotification = response.data?.list ?? [];
        } else {
          listNotification = [
            ...listNotification ?? [],
            ...response.data?.list ?? []
          ];
        }
        if (isLoading) Loading().popLoading();
        yield UpdateNotificationState(
          list: listNotification ?? [],
        );
      } else {
        if (isLoading) Loading().popLoading();
        yield ErrorGetNotificationState(response.msg ?? '');
      }
    } catch (e) {
      if (isLoading) Loading().popLoading();
      yield ErrorGetNotificationState(getT(KeyT.an_error_occurred));
    }
  }

  Stream<UnReadNotificationState> _deleteNotification({
    required String id,
  }) async* {
    try {
      final response = await userRepository.deleteNotification(
        id,
      );
      if (isSuccess(response.code)) {
        yield DeleteNotificationState();
      } else {
        Loading().popLoading();
        yield ErrorDeleteNotificationState(response.msg ?? '');
      }
    } catch (e) {
      Loading().popLoading();
      yield ErrorDeleteNotificationState(getT(KeyT.an_error_occurred));
      throw e;
    }
  }

  Stream<UnReadNotificationState> _readNotification({
    required String id,
  }) async* {
    try {
      //list id,id,..
      final response = await userRepository.readNotification(
        id: id,
      );
      if (isSuccess(response.code)) {
        yield ReadNotificationState();
      } else {
        Loading().popLoading();
        yield ErrorNotificationState(response.msg ?? '');
      }
    } catch (e) {
      Loading().popLoading();
      yield ErrorNotificationState(getT(KeyT.an_error_occurred));
    }
  }

  Stream<UnReadNotificationState> _checkNotification(bool isLoading) async* {
    try {
      if (isLoading) Loading().showLoading();
      final response =
          await userRepository.getListUnReadNotification(BASE_URL.PAGE_DEFAULT);
      if (isSuccess(response.code)) {
        if (isLoading) Loading().popLoading();
        if ((response.data?.list?.length ?? 0) > 0) {
          total.add(int.parse(response.data?.total ?? '0'));
        }
      } else {
        if (isLoading) Loading().popLoading();
      }
    } catch (e) {
      if (isLoading) Loading().popLoading();
    }
  }

  static UnreadNotificationBloc of(BuildContext context) =>
      BlocProvider.of<UnreadNotificationBloc>(context);
}
