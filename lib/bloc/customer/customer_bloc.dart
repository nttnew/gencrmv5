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
import '../../widgets/listview/list_load_infinity.dart';

part 'customer_event.dart';
part 'customer_state.dart';

class GetListCustomerBloc extends Bloc<GetListCustomerEvent, CustomerState> {
  final UserRepository userRepository;
  BehaviorSubject<List<FilterData>> listType = BehaviorSubject.seeded([]);
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

  init() {
    idFilter = '';
    search = '';
    ids = '';
  }

  Future<dynamic> getListCustomer({
    int page = BASE_URL.PAGE_DEFAULT,
  }) async {
    LoadingApi().pushLoading();
    dynamic resDynamic = '';
    try {
      final response = await userRepository.getListCustomer(
        page,
        idFilter,
        search,
        ids,
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
      throw e;
    }
    LoadingApi().popLoading();
    return resDynamic;
  }

  Stream<CustomerState> _AddCustomerIndividual({
    required Map<String, dynamic> data,
    List<File>? files,
  }) async* {
    yield LoadingListCustomerState();
    LoadingApi().pushLoading();
    try {
      final response = await userRepository.addIndividualCustomer(data: data);

      if (isSuccess(response.code)) {
        if (files != null) {
          final responseUpload = await userRepository.uploadMultiFileBase(
              id: response.data!.id.toString(),
              files: files,
              module: getURLModule(Module.KHACH_HANG));
          if ((responseUpload.code == BASE_URL.SUCCESS) ||
              (responseUpload.code == BASE_URL.SUCCESS_200)) {
            LoadingApi().popLoading();
            yield SuccessAddCustomerIndividualState(
                ['${response.id}', '${response.name}']);
          } else {
            LoadingApi().popLoading();
            yield ErrorAddCustomerIndividualState(responseUpload.msg ?? '');
          }
        } else {
          LoadingApi().popLoading();
          yield SuccessAddCustomerIndividualState(
              ['${response.id}', '${response.name}']);
        }
      } else if (isFail(response.code)) {
        loginSessionExpired();
      } else {
        LoadingApi().popLoading();
        yield ErrorAddCustomerIndividualState(response.msg ?? '');
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorAddCustomerIndividualState(getT(KeyT.an_error_occurred));
      throw e;
    }
    LoadingApi().popLoading();
  }

  static GetListCustomerBloc of(BuildContext context) =>
      BlocProvider.of<GetListCustomerBloc>(context);
}
