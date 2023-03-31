import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../api_resfull/user_repository.dart';
import '../../src/base.dart';
import '../../src/messages.dart';
import '../../src/models/model_generator/work_clue.dart';
import '../../widgets/loading_api.dart';
part 'work_clue_event.dart';
part 'work_clue_state.dart';

class WorkClueBloc extends Bloc<WorkClueEvent, WorkClueState> {
  UserRepository userRepository;
  WorkClueBloc({required this.userRepository}) : super(InitGetWorkClue());

  @override
  Stream<WorkClueState> mapEventToState(WorkClueEvent event) async* {
    if (event is GetWorkClue) {
      yield* getListWorkClue(event.id!);
    }
  }

  Stream<WorkClueState> getListWorkClue(String id) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingWorkClue();
      final response = await userRepository.getWorkClue(id);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield UpdateWorkClue(response.data!);
      } else {
        yield ErrorWorkClue(response.msg);
      }
    } catch (e) {
      yield ErrorWorkClue(MESSAGES.CONNECT_ERROR);
      throw e;
    }
    LoadingApi().popLoading();
  }

  static WorkClueBloc of(BuildContext context) =>
      BlocProvider.of<WorkClueBloc>(context);
}
