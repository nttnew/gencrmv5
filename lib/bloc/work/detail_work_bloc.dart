import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/api_resfull/api.dart';

import '../../src/base.dart';
import '../../src/messages.dart';
import '../../src/models/model_generator/work.dart';
import '../../widgets/loading_api.dart';

part 'detail_work_event.dart';
part 'detail_work_state.dart';

class DetailWorkBloc extends Bloc<DetailWorkEvent, DetailWorkState> {
  UserRepository userRepository;
  DetailWorkBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetDetailWorkState());
  @override
  Stream<DetailWorkState> mapEventToState(DetailWorkEvent event) async* {
    if (event is InitGetDetailWorkEvent) {
      yield* _getDetailWork(event.id!);
    } else if (event is InitDeleteWorkEvent) {
      yield* _deleteWork(event.id!);
    }
  }

  Stream<DetailWorkState> _getDetailWork(int id) async* {
    LoadingApi().pushLoading();
    try {
      final response = await userRepository.detailJob(id);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield SuccessDetailWorkState(response.data ?? [], response.location);
      } else {
        yield ErrorGetDetailWorkState(response.msg ?? '');
        LoadingApi().popLoading();
      }
    } catch (e) {
      yield ErrorGetDetailWorkState(MESSAGES.CONNECT_ERROR);
      LoadingApi().popLoading();
      throw (e);
    }
    LoadingApi().popLoading();
  }

  Stream<DetailWorkState> _deleteWork(int id) async* {
    LoadingApi().pushLoading();
    try {
      final response = await userRepository.deleteJob({"id": id});
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield SuccessDeleteWorkState();
      } else {
        yield ErrorDeleteWorkState(response.msg ?? '');
      }
    } catch (e) {
      yield ErrorDeleteWorkState(MESSAGES.CONNECT_ERROR);
      LoadingApi().popLoading();
      throw (e);
    }
    LoadingApi().popLoading();
  }

  static DetailWorkBloc of(BuildContext context) =>
      BlocProvider.of<DetailWorkBloc>(context);
}
