import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/widgets/loading_api.dart';

import '../../api_resfull/user_repository.dart';
import '../../src/base.dart';
import '../../src/messages.dart';
import '../../src/models/model_generator/customer.dart';
import '../../src/models/model_generator/support_customer.dart';

part 'support_customer_event.dart';
part 'support_customer_state.dart';

class SupportCustomerBloc
    extends Bloc<SupportCustomerEvent, SupportCustomerState> {
  final UserRepository userRepository;

  SupportCustomerBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetSupportCustomer());

  @override
  Stream<SupportCustomerState> mapEventToState(
      SupportCustomerEvent event) async* {
    if (event is InitGetSupportCustomerEvent) {
      yield* _getSupportCustomer(id: event.id);
    }
  }

  List<CustomerData>? listCus;

  Stream<SupportCustomerState> _getSupportCustomer({required int id}) async* {
    LoadingApi().pushLoading();
    try {
      final response = await userRepository.getSupportCustomer(id);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        if (response.data == null)
          yield UpdateGetSupportCustomerState([]);
        else
          yield UpdateGetSupportCustomerState(response.data!);
      } else {
        LoadingApi().popLoading();
        yield ErrorGetSupportCustomerState(response.msg ?? '');
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorGetSupportCustomerState(MESSAGES.CONNECT_ERROR);
      throw e;
    }
    LoadingApi().popLoading();
  }

  static SupportCustomerBloc of(BuildContext context) =>
      BlocProvider.of<SupportCustomerBloc>(context);
}
