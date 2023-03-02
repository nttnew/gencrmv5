part of 'job_contract_bloc.dart';

abstract class JobContractEvent extends Equatable{

  @override
  List<Object?> get props => [];

  JobContractEvent();
}

class InitGetJobContractEvent extends JobContractEvent {
  final int id;

  InitGetJobContractEvent(this.id);
}