import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/api_resfull/api.dart';
import 'package:rxdart/rxdart.dart';

import '../../src/base.dart';
import '../../src/messages.dart';
import '../../src/models/model_generator/work.dart';
import '../../widgets/loading_api.dart';

part 'work_event.dart';
part 'work_state.dart';

class WorkBloc extends Bloc<WorkEvent, WorkState> {
  UserRepository userRepository;
  List<WorkItemData> data = [];
  BehaviorSubject<List<FilterData>> listType = BehaviorSubject.seeded([]);

  WorkBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetListWorkState());
  @override
  Stream<WorkState> mapEventToState(WorkEvent event) async* {
    if (event is InitGetListWorkEvent) {
      yield* _getListWork(
        ids: event.ids ?? '',
        page: BASE_URL.PAGE_DEFAULT.toString(),
        search: event.search ?? '',
        filter: event.filter ?? '',
      );
    }
  }

  Stream<WorkState> _getListWork({
    required String ids,
    required String page,
    required String search,
    required String filter,
  }) async* {
    LoadingApi().pushLoading();
    try {
      final response = await userRepository.getListJob(
        page,
        search,
        filter,
        ids,
      );
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        listType.add(
          response.data?.data_filter ?? [],
        );
        if (int.parse(page) == 1) {
          data = response.data?.data_list ?? [];
          yield SuccessGetListWorkState(
            response.data?.data_list ?? [],
            response.data?.pageCount ?? 0,
          );
        } else {
          data = [...data, ...response.data?.data_list ?? []];
          yield SuccessGetListWorkState(
            data,
            response.data?.pageCount ?? 0,
          );
        }
      } else {
        yield ErrorGetListWorkState(response.msg ?? '');
      }
    } catch (e) {
      yield ErrorGetListWorkState(MESSAGES.CONNECT_ERROR);
      throw (e);
    }
    LoadingApi().popLoading();
  }

  static WorkBloc of(BuildContext context) =>
      BlocProvider.of<WorkBloc>(context);
}
