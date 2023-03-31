part of 'job_customer_bloc.dart';

abstract class JobCustomerEvent extends Equatable {
  const JobCustomerEvent();
  @override
  List<Object?> get props => [];
}

class InitGetJobCustomerEvent extends JobCustomerEvent {
  final int id;

  InitGetJobCustomerEvent(this.id);
}
