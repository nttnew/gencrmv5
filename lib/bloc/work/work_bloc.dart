import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/api_resfull/api.dart';
import 'package:rxdart/rxdart.dart';
import '../../l10n/key_text.dart';
import '../../src/base.dart';
import '../../src/models/model_generator/customer_clue.dart';
import '../../src/models/model_generator/work.dart';
import '../../widgets/listview/list_load_infinity.dart';

part 'work_event.dart';
part 'work_state.dart';

class WorkBloc extends Bloc<WorkEvent, WorkState> {
  UserRepository userRepository;
  BehaviorSubject<List<Customer>> listType = BehaviorSubject.seeded([]);
  LoadMoreController loadMoreController = LoadMoreController();
  String idFilter = '';
  String search = '';
  String ids = '';

  dispose() {
    idFilter = '';
    search = '';
    ids = '';
  }

  WorkBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetListWorkState());

  Future<dynamic> getListWork({
    int page = BASE_URL.PAGE_DEFAULT,
  }) async {
    dynamic resDynamic = '';
    try {
      final response = await userRepository.getListJob(
        page.toString(),
        search,
        idFilter,
        ids,
      );
      if (isSuccess(response.code)) {
        if (page == BASE_URL.PAGE_DEFAULT)
          listType.add(
            response.data?.data_filter ?? [],
          );
        resDynamic = response.data?.data_list ?? [];
      } else {
        resDynamic = response.msg ?? '';
      }
    } catch (e) {
      resDynamic = getT(KeyT.an_error_occurred);
      return resDynamic;
    }
    return resDynamic;
  }

  static WorkBloc of(BuildContext context) =>
      BlocProvider.of<WorkBloc>(context);
}
