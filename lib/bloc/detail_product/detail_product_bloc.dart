import 'package:dartx/dartx.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/widgets/loading_api.dart';
import '../../api_resfull/user_repository.dart';
import '../../l10n/key_text.dart';
import '../../src/app_const.dart';
import '../../src/base.dart';
import '../../src/models/model_generator/detail_product_module_response.dart';
import '../../src/models/model_generator/products_response.dart';

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
    yield LoadingDetailProductState();
    try {
      final response = await userRepository.getDetailProduct(id: id);
      if (isSuccess(response.code)) {
        yield UpdateGetDetailProductState(
          response,
          response.info,
        );
      } else if (isFail(response.code)) {
        loginSessionExpired();
      } else {
        yield ErrorGetDetailProductState(response.msg ?? '');
      }
    } catch (e) {
      yield ErrorGetDetailProductState(getT(KeyT.an_error_occurred));
    }
  }

  Future<ProductsRes?> getDetailProductQR({required String id}) async {
    try {
      final response = await userRepository.getDetailProduct(id: id);
      if (isSuccess(response.code)) {
        return response.info;
      }
    } catch (e) {
       return null;
    }
    return null;
  }

  Stream<DetailProductState> _deleteProduct({required String id}) async* {
    Loading().showLoading();
    try {
      yield LoadingDeleteProductState();
      final response = await userRepository.deleteProduct(id: id);
      final statusCode =
          (response as Map<String, dynamic>).getOrElse('code', () => -1);
      final msg = response.getOrElse('msg', () => -1);
      if (isSuccess(statusCode)) {
        yield SuccessDeleteProductState();
      } else if (isFail(statusCode)) {
        loginSessionExpired();
      } else
        yield ErrorDeleteProductState(msg);
    } catch (e) {
      Loading().popLoading();
      yield ErrorDeleteProductState(getT(KeyT.an_error_occurred));
      throw e;
    }
    Loading().popLoading();
  }

  static DetailProductBloc of(BuildContext context) =>
      BlocProvider.of<DetailProductBloc>(context);
}
