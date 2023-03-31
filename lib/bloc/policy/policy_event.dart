part of 'policy_bloc.dart';

abstract class GetPolicyEvent extends Equatable {
  GetPolicyEvent();
  @override
  List<Object?> get props => [];
}

class InitGetPolicyEvent extends GetPolicyEvent {
  InitGetPolicyEvent();
}
