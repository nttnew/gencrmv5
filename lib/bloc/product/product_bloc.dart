import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../api_resfull/user_repository.dart';
import '../../src/base.dart';
import '../../src/messages.dart';
import '../../src/models/model_generator/product_response.dart';
import '../../widgets/loading_api.dart';

part 'product_state.dart';
part 'product_event.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final UserRepository userRepository;

  ProductBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetListProductState());

  @override
  Stream<ProductState> mapEventToState(ProductEvent event) async* {
    if (event is InitGetListProductEvent) {
      yield* _getListProduct(event.page, event.querySearch);
    }
  }

  List<ProductItem>? data;

  Stream<ProductState> _getListProduct(String page, String querySearch) async* {
    LoadingApi().pushLoading();
    try {
      if (querySearch != "" && page == "1") yield LoadingGetListProductState();
      final response = await userRepository.getListProduct(page, querySearch);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        if (page == "1") {
          data = response.data!.product;
          yield SuccessGetListProductState(
              response.data!.product!,
              response.data!.units!,
              response.data!.vats!,
              response.data!.total!);
        } else {
          data = [...data!, ...response.data!.product!];
          yield SuccessGetListProductState(data!, response.data!.units!,
              response.data!.vats!, response.data!.total!);
        }
      } else
        yield ErrorGetListProductState(response.msg ?? '');
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorGetListProductState(MESSAGES.CONNECT_ERROR);
      throw e;
    }
    LoadingApi().popLoading();
  }

  static ProductBloc of(BuildContext context) =>
      BlocProvider.of<ProductBloc>(context);
}
