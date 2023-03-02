part of 'detail_contract_bloc.dart';

abstract class DetailContractState extends Equatable {
  const DetailContractState();
  @override
  List<Object?> get props => [];
}
class InitDetailContract extends DetailContractState {}

class LoadingDeleteContractState extends DetailContractState{}
class SuccessDeleteContractState extends DetailContractState{}
class ErrorDeleteContractState extends DetailContractState{
  final String msg;

  ErrorDeleteContractState(this.msg);
  @override
  List<Object> get props => [msg];
}





//detailContract
class LoadingDetailContractState extends DetailContractState {
}

class SuccessDetailContractState extends DetailContractState{
  final List<DetailContractData> listDetailContract;
  const SuccessDetailContractState(this.listDetailContract);
  @override
  List<Object> get props => [listDetailContract];
}

class ErrorDetailContractState extends DetailContractState{
  final String msg;

  ErrorDetailContractState(this.msg);
  @override
  List<Object> get props => [msg];
}



