import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/src/models/model_generator/detail_contract.dart';
import 'package:gen_crm/widgets/loading_api.dart';

import '../../api_resfull/user_repository.dart';
import '../../src/base.dart';
import '../../src/messages.dart';
import '../../src/models/model_generator/contract.dart';
import '../../src/models/model_generator/customer.dart';
import '../../src/models/model_generator/job_chance.dart';

part 'total_event.dart';
part 'total_state.dart';

class TotalBloc extends Bloc<TotalEvent, TotalState>{
  final UserRepository userRepository;

  TotalBloc({required UserRepository userRepository}) : userRepository = userRepository, super(InitGetTotalState());

  @override
  Stream<TotalState> mapEventToState(TotalEvent event) async* {
    if (event is InitTotalEvent) {
      yield* _getTotalContract(event.total);
    }
  }

  Stream<TotalState> _getTotalContract(double total) async* {
    yield SuccessTotalState(total);
  }

  static TotalBloc of(BuildContext context) => BlocProvider.of<TotalBloc>(context);
}