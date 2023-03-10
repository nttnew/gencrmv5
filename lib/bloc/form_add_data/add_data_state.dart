part of 'add_data_bloc.dart';

abstract class AddDataState extends Equatable {
  const AddDataState();
  @override
  List<Object?> get props => [];
}
class InitAddDataState extends AddDataState {}

class LoadingAddCustomerOrState extends AddDataState {
}
class SuccessAddCustomerOrState extends AddDataState{
}
class ErrorAddCustomerOrState extends AddDataState{
  final String msg;

  ErrorAddCustomerOrState(this.msg);
  @override
  List<Object> get props => [msg];
}

class LoadingEditCustomerState extends AddDataState {
}
class SuccessEditCustomerState extends AddDataState{
}
class ErrorEditCustomerState extends AddDataState{
  final String msg;

  ErrorEditCustomerState(this.msg);
  @override
  List<Object> get props => [msg];
}

//add Contact Cus
class LoadingAddContactCustomerState extends AddDataState {
}
class SuccessAddContactCustomerState extends AddDataState{
}
class ErrorAddContactCustomerState extends AddDataState{
  final String msg;

  ErrorAddContactCustomerState(this.msg);
  @override
  List<Object> get props => [msg];
}