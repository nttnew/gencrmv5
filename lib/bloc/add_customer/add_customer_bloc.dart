import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/widgets/loading_api.dart';
import '../../api_resfull/user_repository.dart';
import '../../l10n/key_text.dart';
import '../../src/app_const.dart';
import '../../src/models/model_generator/add_customer.dart';
import '../../src/models/model_generator/customer.dart';

part 'add_customer_event.dart';
part 'add_customer_state.dart';

class AddCustomerBloc extends Bloc<AddCustomerEvent, AddCustomerState> {
  final UserRepository userRepository;
  List<CustomerData>? listCus;

  AddCustomerBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetAddCustomer());

  @override
  Stream<AddCustomerState> mapEventToState(AddCustomerEvent event) async* {
    if (event is InitGetAddCustomerEvent) {
      yield* _getAddCustomer(isIndividual: event.id);
    }
    if (event is InitGetEditCustomerEvent) {
      yield* _getEditCustomer(id: event.id);
    }
  }

  Stream<AddCustomerState> _getAddCustomer({required int isIndividual}) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingAddCustomerState();
      final response = await userRepository.getAddCustomer(isIndividual);
      if (isSuccess(response.code)) {
        yield UpdateGetAddCustomerState(response.data ?? []);
      } else if (isFail(response.code)) {
        loginSessionExpired();
      } else {
        LoadingApi().popLoading();
        yield ErrorGetAddCustomerState(response.msg ?? '');
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorGetAddCustomerState(getT(KeyT.an_error_occurred));
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<AddCustomerState> _getEditCustomer({String? id}) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingGetEditCustomerState();
      final response = await userRepository.getUpdateCustomer(id ?? '');
      if (isSuccess(response.code)) {
        yield SuccessGetEditCustomerState(response.data ?? []);
      } else if (isFail(response.code)) {
        loginSessionExpired();
      } else {
        LoadingApi().popLoading();
        yield ErrorGetEditCustomerState(response.msg ?? '');
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorGetEditCustomerState(getT(KeyT.an_error_occurred));
      throw e;
    }
    LoadingApi().popLoading();
  }

  static AddCustomerBloc of(BuildContext context) =>
      BlocProvider.of<AddCustomerBloc>(context);
}
