import 'package:dartx/dartx.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/models/product_model.dart';
import 'package:gen_crm/src/models/model_generator/product_response.dart';
import 'package:gen_crm/widgets/loading_api.dart';
import '../../api_resfull/user_repository.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../../src/app_const.dart';
import '../../src/base.dart';

import '../../src/models/model_generator/detail_product_module_response.dart';

part 'detail_product_event.dart';
part 'detail_product_state.dart';

class DetailProductBloc extends Bloc<DetailProductEvent, DetailProductState> {
  final UserRepository userRepository;

  DetailProductBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetDetailProduct());

  @override
  Stream<DetailProductState> mapEventToState(DetailProductEvent event) async* {
    if (event is InitGetDetailProductEvent) {
      yield* _getDetailProduct(id: event.id);
    } else if (event is DeleteProductEvent) {
      yield* _deleteProduct(id: event.id);
    }
  }

  Stream<DetailProductState> _getDetailProduct({required String id}) async* {
    LoadingApi().pushLoading();
    try {
      final response = await userRepository.getDetailProduct(id: id);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield UpdateGetDetailProductState(
            response,
            ProductModel(
                response.info?.productId ?? '',
                1,
                ProductItem(
                  response.info?.productId,
                  response.info?.productCode,
                  response.info?.productEdit,
                  response.info?.productName,
                  response.info?.dvt,
                  response.info?.vat,
                  response.info?.sellPrice.toString(),
                ),
                '0',
                response.info?.nameDvt ?? '',
                response.info?.nameVat ?? '',
                ''));
      } else if (response.code == BASE_URL.SUCCESS_999) {
        loginSessionExpired();
      } else {
        LoadingApi().popLoading();
        yield ErrorGetDetailProductState(response.msg ?? '');
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorGetDetailProductState(
          AppLocalizations.of(Get.context!)?.an_error_occurred ?? '');
      throw e;
    }
    LoadingApi().popLoading();
  }

  Future<ProductModel> getDetailProductQR({required String id}) async {
    final response = await userRepository.getDetailProduct(id: id);
    return ProductModel(
        response.info?.productId ?? '',
        1,
        ProductItem(
          response.info?.productId,
          response.info?.productCode,
          response.info?.productEdit,
          response.info?.productName,
          response.info?.dvt,
          response.info?.vat,
          response.info?.sellPrice.toString(),
        ),
        '0',
        response.info?.nameDvt ?? '',
        response.info?.nameVat ?? '',
        '');
  }

  Stream<DetailProductState> _deleteProduct({required String id}) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingDeleteProductState();
      final response = await userRepository.deleteProduct(id: id);
      final statusCode =
          (response as Map<String, dynamic>).getOrElse('code', () => -1);
      final msg = response.getOrElse('msg', () => -1);
      if ((statusCode == BASE_URL.SUCCESS) ||
          (statusCode == BASE_URL.SUCCESS_200)) {
        yield SuccessDeleteProductState();
      } else if (statusCode == BASE_URL.SUCCESS_999) {
        loginSessionExpired();
      } else
        yield ErrorDeleteProductState(msg);
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorDeleteProductState(
          AppLocalizations.of(Get.context!)?.an_error_occurred ?? '');
      throw e;
    }
    LoadingApi().popLoading();
  }

  static DetailProductBloc of(BuildContext context) =>
      BlocProvider.of<DetailProductBloc>(context);
}
