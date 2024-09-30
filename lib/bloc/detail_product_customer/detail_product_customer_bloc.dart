import 'package:dartx/dartx.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/widgets/loading_api.dart';
import '../../api_resfull/user_repository.dart';
import '../../l10n/key_text.dart';
import '../../src/base.dart';
import '../../src/models/model_generator/detail_product_customer_response.dart';
import '../../widgets/listview/list_load_infinity.dart';

part 'detail_product_customer_event.dart';
part 'detail_product_customer_state.dart';

class DetailProductCustomerBloc
    extends Bloc<DetailProductCustomerEvent, DetailProductCustomerState> {
  final UserRepository userRepository;
  LoadMoreController controllerCv = LoadMoreController();
  LoadMoreController controllerCh = LoadMoreController();
  LoadMoreController controllerHd = LoadMoreController();
  LoadMoreController controllerHt = LoadMoreController();

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

  Stream<DetailProductCustomerState> _getDetailProduct({
    required String id,
  }) async* {
    Loading().showLoading();
    try {
      yield LoadingDetailProductCustomerState();
      final response = await userRepository.getDetailProductCustomer(id: id);
      if (isSuccess(response.code)) {
        Loading().popLoading();
        yield GetDetailProductCustomerState(response);
      } else {
        Loading().popLoading();
        yield ErrorGetDetailProductCustomerState(response.msg ?? '');
      }
    } catch (e) {
      Loading().popLoading();
      yield ErrorGetDetailProductCustomerState(getT(KeyT.an_error_occurred));
    }
  }

  Future<dynamic> getListCVProductCustomer({
    required int id,
    int page = BASE_URL.PAGE_DEFAULT,
  }) async {
    try {
      final response =
          await userRepository.getListCVProductCustomer(spkh: id, page: page);
      if (isSuccess(response.code)) {
        return response.data?.data?.dataList ?? [];
      } else {
        return response.msg ?? '';
      }
    } catch (e) {
      return getT(KeyT.an_error_occurred);
    }
  }

  Future<dynamic> getListCHProductCustomer({
    required int id,
    int page = BASE_URL.PAGE_DEFAULT,
  }) async {
    try {
      final response =
          await userRepository.getListCHProductCustomer(spkh: id, page: page);
      if (isSuccess(response.code)) {
        return response.data?.lists ?? [];
      } else {
        return response.msg ?? '';
      }
    } catch (e) {
      return getT(KeyT.an_error_occurred);
    }
  }

  Future<dynamic> getListHDProductCustomer({
    required int id,
    int page = BASE_URL.PAGE_DEFAULT,
  }) async {
    try {
      final response =
          await userRepository.getListHDProductCustomer(spkh: id, page: page);
      if (isSuccess(response.code)) {
        return response.data ?? [];
      } else {
        return response.msg ?? '';
      }
    } catch (e) {
      return getT(KeyT.an_error_occurred);
    }
  }

  Future<dynamic> getListHTProductCustomer({
    required int id,
    int page = BASE_URL.PAGE_DEFAULT,
  }) async {
    try {
      final response =
          await userRepository.getListHTProductCustomer(spkh: id, page: page);
      if (isSuccess(response.code)) {
        return response.data ?? [];
      } else {
        return response.msg ?? '';
      }
    } catch (e) {
      return getT(KeyT.an_error_occurred);
    }
  }

  Stream<DetailProductCustomerState> _deleteProduct({
    required String id,
  }) async* {
    Loading().showLoading();
    try {
      yield LoadingDeleteProductState();
      final response = await userRepository.deleteProductCustomer(id: id);
      final statusCode =
          (response as Map<String, dynamic>).getOrElse('code', () => -1);
      final msg = response.getOrElse('msg', () => -1);
      if (isSuccess(statusCode)) {
        yield SuccessDeleteProductState();
      } else
        yield ErrorDeleteProductState(msg);
    } catch (e) {
      Loading().popLoading();
      yield ErrorDeleteProductState(getT(KeyT.an_error_occurred));
    }
    Loading().popLoading();
  }

  dispose() {
    controllerCv.dispose();
    controllerCh.dispose();
    controllerHd.dispose();
    controllerHt.dispose();
  }

  static DetailProductCustomerBloc of(BuildContext context) =>
      BlocProvider.of<DetailProductCustomerBloc>(context);
}
