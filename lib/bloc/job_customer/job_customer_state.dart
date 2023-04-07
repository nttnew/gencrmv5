part of 'job_customer_bloc.dart';

abstract class JobCustomerState extends Equatable {
  const JobCustomerState();
  @override
  List<Object?> get props => [];
}

class InitGetJobCustomer extends JobCustomerState {}

class UpdateGetJobCustomerState extends JobCustomerState {
  final List<JobCustomerData> listJob;
  const UpdateGetJobCustomerState(this.listJob);
  @override
  List<Object> get props => [listJob];
}

class LoadingJobCustomerState extends JobCustomerState {}

class ErrorGetJobCustomerState extends JobCustomerState {
  final String msg;

  ErrorGetJobCustomerState(this.msg);
  @override
  List<Object> get props => [msg];
}
