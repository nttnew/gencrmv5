import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../api_resfull/user_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import '../../src/app_const.dart';
import '../../src/base.dart';
import '../../src/models/model_generator/group_product_response.dart';
import '../../src/models/model_generator/list_product_customer_response.dart';
import '../../widgets/loading_api.dart';

part 'product_customer_module_state.dart';
part 'product_customer_module_event.dart';

class ProductCustomerModuleBloc
    extends Bloc<ProductCustomerModuleEvent, ProductCustomerModuleState> {
  final UserRepository userRepository;
  List<ProductCustomerResponse>? dataList;
  bool isLength = true;
  int page = 1;
  String? querySearch;
  String? ids;
  String? filter;
  String? type;
  BehaviorSubject<List<Cats>> listType = BehaviorSubject.seeded([]);
  BehaviorSubject<List<DataFilter>> listFilter = BehaviorSubject.seeded([]);
  BehaviorSubject<String?> typeStream = BehaviorSubject.seeded(null);

  ProductCustomerModuleBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetListProductCustomerModuleState());

  @override
  Stream<ProductCustomerModuleState> mapEventToState(
      ProductCustomerModuleEvent event) async* {
    if (event is GetProductCustomerModuleEvent) {
      yield* _getListProduct(
        page: event.page,
        filter: event.filter,
        querySearch: event.querySearch,
        ids: event.ids,
      );
    }
  }

  void getFilter() async {
    final response = await userRepository.getGroupProduct();
    if ((response.code == BASE_URL.SUCCESS) ||
        (response.code == BASE_URL.SUCCESS_200)) {
      listType.add(response.data?.cats ?? []);
    }
  }

  Stream<ProductCustomerModuleState> _getListProduct({
    int? page,
    String? querySearch,
    String? filter,
    String? ids,
  }) async* {
    LoadingApi().pushLoading();
    if (page == null) {
      page = BASE_URL.PAGE_DEFAULT;
    }
    try {
      if (querySearch != "" && page == 1)
        yield LoadingGetListProductCustomerModuleState();
      final response = await userRepository.getListProductCustomer(
        txt: querySearch,
        page: page.toString(),
        filter: filter,
      );
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        if (listFilter.value.isEmpty) {
          listFilter.add(response.data?.dataFilter ?? []);
        }
        if (page == 1) {
          isLength = true;
          yield SuccessGetListProductCustomerModuleState(
              response.data?.lists ?? []);
        } else {
          yield SuccessGetListProductCustomerModuleState(
              [...dataList ?? [], ...response.data?.lists ?? []]);
        }
      } else if (response.code == BASE_URL.SUCCESS_999) {
        loginSessionExpired();
      } else
        yield ErrorGetListProductCustomerModuleState(response.msg ?? '');
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorGetListProductCustomerModuleState(
          AppLocalizations.of(Get.context!)?.an_error_occurred ?? '');
      throw e;
    }
    LoadingApi().popLoading();
  }

  Future<ListProductCustomerResponse?> getListProductCustomer({
    required String querySearch,
  }) async {
    LoadingApi().pushLoading();
    try {
      final response = await userRepository.getListProductCustomer(
        txt: querySearch,
        page: BASE_URL.PAGE_DEFAULT.toString(),
      );
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        LoadingApi().popLoading();
        return response;
      }
    } catch (e) {
      throw e;
    }
    LoadingApi().popLoading();
    return null;
  }

  void dispose() {
    listType.add([]);
    typeStream.add(null);
    isLength = true;
    page = BASE_URL.PAGE_DEFAULT;
    dataList = null;
    querySearch = null;
    filter = null;
    type = null;
    SuccessGetListProductCustomerModuleState([]);
  }

  static ProductCustomerModuleBloc of(BuildContext context) =>
      BlocProvider.of<ProductCustomerModuleBloc>(context);
}
