import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/src/models/model_generator/detail_customer.dart';
import 'package:gen_crm/widgets/loading_api.dart';
import '../../api_resfull/user_repository.dart';
import '../../src/app_const.dart';
import '../../src/base.dart';
import '../../src/messages.dart';
import '../../src/models/model_generator/customer.dart';

part 'detail_customer_event.dart';
part 'detail_customer_state.dart';

class DetailCustomerBloc
    extends Bloc<DetailCustomerEvent, DetailCustomerState> {
  final UserRepository userRepository;
  String? sdt;
  List<CustomerData>? listCus;

  DetailCustomerBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetDetailCustomer());

  @override
  Stream<DetailCustomerState> mapEventToState(
      DetailCustomerEvent event) async* {
    if (event is InitGetDetailCustomerEvent) {
      yield* _getDetailCustomer(id: event.id);
    } else if (event is DeleteCustomerEvent) {
      yield* _deleteCustomer(id: event.id);
    } else if (event is ReloadCustomerEvent) {
      yield UpdateGetDetailCustomerState(
          [],
          CustomerNote(
            null,
            null,
            null,
            null,
          ));
    }
  }

  Stream<DetailCustomerState> _getDetailCustomer({required int id}) async* {
    LoadingApi().pushLoading();
    try {
      final response = await userRepository.getDetailCustomer(id);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        try {
          sdt = response.data?.customer_info?[0].data
              ?.firstWhere((element) => element.id == 'di_dong')
              .value_field
              .toString();
        } catch (e) {
          throw e;
        }
        yield UpdateGetDetailCustomerState(
            response.data!.customer_info!, response.data!.customer_note!);
      } else if (response.code == 999) {
        loginSessionExpired();
      } else {
        yield ErrorGetDetailCustomerState(response.msg ?? '');
        LoadingApi().popLoading();
      }
    } catch (e) {
      yield ErrorGetDetailCustomerState(MESSAGES.CONNECT_ERROR);
      LoadingApi().popLoading();
      loginSessionExpired();
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<DetailCustomerState> _deleteCustomer({required int id}) async* {
    LoadingApi().pushLoading();
    try {
      final response = await userRepository.deleteCustomer({"id": id});
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield SuccessDeleteCustomerState();
      } else if (response.code == 999) {
        loginSessionExpired();
      } else {
        yield ErrorDeleteCustomerState(response.msg ?? '');
      }
    } catch (e) {
      yield ErrorDeleteCustomerState(MESSAGES.CONNECT_ERROR);
      LoadingApi().popLoading();
      loginSessionExpired();
      throw e;
    }
    LoadingApi().popLoading();
  }

  static DetailCustomerBloc of(BuildContext context) =>
      BlocProvider.of<DetailCustomerBloc>(context);
}
