import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/widgets/loading_api.dart';
import 'package:rxdart/rxdart.dart';
import '../../api_resfull/user_repository.dart';
import '../../l10n/key_text.dart';
import '../../src/app_const.dart';
import '../../src/base.dart';
import '../../src/models/model_generator/customer.dart';
import '../../src/models/model_generator/customer_clue.dart';
import '../../widgets/listview/list_load_infinity.dart';

part 'customer_event.dart';
part 'customer_state.dart';

class GetListCustomerBloc extends Bloc<GetListCustomerEvent, CustomerState> {
  final UserRepository userRepository;
  BehaviorSubject<List<Customer>> listType = BehaviorSubject.seeded([]);
  LoadMoreController loadMoreController = LoadMoreController();
  String idFilter = '';
  String search = '';
  String ids = '';
  GetListCustomerBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetListCustomer());

  @override
  Stream<CustomerState> mapEventToState(GetListCustomerEvent event) async* {
    if (event is AddCustomerIndividualEvent) {
      yield* _AddCustomerIndividual(data: event.data, files: event.files);
    }
  }

  dispose() {
    idFilter = '';
    search = '';
    ids = '';
  }

  Future<ListCustomerResponse?> getListCustomerQR({
    int page = BASE_URL.PAGE_DEFAULT,
    String? qr,
  }) async {
    Loading().showLoading();
    try {
      final response = await userRepository.getListCustomer(
        page,
        '',
        '', // get data theo qr lên k cần
        null,
        qr,
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

  Future<dynamic> getListCustomer({
    int page = BASE_URL.PAGE_DEFAULT,
  }) async {
    dynamic resDynamic = '';
    try {
      final response = await userRepository.getListCustomer(
        page,
        idFilter,
        search,
        ids,
        null, // vì quét qr chỉ lấy 1
      );
      if (isSuccess(response.code)) {
        if (page == BASE_URL.PAGE_DEFAULT)
          listType.add(response.data?.filter ?? []);
        resDynamic = response.data?.list ?? [];
      } else if (isFail(response.code)) {
        loginSessionExpired();
      } else {
        resDynamic = response.msg ?? '';
      }
    } catch (e) {
      resDynamic = getT(KeyT.an_error_occurred);
      return resDynamic;
    }
    return resDynamic;
  }

  Stream<CustomerState> _AddCustomerIndividual({
    required Map<String, dynamic> data,
    List<File>? files,
  }) async* {
    yield LoadingListCustomerState();
    Loading().showLoading();
    try {
      final response = await userRepository.addIndividualCustomer(data: data);

      if (isSuccess(response.code)) {
        if (files != null && files.length > 0) {
          final responseUpload = await userRepository.uploadMultiFileBase(
              id: response.data?.id.toString() ?? '',
              files: files,
              module: getURLModule(Module.KHACH_HANG));
          if (isSuccess(responseUpload.code)) {
            Loading().popLoading();
            yield SuccessAddCustomerIndividualState(
                ['${response.id}', '${response.name}']);
          } else {
            Loading().popLoading();
            yield ErrorAddCustomerIndividualState(responseUpload.msg ?? '');
          }
        } else {
          Loading().popLoading();
          yield SuccessAddCustomerIndividualState(
              ['${response.id}', '${response.name}']);
        }
      } else if (isFail(response.code)) {
        loginSessionExpired();
      } else {
        Loading().popLoading();
        yield ErrorAddCustomerIndividualState(response.msg ?? '');
      }
    } catch (e) {
      Loading().popLoading();
      yield ErrorAddCustomerIndividualState(getT(KeyT.an_error_occurred));
      throw e;
    }
    Loading().popLoading();
  }

  static GetListCustomerBloc of(BuildContext context) =>
      BlocProvider.of<GetListCustomerBloc>(context);
}
