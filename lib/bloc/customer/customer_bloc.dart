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

part 'customer_event.dart';
part 'customer_state.dart';

class GetListCustomerBloc extends Bloc<GetListCustomerEvent, CustomerState> {
  final UserRepository userRepository;
  List<CustomerData>? listCus;
  BehaviorSubject<List<FilterData>> listType = BehaviorSubject.seeded([]);

  GetListCustomerBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetListCustomer());

  @override
  Stream<CustomerState> mapEventToState(GetListCustomerEvent event) async* {
    if (event is InitGetListOrderEvent) {
      yield* _getListCustomer(
          filter: event.filter ?? '',
          page: event.page ?? BASE_URL.PAGE_DEFAULT,
          search: event.search ?? '',
          isLoadMore: event.isLoadMore,
          ids: event.ids ?? '');
    } else if (event is AddCustomerIndividualEvent) {
      yield* _AddCustomerIndividual(data: event.data, files: event.files);
    }
  }

  Stream<CustomerState> _getListCustomer({
    required String filter,
    required int page,
    required String search,
    required String ids,
    bool? isLoadMore = false,
  }) async* {
    LoadingApi().pushLoading();
    try {
      final response = await userRepository.getListCustomer(
        page,
        filter,
        search,
        ids,
      );
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        if (page == 1) {
          listCus = response.data?.list ?? [];
          listType.add(response.data?.filter ?? []);
          yield UpdateGetListCustomerState(
              response.data?.list ?? [], response.data?.total ?? 0);
        } else {
          yield UpdateGetListCustomerState(
              [...listCus ?? [], ...response.data?.list ?? []],
              response.data?.total ?? 0);
          listCus?.addAll(response.data?.list ?? []);
        }
      } else if (response.code == BASE_URL.SUCCESS_999) {
        loginSessionExpired();
      } else {
        LoadingApi().popLoading();
        yield ErrorGetListCustomerState(response.msg ?? '');
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorGetListCustomerState(getT(KeyT.an_error_occurred));
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<CustomerState> _AddCustomerIndividual(
      {required Map<String, dynamic> data, List<File>? files}) async* {
    yield LoadingListCustomerState();
    LoadingApi().pushLoading();
    try {
      final response = await userRepository.addIndividualCustomer(data: data);

      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
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
      } else if (response.code == BASE_URL.SUCCESS_999) {
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
