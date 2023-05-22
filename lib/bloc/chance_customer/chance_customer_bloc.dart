import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/widgets/loading_api.dart';
import '../../api_resfull/user_repository.dart';
import '../../src/app_const.dart';
import '../../src/base.dart';
import '../../src/messages.dart';
import '../../src/models/model_generator/chance_customer.dart';
import '../../src/models/model_generator/customer.dart';

part 'chance_customer_event.dart';
part 'chance_customer_state.dart';

class ChanceCustomerBloc
    extends Bloc<ChanceCustomerEvent, ChanceCustomerState> {
  final UserRepository userRepository;
  List<CustomerData>? listCus;

  ChanceCustomerBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetChanceCustomer());

  @override
  Stream<ChanceCustomerState> mapEventToState(
      ChanceCustomerEvent event) async* {
    if (event is InitGetChanceCustomerEvent) {
      yield* _getChanceCustomer(id: event.id);
    }
  }

  Stream<ChanceCustomerState> _getChanceCustomer({required int id}) async* {
    LoadingApi().pushLoading();
    try {
      final response = await userRepository.getChanceCustomer(id);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield UpdateGetChanceCustomerState(response.data!);
      } else if (response.code == 999) {
        loginSessionExpired();
      } else {
        yield ErrorGetChanceCustomerState(response.msg ?? '');
        LoadingApi().popLoading();
      }
    } catch (e) {
      LoadingApi().popLoading();
      loginSessionExpired();
      yield ErrorGetChanceCustomerState(MESSAGES.CONNECT_ERROR);
      throw e;
    }
    LoadingApi().popLoading();
  }

  static ChanceCustomerBloc of(BuildContext context) =>
      BlocProvider.of<ChanceCustomerBloc>(context);
}
