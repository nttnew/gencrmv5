import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api_resfull/user_repository.dart';

part 'total_event.dart';
part 'total_state.dart';

class TotalBloc extends Bloc<TotalEvent, TotalState> {
  final UserRepository userRepository;

  TotalBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetTotalState());

  @override
  Stream<TotalState> mapEventToState(TotalEvent event) async* {
    if (event is InitTotalEvent) {
      yield* _getTotalContract(event.total);
    } else if (event is ReloadTotalEvent) {
      yield SuccessTotalState(0);
    }
  }

  Stream<TotalState> _getTotalContract(double total) async* {
    yield SuccessTotalState(total);
  }

  static TotalBloc of(BuildContext context) =>
      BlocProvider.of<TotalBloc>(context);
}
