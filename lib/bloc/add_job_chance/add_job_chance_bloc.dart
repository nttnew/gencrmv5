import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/widgets/loading_api.dart';

import '../../api_resfull/user_repository.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../../src/app_const.dart';
import '../../src/base.dart';

import '../../src/models/index.dart';

part 'add_job_chance_event.dart';
part 'add_job_chance_state.dart';

class AddJobChanceBloc extends Bloc<AddJobChanceEvent, AddJobChanceState> {
  final UserRepository userRepository;
  List<ListChanceData>? listChance;

  AddJobChanceBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetAddJobChance());

  @override
  Stream<AddJobChanceState> mapEventToState(AddJobChanceEvent event) async* {
    if (event is InitGetAddJobEventChance) {
      yield* _getAddJobChance(id: event.id);
    }
  }

  Stream<AddJobChanceState> _getAddJobChance({required int id}) async* {
    LoadingApi().pushLoading();
    try {
      final response = await userRepository.getAddJobChance(id);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield UpdateGetAddJobChanceState(response.data ?? []);
      } else if (response.code == BASE_URL.SUCCESS_999) {
        loginSessionExpired();
      } else
        yield ErrorGetAddJobChanceState(response.msg ?? '');
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorGetAddJobChanceState(AppLocalizations.of(Get.context!)?.

an_error_occurred??'');
      throw e;
    }
    LoadingApi().popLoading();
  }

  static AddJobChanceBloc of(BuildContext context) =>
      BlocProvider.of<AddJobChanceBloc>(context);
}
