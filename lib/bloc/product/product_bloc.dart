import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../api_resfull/user_repository.dart';
import '../../l10n/key_text.dart';
import '../../src/app_const.dart';
import '../../src/base.dart';
import '../../src/models/model_generator/product_response.dart';
import '../../src/models/model_generator/service_pack_response.dart';
import '../../widgets/listview/list_load_infinity.dart';
import '../../widgets/loading_api.dart';

part 'product_state.dart';
part 'product_event.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final UserRepository userRepository;
  // List<ProductItem>? data;
  List<DataServicePark>? dataServicePack;
  List<String> listId = [];
  LoadMoreController loadMoreController = LoadMoreController();
  ProductBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetListProductState());

  @override
  Stream<ProductState> mapEventToState(ProductEvent event) async* {
    if (event is InitGetListProductEvent) {
      yield* _getListProduct(event.page, event.querySearch, group: event.group);
    }
  }

  Stream<ProductState> _getListProduct(
    String page,
    String querySearch, {
    String? group,
  }) async* {
    LoadingApi().pushLoading();
    try {
      if (querySearch != '' && page == BASE_URL.PAGE_DEFAULT.toString())
        yield LoadingGetListProductState();
      final response = await userRepository.getListProduct(
        page,
        querySearch,
        group,
      );
      if (isSuccess(response.code)) {
        yield SuccessGetListProductState(
          response.data?.product ?? [],
          response.data?.units ?? [],
          response.data?.vats ?? [],
          response.data?.total ?? 0,
        );
        // if (page == BASE_URL.PAGE_DEFAULT.toString()) {
        //   data = [];
        //   data = response.data?.product ?? [];
        //   yield SuccessGetListProductState(
        //     response.data?.product ?? [],
        //     response.data?.units ?? [],
        //     response.data?.vats ?? [],
        //     response.data?.total ?? 0,
        //   );
        // } else {
        //   data = [
        //     ...data ?? [],
        //     ...response.data?.product ?? [],
        //   ];
        //   yield SuccessGetListProductState(
        //     data ?? [],
        //     response.data?.units ?? [],
        //     response.data?.vats ?? [],
        //     response.data?.total ?? 0,
        //   );
        // }
      } else
        yield ErrorGetListProductState(response.msg ?? '');
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorGetListProductState(getT(KeyT.an_error_occurred));
    }
    LoadingApi().popLoading();
  }

  Future<dynamic> getServicePack({
    String? txt,
    int page = BASE_URL.PAGE_DEFAULT,
  }) async {
    LoadingApi().pushLoading();
    try {
      final response = await userRepository.getServicePack(
        txt: txt,
        page: page.toString(),
      );
      if (isSuccess(response.code)) {
        LoadingApi().popLoading();
        return response.data ?? [];
      } else if (isFail(response.code)) {
        loginSessionExpired();
      } else {
        LoadingApi().popLoading();
        return response.msg ?? '';
      }
    } catch (e) {
      LoadingApi().popLoading();
    }
  }

  Future<Map<String, dynamic>> getProductServicePack(String id) async {
    LoadingApi().pushLoading();
    Map<String, dynamic> result = {
      'mess': '',
      'list': [],
    };
    try {
      final response = await userRepository.getProductServicePack(id: id);
      if (isSuccess(response.code)) {
        LoadingApi().popLoading();
        result['mess'] = '';
        result['list'] = response.data;
        //data
      } else if (isFail(response.code)) {
        LoadingApi().popLoading();
        loginSessionExpired();
      } else {
        result['mess'] = response.msg ?? '';
        LoadingApi().popLoading();
      }
    } catch (e) {
      result['mess'] = e.toString();
      LoadingApi().popLoading();
    }
    return result;
  }

  static ProductBloc of(BuildContext context) =>
      BlocProvider.of<ProductBloc>(context);
}
