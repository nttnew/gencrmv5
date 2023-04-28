import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/src/models/model_generator/list_product_response.dart';
import 'package:rxdart/rxdart.dart';
import '../../api_resfull/user_repository.dart';
import '../../src/app_const.dart';
import '../../src/base.dart';
import '../../src/messages.dart';
import '../../src/models/model_generator/group_product_response.dart';
import '../../widgets/loading_api.dart';

part 'product_module_state.dart';
part 'product_module_event.dart';

class ProductModuleBloc extends Bloc<ProductModuleEvent, ProductModuleState> {
  final UserRepository userRepository;
  List<ProductModule>? dataList;
  List<DataFilter>? dataFilter;
  bool isLength = true;
  int page = 1;
  String? querySearch;
  String? filter;
  String? type;
  BehaviorSubject<List<Cats>> listType = BehaviorSubject.seeded([]);
  BehaviorSubject<String?> typeStream = BehaviorSubject.seeded(null);

  ProductModuleBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetListProductModuleState());

  @override
  Stream<ProductModuleState> mapEventToState(ProductModuleEvent event) async* {
    if (event is InitGetListProductModuleEvent) {
      yield* _getListProduct(
        page: event.page,
        filter: event.filter,
        querySearch: event.querySearch,
        typeProduct: event.typeProduct,
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

  Stream<ProductModuleState> _getListProduct(
      {int? page,
      String? querySearch,
      String? filter,
      String? typeProduct}) async* {
    LoadingApi().pushLoading();
    if (page == null) {
      page = BASE_URL.PAGE_DEFAULT;
    }
    try {
      if (querySearch != "" && page == 1)
        yield LoadingGetListProductModuleState();
      final response = await userRepository.getListProductModule(
        typeProduct: typeProduct,
        txt: querySearch,
        page: page.toString(),
        filter: filter,
      );
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        if (dataFilter == null) {
          dataFilter = response.data?.dataFilter ?? [];
        }
        if (page == 1) {
          isLength = true;
          yield SuccessGetListProductModuleState(response.data?.lists ?? []);
        } else {
          yield SuccessGetListProductModuleState(
              [...dataList ?? [], ...response.data?.lists ?? []]);
        }
      } else if (response.code == 999) {
        loginSessionExpired();
      } else
        yield ErrorGetListProductModuleState(response.msg ?? '');
    } catch (e) {
      LoadingApi().popLoading();
      loginSessionExpired();
      yield ErrorGetListProductModuleState(MESSAGES.CONNECT_ERROR);
      throw e;
    }
    LoadingApi().popLoading();
  }

  void dispose() {
    isLength = true;
    page = BASE_URL.PAGE_DEFAULT;
    dataList = null;
    querySearch = null;
    filter = null;
    type = null;
    listType.add([]);
    listType.close();
    typeStream.add(null);
    typeStream.close();
    SuccessGetListProductModuleState([]);
  }

  static ProductModuleBloc of(BuildContext context) =>
      BlocProvider.of<ProductModuleBloc>(context);
}
