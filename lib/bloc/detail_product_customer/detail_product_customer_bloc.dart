import 'package:dartx/dartx.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/widgets/loading_api.dart';
import '../../api_resfull/user_repository.dart';
import '../../src/app_const.dart';
import '../../src/base.dart';
import '../../src/messages.dart';
import '../../src/models/model_generator/detail_product_customer_response.dart';

part 'detail_product_customer_event.dart';
part 'detail_product_customer_state.dart';

class DetailProductCustomerBloc
    extends Bloc<DetailProductCustomerEvent, DetailProductCustomerState> {
  final UserRepository userRepository;

  DetailProductCustomerBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetDetailProduct());

  @override
  Stream<DetailProductCustomerState> mapEventToState(
      DetailProductCustomerEvent event) async* {
    if (event is InitGetDetailProductCustomerEvent) {
      yield* _getDetailProduct(id: event.id);
    } else if (event is DeleteProductEvent) {
      yield* _deleteProduct(id: event.id);
    }
  }

  Stream<DetailProductCustomerState> _getDetailProduct(
      {required String id}) async* {
    LoadingApi().pushLoading();
    try {
      final response = await userRepository.getDetailProductCustomer(id: id);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield UpdateGetDetailProductCustomerState(response);
      } else if (response.code == 999) {
        loginSessionExpired();
      } else {
        yield ErrorGetDetailProductCustomerState(response.msg ?? '');
        LoadingApi().popLoading();
      }
    } catch (e) {
      yield ErrorGetDetailProductCustomerState(MESSAGES.CONNECT_ERROR);
      LoadingApi().popLoading();
      loginSessionExpired();
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<DetailProductCustomerState> _deleteProduct(
      {required String id}) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingDeleteProductState();
      final response = await userRepository.deleteProductCustomer(id: id);
      final statusCode =
          (response as Map<String, dynamic>).getOrElse('code', () => -1);
      final msg = response.getOrElse('msg', () => -1);
      if ((statusCode == BASE_URL.SUCCESS) ||
          (statusCode == BASE_URL.SUCCESS_200)) {
        yield SuccessDeleteProductState();
      } else if (statusCode == 999) {
        loginSessionExpired();
      } else
        yield ErrorDeleteProductState(msg);
    } catch (e) {
      LoadingApi().popLoading();
      loginSessionExpired();
      yield ErrorDeleteProductState(MESSAGES.CONNECT_ERROR);
      throw e;
    }
    LoadingApi().popLoading();
  }

  static DetailProductCustomerBloc of(BuildContext context) =>
      BlocProvider.of<DetailProductCustomerBloc>(context);
}
