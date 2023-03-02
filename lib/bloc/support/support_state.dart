part of 'support_bloc.dart';

abstract class SupportState extends Equatable {
  const SupportState();
  @override
  List<Object?> get props => [];
}
class InitGetSupport extends SupportState {}

class SuccessGetSupportState extends SupportState{
  final List<SupportItemData> listSupport;
  final String total;
  final List<FilterData> listFilter;
  const SuccessGetSupportState(this.listSupport,this.total,this.listFilter);
  @override
  List<Object> get props => [listSupport,total,listFilter];
}

class LoadingSupportState extends SupportState {
}


class ErrorGetSupportState extends SupportState{
  final String msg;

  ErrorGetSupportState(this.msg);
  @override
  List<Object> get props => [msg];
}