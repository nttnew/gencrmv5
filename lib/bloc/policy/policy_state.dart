part of 'policy_bloc.dart';
abstract class PolicyState extends Equatable {
  const PolicyState();
  @override
  List<Object?> get props => [];
}
class InitGetPolicy extends PolicyState {}

class UpdateGetPolicyState extends PolicyState{
  final String? policy;


  UpdateGetPolicyState(this.policy);
}
   class LoadingGetPolicyState extends PolicyState {

}


class ErrorGetPolicyState extends PolicyState{
  final String msg;

  ErrorGetPolicyState(this.msg);
  @override
  List<Object> get props => [msg];
}