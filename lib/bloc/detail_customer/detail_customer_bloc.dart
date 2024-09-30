import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/src/models/model_generator/detail_customer.dart';
import 'package:gen_crm/widgets/loading_api.dart';
import '../../api_resfull/user_repository.dart';
import '../../l10n/key_text.dart';
import '../../src/base.dart';
import '../../src/models/model_generator/customer.dart';
import '../../widgets/listview/list_load_infinity.dart';

part 'detail_customer_event.dart';
part 'detail_customer_state.dart';

class DetailCustomerBloc
    extends Bloc<DetailCustomerEvent, DetailCustomerState> {
  final UserRepository userRepository;
  String? sdt;
  String? name;
  List<CustomerData>? listCus;
  LoadMoreController controllerDM = LoadMoreController();
  LoadMoreController controllerCH = LoadMoreController();
  LoadMoreController controllerHD = LoadMoreController();
  LoadMoreController controllerCV = LoadMoreController();
  LoadMoreController controllerHT = LoadMoreController();

  DetailCustomerBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetDetailCustomer());

  @override
  Stream<DetailCustomerState> mapEventToState(
    DetailCustomerEvent event,
  ) async* {
    if (event is InitGetDetailCustomerEvent) {
      yield* _getDetailCustomer(id: event.id);
    } else if (event is DeleteCustomerEvent) {
      yield* _deleteCustomer(id: event.id);
    } else if (event is ReloadCustomerEvent) {
      yield UpdateGetDetailCustomerState(
        [],
        CustomerNote(
          null,
          null,
          null,
          null,
        ),
      );
    }
  }

  Stream<DetailCustomerState> _getDetailCustomer({required int id}) async* {
    yield LoadingDetailCustomerState();
    try {
      final response = await userRepository.getDetailCustomer(id);
      if (isSuccess(response.code)) {
        try {
          InfoItem? item = response.data?.customer_info?.first.data?.firstWhere(
            (element) => element.id == 'di_dong',
          );
          InfoItem? itemName =
              response.data?.customer_info?.first.data?.firstWhere(
            (element) => element.id == 'ten_khach_hang',
          );
          if (item != null && item.id != '') sdt = item.value_field.toString();
          if (itemName != null && itemName.id != '')
            name = itemName.value_field.toString();
        } catch (e) {
          sdt = '';
          name = '';
        }
        yield UpdateGetDetailCustomerState(
          response.data?.customer_info ?? [],
          response.data!.customer_note!,
        );
      } else {
        yield ErrorGetDetailCustomerState(response.msg ?? '');
      }
    } catch (e) {
      yield ErrorGetDetailCustomerState(getT(KeyT.an_error_occurred));
    }
  }

  Stream<DetailCustomerState> _deleteCustomer({
    required int id,
  }) async* {
    Loading().showLoading();
    try {
      final response = await userRepository.deleteCustomer({
        'id': id,
      });
      if (isSuccess(response.code)) {
        yield SuccessDeleteCustomerState();
      } else {
        yield ErrorDeleteCustomerState(response.msg ?? '');
      }
    } catch (e) {
      Loading().popLoading();
      yield ErrorDeleteCustomerState(getT(KeyT.an_error_occurred));
    }
    Loading().popLoading();
  }

  Future<dynamic> getClueCustomer({
    required int id,
    int page = BASE_URL.PAGE_DEFAULT,
  }) async {
    try {
      final response = await userRepository.getClueCustomer(id, page);
      if (isSuccess(response.code)) {
        return response.data ?? [];
      } else {
        return response.msg ?? '';
      }
    } catch (e) {
      return getT(KeyT.an_error_occurred);
    }
  }

  Future<dynamic> getChanceCustomer({
    required int id,
    int page = BASE_URL.PAGE_DEFAULT,
  }) async {
    try {
      final response = await userRepository.getChanceCustomer(id, page);
      if (isSuccess(response.code)) {
        return response.data ?? [];
      } else {
        return response.msg ?? '';
      }
    } catch (e) {
      return getT(KeyT.an_error_occurred);
    }
  }

  Future<dynamic> getContractCustomer({
    required int id,
    int page = BASE_URL.PAGE_DEFAULT,
  }) async {
    try {
      final response = await userRepository.getContractCustomer(id, page);
      if (isSuccess(response.code)) {
        return response.data ?? [];
      } else {
        return response.msg ?? '';
      }
    } catch (e) {
      return getT(KeyT.an_error_occurred);
    }
  }

  Future<dynamic> getSupportCustomer({
    required int id,
    int page = BASE_URL.PAGE_DEFAULT,
  }) async {
    try {
      final response = await userRepository.getSupportCustomer(id, page);
      if (isSuccess(response.code)) {
        return response.data ?? [];
      } else {
        return response.msg ?? '';
      }
    } catch (e) {
      return getT(KeyT.an_error_occurred);
    }
  }

  Future<dynamic> getJobCustomer({
    required int id,
    int page = BASE_URL.PAGE_DEFAULT,
  }) async {
    try {
      final response = await userRepository.getJobCustomer(id, page);
      if (isSuccess(response.code)) {
        return response.data ?? [];
      } else {
        return response.msg ?? '';
      }
    } catch (e) {
      return getT(KeyT.an_error_occurred);
    }
  }

  static DetailCustomerBloc of(BuildContext context) =>
      BlocProvider.of<DetailCustomerBloc>(context);
}
