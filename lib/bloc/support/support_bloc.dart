import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/widgets/loading_api.dart';
import 'package:rxdart/rxdart.dart';
import '../../api_resfull/user_repository.dart';
import '../../l10n/key_text.dart';
import '../../src/base.dart';
import '../../src/models/model_generator/customer.dart';
import '../../widgets/listview/list_load_infinity.dart';

part 'support_event.dart';
part 'support_state.dart';

class SupportBloc extends Bloc<SupportEvent, SupportState> {
  final UserRepository userRepository;
  BehaviorSubject<List<FilterData>> listType = BehaviorSubject.seeded([]);
  LoadMoreController loadMoreController = LoadMoreController();
  String idFilter = '';
  String search = '';
  String ids = '';

  init() {
    idFilter = '';
    search = '';
    ids = '';
  }

  SupportBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetSupport());

  Future<dynamic> getListSupport({
    int page = BASE_URL.PAGE_DEFAULT,
  }) async {
    LoadingApi().pushLoading();
    dynamic resDynamic = '';
    try {
      final response = await userRepository.getListSupport(
        page,
        search,
        idFilter,
        ids,
      );
      if (isSuccess(response.code)) {
        if (page == BASE_URL.PAGE_DEFAULT)
          listType.add(response.data.filter ?? []);
        resDynamic = response.data.list ?? [];
      } else {
        resDynamic = response.msg ?? '';
      }
    } catch (e) {
      resDynamic = getT(KeyT.an_error_occurred);
      throw e;
    }
    LoadingApi().popLoading();
    return resDynamic;
  }

  static SupportBloc of(BuildContext context) =>
      BlocProvider.of<SupportBloc>(context);
}
