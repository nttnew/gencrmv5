import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../api_resfull/user_repository.dart';

part 'total_event.dart';
part 'total_state.dart';

class TotalBloc extends Bloc<TotalEvent, TotalState> {
  final UserRepository userRepository;
  BehaviorSubject<double> unpaidStream = BehaviorSubject.seeded(0);
  BehaviorSubject<double> paidStream = BehaviorSubject.seeded(0);
  double total = 0;
  TotalBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetTotalState());

  @override
  Stream<TotalState> mapEventToState(TotalEvent event) async* {
    if (event is InitTotalEvent) {
      total = event.total;
      yield* _getTotalContract(event.total);
    } else if (event is ReloadTotalEvent) {
      disposeTotal();
      yield SuccessTotalState(0);
    }
  }

  void getPaid() {
    final double unpaid = total - paidStream.value;
    unpaidStream.add(unpaid);
  }

  Stream<TotalState> _getTotalContract(
    double total,
  ) async* {
    yield SuccessTotalState(total);
  }

  disposeTotal() {
    unpaidStream.add(0);
    paidStream.add(0);
    total = 0;
  }

  static TotalBloc of(BuildContext context) =>
      BlocProvider.of<TotalBloc>(context);
}
