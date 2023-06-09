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
import '../../widgets/listview_loadmore_base.dart';

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

  Stream<DetailProductCustomerState> _getDetailProduct(
      {required String id}) async* {
    LoadingApi().pushLoading();
    try {
      final response = await userRepository.getDetailProductCustomer(id: id);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield GetDetailProductCustomerState(response);
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

  Future<dynamic> getListCVProductCustomer(
      {required int id,
      int page = BASE_URL.PAGE_DEFAULT,
      bool isInit = true}) async {
    if (isInit) {
      LoadingApi().pushLoading();
    }
    try {
      final response =
          await userRepository.getListCVProductCustomer(spkh: id, page: page);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        LoadingApi().popLoading();
        return response.data?.data?.dataList ?? [];
      } else if (response.code == 999) {
        LoadingApi().popLoading();
        loginSessionExpired();
      } else {
        LoadingApi().popLoading();
        return response.msg ?? '';
      }
    } catch (e) {
      LoadingApi().popLoading();
      loginSessionExpired();
    }
  }

  Future<dynamic> getListCHProductCustomer(
      {required int id,
      int page = BASE_URL.PAGE_DEFAULT,
      bool isInit = true}) async {
    if (isInit) {
      LoadingApi().pushLoading();
    }
    try {
      final response =
          await userRepository.getListCHProductCustomer(spkh: id, page: page);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        LoadingApi().popLoading();
        return response.data?.lists ?? [];
      } else if (response.code == 999) {
        LoadingApi().popLoading();
        loginSessionExpired();
      } else {
        LoadingApi().popLoading();
        return response.msg ?? '';
      }
    } catch (e) {
      LoadingApi().popLoading();
      loginSessionExpired();
    }
  }

  Future<dynamic> getListHDProductCustomer(
      {required int id,
      int page = BASE_URL.PAGE_DEFAULT,
      bool isInit = true}) async {
    if (isInit) {
      LoadingApi().pushLoading();
    }
    try {
      final response =
          await userRepository.getListHDProductCustomer(spkh: id, page: page);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        LoadingApi().popLoading();
        return response.data ?? [];
      } else if (response.code == 999) {
        LoadingApi().popLoading();
        loginSessionExpired();
      } else {
        LoadingApi().popLoading();
        return response.msg ?? '';
      }
    } catch (e) {
      LoadingApi().popLoading();
      loginSessionExpired();
    }
  }

  Future<dynamic> getListHTProductCustomer(
      {required int id,
      int page = BASE_URL.PAGE_DEFAULT,
      bool isInit = true}) async {
    if (isInit) {
      LoadingApi().pushLoading();
    }
    try {
      final response =
          await userRepository.getListHTProductCustomer(spkh: id, page: page);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        LoadingApi().popLoading();
        return response.data ?? [];
      } else if (response.code == 999) {
        LoadingApi().popLoading();
        loginSessionExpired();
      } else {
        LoadingApi().popLoading();
        return response.msg ?? '';
      }
    } catch (e) {
      LoadingApi().popLoading();
      loginSessionExpired();
    }
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

  dispose() {
    controllerCv.dispose();
    controllerCh.dispose();
    controllerHd.dispose();
    controllerHt.dispose();
  }

  initController(String idTxt) async {
    final int id = int.parse(idTxt);
    final dataCv = await getListCVProductCustomer(
        page: BASE_URL.PAGE_DEFAULT, id: id, isInit: false);
    await controllerCv.initData(dataCv);
    final dataCh = await getListCHProductCustomer(
        page: BASE_URL.PAGE_DEFAULT, id: id, isInit: false);
    await controllerCh.initData(dataCh);
    final dataHd = await getListHDProductCustomer(
        page: BASE_URL.PAGE_DEFAULT, id: id, isInit: false);
    await controllerHd.initData(dataHd);
    final dataHt = await getListHTProductCustomer(
        page: BASE_URL.PAGE_DEFAULT, id: id, isInit: false);
    await controllerHt.initData(dataHt);
  }

  static DetailProductCustomerBloc of(BuildContext context) =>
      BlocProvider.of<DetailProductCustomerBloc>(context);
}
