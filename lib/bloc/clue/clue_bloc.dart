import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../api_resfull/user_repository.dart';
import '../../src/app_const.dart';
import '../../src/base.dart';
import '../../src/messages.dart';
import '../../src/models/model_generator/clue.dart';
import '../../widgets/loading_api.dart';

part 'clue_state.dart';
part 'clue_event.dart';

class GetListClueBloc extends Bloc<GetListClueEvent, ClueState> {
  final UserRepository userRepository;
  List<ClueData>? listClueData;
  BehaviorSubject<List<FilterData>> listType = BehaviorSubject.seeded([]);

  GetListClueBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetListClue());

  @override
  Stream<ClueState> mapEventToState(GetListClueEvent event) async* {
    if (event is InitGetListClueEvent) {
      yield* _getListClue(
        filter: event.filter ?? '',
        page: event.page ?? BASE_URL.PAGE_DEFAULT,
        search: event.search ?? '',
        ids: event.ids ?? '',
      );
    }
  }

  Stream<ClueState> _getListClue({
    required String filter,
    required int page,
    required String search,
    required String ids,
  }) async* {
    LoadingApi().pushLoading();
    try {
      final response = await userRepository.getListClue(
        page,
        filter,
        search,
        ids,
      );
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        listType.add(response.data?.filter ?? []);
        if (page == 1) {
          listClueData = [];
          yield UpdateGetListClueState(response.data!.list!,
              response.data!.filter!, response.data!.total!);
        }
        yield UpdateGetListClueState(
            [...listClueData!, ...response.data!.list!],
            response.data!.filter!,
            response.data!.total!);
        listClueData?.addAll(response.data?.list ?? []);
      } else if (response.code == 999) {
        loginSessionExpired();
      } else
        yield ErrorGetListClueState(response.msg ?? '');
    } catch (e) {
      yield ErrorGetListClueState(MESSAGES.CONNECT_ERROR);
      LoadingApi().popLoading();
      loginSessionExpired();
      throw e;
    }
    LoadingApi().popLoading();
  }

  static GetListClueBloc of(BuildContext context) =>
      BlocProvider.of<GetListClueBloc>(context);
}
