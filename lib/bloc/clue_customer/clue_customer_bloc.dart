import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/src/models/model_generator/clue_customer.dart';
import 'package:gen_crm/widgets/loading_api.dart';
import '../../api_resfull/user_repository.dart';
import '../../src/app_const.dart';
import '../../src/base.dart';
import '../../src/messages.dart';
import '../../src/models/model_generator/customer.dart';

part 'clue_customer_event.dart';
part 'clue_customer_state.dart';

class ClueCustomerBloc extends Bloc<ClueCustomerEvent, ClueCustomerState> {
  final UserRepository userRepository;
  List<CustomerData>? listCus;

  ClueCustomerBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetClueCustomer());

  @override
  Stream<ClueCustomerState> mapEventToState(ClueCustomerEvent event) async* {
    if (event is InitGetClueCustomerEvent) {
      yield* _getClueCustomer(id: event.id);
    }
  }

  Stream<ClueCustomerState> _getClueCustomer({required int id}) async* {
    LoadingApi().pushLoading();
    try {
      final response = await userRepository.getClueCustomer(id);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield UpdateGetClueCustomerState(response.data!);
      } else if (response.code == 999) {
        loginSessionExpired();
      } else {
        yield ErrorGetClueCustomerState(response.msg ?? '');
        LoadingApi().popLoading();
      }
    } catch (e) {
      yield ErrorGetClueCustomerState(MESSAGES.CONNECT_ERROR);
      LoadingApi().popLoading();
      loginSessionExpired();
      throw e;
    }
    LoadingApi().popLoading();
  }

  static ClueCustomerBloc of(BuildContext context) =>
      BlocProvider.of<ClueCustomerBloc>(context);
}
