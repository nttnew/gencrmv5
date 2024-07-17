import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/src/models/model_generator/list_product_response.dart';
import 'package:rxdart/rxdart.dart';
import '../../api_resfull/user_repository.dart';
import '../../l10n/key_text.dart';
import '../../src/app_const.dart';
import '../../src/base.dart';
import '../../src/models/model_generator/customer_clue.dart';
import '../../src/models/model_generator/group_product_response.dart';
import '../../widgets/listview/list_load_infinity.dart';
import '../../widgets/loading_api.dart';

part 'product_module_state.dart';
part 'product_module_event.dart';

class ProductModuleBloc extends Bloc<ProductModuleEvent, ProductModuleState> {
  final UserRepository userRepository;
  LoadMoreController loadMoreController = LoadMoreController();
  String? querySearch;
  String? filter;
  String? type;
  String? ids;
  BehaviorSubject<List<Cats>> listType = BehaviorSubject.seeded([]);
  BehaviorSubject<List<Customer>> listFilter = BehaviorSubject.seeded([]);

  ProductModuleBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetListProductModuleState());

  void getFilter() async {
    final response = await userRepository.getGroupProduct();
    if ((response.code == BASE_URL.SUCCESS) ||
        (response.code == BASE_URL.SUCCESS_200)) {
      listType.add(response.data?.cats ?? []);
    }
  }

  Future<dynamic> getListProductMain({
    int page = BASE_URL.PAGE_DEFAULT,
  }) async {
    dynamic resDynamic = '';
    try {
      final response = await userRepository.getListProductModule(
        typeProduct: type,
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
    } catch (e) {
      resDynamic = getT(KeyT.an_error_occurred);
      return resDynamic;
    }
    return resDynamic;
  }

  Future<ListProductResponse?> getListProduct({
    required String querySearch,
  }) async {
    Loading().showLoading();
    try {
      final response = await userRepository.getListProductModule(
        txt: querySearch,
        page: BASE_URL.PAGE_DEFAULT.toString(),
      );
      if (isSuccess(response.code)) {
        Loading().popLoading();
        return response;
      }
    } catch (e) {
      throw e;
    }
    Loading().popLoading();
    return null;
  }

  void dispose() {
    listType.add([]);
    querySearch = null;
    filter = null;
    type = null;
    SuccessGetListProductModuleState([]);
  }

  static ProductModuleBloc of(BuildContext context) =>
      BlocProvider.of<ProductModuleBloc>(context);
}
