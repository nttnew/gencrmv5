import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../api_resfull/user_repository.dart';
import '../../l10n/key_text.dart';
import '../../src/base.dart';
import '../../src/models/model_generator/list_notification.dart';
import '../../widgets/loading_api.dart';

part 'readed_list_notifi_event.dart';
part 'readed_list_notifi_state.dart';

class ReadNotificationBloc
    extends Bloc<ReadNotificationEvent, ReadNotificationState> {
  final UserRepository userRepository;
  List<DataNotification>? listNotification;
  int total = 0;

  ReadNotificationBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetReadNotificationState());

  deleteAll() {
    String ids = _getId();
    if (ids != '') {
      String dataIds = ids.splitBefore(',');
      this.add(DeleteReadedListNotifiEvent(dataIds));
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

  @override
  Stream<ReadNotificationState> mapEventToState(
    ReadNotificationEvent event,
  ) async* {
    if (event is InitGetListReadedNotifiEvent) {
      yield* _getListNotification(page: event.page);
    } else if (event is DeleteReadedListNotifiEvent) {
      yield* _delete(id: event.id);
    } else if (event is ShowSelectOrUnselectAll) {
      yield* _selectOrUnselectAll(
        isSelect: event.isSelect ?? true,
      );
    }
  }

  Stream<ReadNotificationState> _selectOrUnselectAll({
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
      yield UpdateReadNotificationState(
        list: listS,
      );
    }
  }

  Stream<ReadNotificationState> _delete({
    required String id,
  }) async* {
    try {
      //list id,id,...
      final response = await userRepository.deleteNotification(id);
      if (isSuccess(response.code)) {
        yield DeleteReadNotificationState();
      } else
        yield ErrorDeleteReadNotificationState(response.msg ?? '');
    } catch (e) {
      yield ErrorDeleteReadNotificationState(getT(KeyT.an_error_occurred));
      throw e;
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

  Stream<ReadNotificationState> _getListNotification({
    required int page,
  }) async* {
    Loading().showLoading();
    try {
      final response = await userRepository.getListReadNotification(page);
      if (isSuccess(response.code)) {
        if (page == BASE_URL.PAGE_DEFAULT) {
          listNotification = response.data?.list ?? [];
        } else {
          listNotification = [
            ...listNotification ?? [],
            ...response.data?.list ?? []
          ];
        }
        total = int.tryParse(response.data?.total ?? '0') ?? 0;
        yield UpdateReadNotificationState(
          list: listNotification ?? [],
        );
      } else
        yield ErrorGetReadNotificationState(response.msg ?? '');
    } catch (e) {
      Loading().popLoading();
      yield ErrorGetReadNotificationState(getT(KeyT.an_error_occurred));
      throw e;
    }
    Loading().popLoading();
  }

  static ReadNotificationBloc of(BuildContext context) =>
      BlocProvider.of<ReadNotificationBloc>(context);
}
