import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../api_resfull/user_repository.dart';
import '../../l10n/key_text.dart';
import '../../src/base.dart';
import '../../src/models/model_generator/clue.dart';
import '../../widgets/listview/list_load_infinity.dart';

part 'clue_state.dart';
part 'clue_event.dart';

class GetListClueBloc extends Bloc<GetListClueEvent, ClueState> {
  final UserRepository userRepository;
  BehaviorSubject<List<FilterData>> listType = BehaviorSubject.seeded([]);
  LoadMoreController loadMoreController = LoadMoreController();
  String idFilter = '';
  String search = '';
  String ids = '';

  GetListClueBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetListClue());

  dispose() {
    idFilter = '';
    search = '';
    ids = '';
  }

  Future<dynamic> getListClue({
    int page = BASE_URL.PAGE_DEFAULT,
  }) async {
    dynamic resDynamic = '';
    try {
      final response = await userRepository.getListClue(
        page,
        idFilter,
        search,
        ids,
      );
      if (isSuccess(response.code)) {
        if (page == BASE_URL.PAGE_DEFAULT)
          listType.add(response.data?.filter ?? []);
        resDynamic = response.data?.list ?? [];
      } else
        resDynamic = response.msg ?? '';
    } catch (e) {
      resDynamic = getT(KeyT.an_error_occurred);
      return resDynamic;
    }
    return resDynamic;
  }

  static GetListClueBloc of(BuildContext context) =>
      BlocProvider.of<GetListClueBloc>(context);
}
