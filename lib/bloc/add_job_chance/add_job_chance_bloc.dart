import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/widgets/loading_api.dart';
import '../../api_resfull/user_repository.dart';
import '../../l10n/key_text.dart';
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
    Loading().showLoading();
    try {
      final response = await userRepository.getAddJobChance(id);
      if (isSuccess(response.code)) {
        yield UpdateGetAddJobChanceState(response.data ?? []);
      } else
        yield ErrorGetAddJobChanceState(response.msg ?? '');
    } catch (e) {
      Loading().popLoading();
      yield ErrorGetAddJobChanceState(getT(KeyT.an_error_occurred));
      throw e;
    }
    Loading().popLoading();
  }

  static AddJobChanceBloc of(BuildContext context) =>
      BlocProvider.of<AddJobChanceBloc>(context);
}
