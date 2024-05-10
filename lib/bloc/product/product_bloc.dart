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



  LoadMoreController loadMoreControllerProduct = LoadMoreController();


  Future<dynamic> getListProduct({
    int page = BASE_URL.PAGE_DEFAULT,
    String? querySearch,
    String? group,
  }) async {
    dynamic resDynamic = '';
    try {
      final response = await userRepository.getListProduct(
        page.toString(),
        querySearch ?? '',
        group ?? '',
      );
      if (isSuccess(response.code)) {
        resDynamic = response.data?.product ?? [];
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
