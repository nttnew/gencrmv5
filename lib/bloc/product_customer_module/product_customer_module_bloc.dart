import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../api_resfull/user_repository.dart';
import '../../l10n/key_text.dart';
import '../../src/app_const.dart';
import '../../src/base.dart';
import '../../src/models/model_generator/customer_clue.dart';
import '../../src/models/model_generator/group_product_response.dart';
import '../../src/models/model_generator/list_product_customer_response.dart';
import '../../widgets/listview/list_load_infinity.dart';
import '../../widgets/loading_api.dart';

part 'product_customer_module_state.dart';
part 'product_customer_module_event.dart';

class ProductCustomerModuleBloc
    extends Bloc<ProductCustomerModuleEvent, ProductCustomerModuleState> {
  final UserRepository userRepository;
  String? querySearch;
  String? ids;
  String? filter;
  String? type;
  BehaviorSubject<List<Cats>> listType = BehaviorSubject.seeded([]);
  BehaviorSubject<List<Customer>> listFilter = BehaviorSubject.seeded([]);
  BehaviorSubject<String?> typeStream = BehaviorSubject.seeded(null);
  LoadMoreController loadMoreController = LoadMoreController();

  ProductCustomerModuleBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetListProductCustomerModuleState());

  void getFilter() async {
    final response = await userRepository.getGroupProduct();
    if ((response.code == BASE_URL.SUCCESS) ||
        (response.code == BASE_URL.SUCCESS_200)) {
      listType.add(response.data?.cats ?? []);
    }
  }

  Future<dynamic> getListProduct({
    int page = BASE_URL.PAGE_DEFAULT,
  }) async {
    dynamic resDynamic = '';
    try {
      final response = await userRepository.getListProductCustomer(
        txt: querySearch,
        page: page.toString(),
        filter: filter,
      );
      if (isSuccess(response.code)) {
        if (listFilter.value.isEmpty) {
          listFilter.add(response.data?.dataFilter ?? []);
        }
        resDynamic = response.data?.lists ?? [];
      } else if (isFail(response.code)) {
        loginSessionExpired();
      } else
        resDynamic = response.msg ?? '';
    }  catch (e) {
      resDynamic = getT(KeyT.an_error_occurred);
      return resDynamic;
    }
    return resDynamic;
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
      if (isSuccess(response.code)) {
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
    querySearch = null;
    filter = null;
    type = null;
    SuccessGetListProductCustomerModuleState([]);
  }

  static ProductCustomerModuleBloc of(BuildContext context) =>
      BlocProvider.of<ProductCustomerModuleBloc>(context);
}
