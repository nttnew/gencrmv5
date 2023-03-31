import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/widgets/loading_api.dart';

import '../../api_resfull/user_repository.dart';
import '../../src/base.dart';
import '../../src/messages.dart';
import '../../src/models/model_generator/customer.dart';
import '../../src/models/model_generator/job_customer.dart';

part 'job_customer_event.dart';
part 'job_customer_state.dart';

class JobCustomerBloc extends Bloc<JobCustomerEvent, JobCustomerState> {
  final UserRepository userRepository;

  JobCustomerBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetJobCustomer());

  @override
  Stream<JobCustomerState> mapEventToState(JobCustomerEvent event) async* {
    if (event is InitGetJobCustomerEvent) {
      yield* _getJobCustomer(id: event.id);
    }
  }

  List<CustomerData>? listCus;

  Stream<JobCustomerState> _getJobCustomer({required int id}) async* {
    LoadingApi().pushLoading();
    try {
      final response = await userRepository.getJobCustomer(id);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield UpdateGetJobCustomerState(response.data!);
      } else {
        LoadingApi().popLoading();
        yield ErrorGetJobCustomerState(response.msg ?? '');
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorGetJobCustomerState(MESSAGES.CONNECT_ERROR);
      throw e;
    }
    LoadingApi().popLoading();
  }

  static JobCustomerBloc of(BuildContext context) =>
      BlocProvider.of<JobCustomerBloc>(context);
}
