import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../api_resfull/user_repository.dart';
import '../../src/base.dart';
import '../../src/messages.dart';
import '../../src/models/model_generator/list_notification.dart';
import '../../widgets/loading_api.dart';

part 'readed_list_notifi_event.dart';
part 'readed_list_notifi_state.dart';

class GetListReadedNotifiBloc
    extends Bloc<ListReadedNotifiEvent, ReadedListNotifiState> {
  final UserRepository userRepository;

  GetListReadedNotifiBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetReadedListNotifiState());

  @override
  Stream<ReadedListNotifiState> mapEventToState(
      ListReadedNotifiEvent event) async* {
    if (event is InitGetListReadedNotifiEvent) {
      yield* _getListNotifi(page: event.page);
    } else if (event is DeleteReadedListNotifiEvent) {
      try {
        final response =
            await userRepository.deleteNotification(event.id, event.type);
        if ((response.code == BASE_URL.SUCCESS) ||
            (response.code == BASE_URL.SUCCESS_200)) {
          yield DeleteReadedListNotifiState();
        } else
          yield ErrorDeleteReadedListNotifiState(response.msg ?? "");
      } catch (e) {
        yield ErrorDeleteReadedListNotifiState(MESSAGES.CONNECT_ERROR);
        throw e;
      }
    }
  }

  List<DataNotification>? listNotifi;
  Stream<ReadedListNotifiState> _getListNotifi({required int page}) async* {
    LoadingApi().pushLoading();
    try {
      final response = await userRepository.getListReadedNotification(page);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        int page = int.parse(response.data.page!);
        if (page == 1) {
          listNotifi = response.data.list;
        } else {
          listNotifi!.addAll(response.data.list!);
        }

        yield UpdateReadedListNotifiState(
            list: listNotifi!,
            total: response.data.total!,
            limit: response.data.limit!,
            page: page);
      } else
        yield ErrorGetReadedListNotifiState(response.msg ?? "");
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorGetReadedListNotifiState(MESSAGES.CONNECT_ERROR);
      throw e;
    }
    LoadingApi().popLoading();
  }

  static GetListReadedNotifiBloc of(BuildContext context) =>
      BlocProvider.of<GetListReadedNotifiBloc>(context);
}
