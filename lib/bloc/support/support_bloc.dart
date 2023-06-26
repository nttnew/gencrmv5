import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/widgets/loading_api.dart';
import 'package:rxdart/rxdart.dart';
import '../../api_resfull/user_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import '../../src/base.dart';
import '../../src/models/model_generator/customer.dart';
import '../../src/models/model_generator/support.dart';

part 'support_event.dart';
part 'support_state.dart';

class SupportBloc extends Bloc<SupportEvent, SupportState> {
  final UserRepository userRepository;
  BehaviorSubject<List<FilterData>> listType = BehaviorSubject.seeded([]);

  SupportBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetSupport());

  @override
  Stream<SupportState> mapEventToState(SupportEvent event) async* {
    if (event is InitGetSupportEvent) {
      yield* _getListSupport(
        filter: event.filter ?? '',
        page: event.page ?? BASE_URL.PAGE_DEFAULT,
        search: event.search ?? '',
        ids: event.ids ?? '',
      );
    }
  }

  List<SupportItemData>? list;

  Stream<SupportState> _getListSupport({
    required String filter,
    required String ids,
    required int page,
    required String search,
  }) async* {
    LoadingApi().pushLoading();
    try {
      final response =
          await userRepository.getListSupport(page, search, filter, ids);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        listType.add(response.data.filter ?? []);
        if (page == 1) {
          list = response.data.list;
          yield SuccessGetSupportState(response.data.list ?? [],
              response.data.total ?? '0', response.data.filter ?? []);
        } else {
          list = [...list ?? [], ...response.data.list ?? []];
          yield SuccessGetSupportState(list ?? [], response.data.total ?? '0',
              response.data.filter ?? []);
        }
      } else {
        LoadingApi().popLoading();
        yield ErrorGetSupportState(response.msg ?? '');
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorGetSupportState(
          AppLocalizations.of(Get.context!)?.an_error_occurred ?? '');
      throw e;
    }
    LoadingApi().popLoading();
  }

  static SupportBloc of(BuildContext context) =>
      BlocProvider.of<SupportBloc>(context);
}
