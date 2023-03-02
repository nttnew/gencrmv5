part of 'job_contract_bloc.dart';
abstract class JobContractState extends Equatable{
  JobContractState();

  @override
  // TODO: implement props
  List<Object?> get props => [];

}

class InitJobContractState extends JobContractState {
}

//job
class LoadingJobContractState extends JobContractState {
}

class SuccessJobContractState extends JobContractState{
  final List<DataFormAdd> listJob;
  SuccessJobContractState(this.listJob);
  @override
  List<Object> get props => [listJob];
}

class ErrorJobContractState extends JobContractState{
  final String msg;

  ErrorJobContractState(this.msg);
  @override
  List<Object> get props => [msg];
}


