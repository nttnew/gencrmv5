import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/src/models/model_generator/detail_customer.dart';
import 'package:gen_crm/widgets/loading_api.dart';
import '../../api_resfull/user_repository.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../../src/app_const.dart';
import '../../src/base.dart';

import '../../src/models/model_generator/customer.dart';
import '../../widgets/listview_loadmore_base.dart';

part 'detail_customer_event.dart';
part 'detail_customer_state.dart';

class DetailCustomerBloc
    extends Bloc<DetailCustomerEvent, DetailCustomerState> {
  final UserRepository userRepository;
  String? sdt;
  List<CustomerData>? listCus;
  LoadMoreController controllerDM = LoadMoreController();
  LoadMoreController controllerCH = LoadMoreController();
  LoadMoreController controllerHD = LoadMoreController();
  LoadMoreController controllerCV = LoadMoreController();
  LoadMoreController controllerHT = LoadMoreController();

  DetailCustomerBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetDetailCustomer());

  initController(String idTxt) async {
    final int id = int.parse(idTxt);

    final dataDM = await getClueCustomer(
        page: BASE_URL.PAGE_DEFAULT, id: id, isInit: false);
    await controllerDM.initData(dataDM);

    final dataCH = await getChanceCustomer(
        page: BASE_URL.PAGE_DEFAULT, id: id, isInit: false);
    await controllerCH.initData(dataCH);

    final dataHD = await getContractCustomer(
        page: BASE_URL.PAGE_DEFAULT, id: id, isInit: false);
    await controllerHD.initData(dataHD);

    final dataCv = await getJobCustomer(
        page: BASE_URL.PAGE_DEFAULT, id: id, isInit: false);
    await controllerCV.initData(dataCv);

    final dataHT = await getSupportCustomer(
        page: BASE_URL.PAGE_DEFAULT, id: id, isInit: false);
    await controllerHT.initData(dataHT);
  }

  @override
  Stream<DetailCustomerState> mapEventToState(
      DetailCustomerEvent event) async* {
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
          ));
    }
  }

  Stream<DetailCustomerState> _getDetailCustomer({required int id}) async* {
    LoadingApi().pushLoading();
    try {
      final response = await userRepository.getDetailCustomer(id);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        try {
          CustomerInfoItem? item = response.data?.customer_info?.first.data
              ?.firstWhere((element) => element.id == 'di_dong',
                  orElse: () => CustomerInfoItem(
                        '',
                        '',
                        '',
                        '',
                        0,
                        false,
                      ));
          if (item != null && item.id != '') sdt = item.value_field.toString();
        } catch (e) {
          throw e;
        }
        yield UpdateGetDetailCustomerState(
            response.data?.customer_info ?? [], response.data!.customer_note!);
      } else if (response.code == BASE_URL.SUCCESS_999) {
        loginSessionExpired();
      } else {
        LoadingApi().popLoading();
        yield ErrorGetDetailCustomerState(response.msg ?? '');
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorGetDetailCustomerState(
          AppLocalizations.of(Get.context!)?.an_error_occurred ?? '');
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<DetailCustomerState> _deleteCustomer({required int id}) async* {
    LoadingApi().pushLoading();
    try {
      final response = await userRepository.deleteCustomer({"id": id});
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield SuccessDeleteCustomerState();
      } else if (response.code == BASE_URL.SUCCESS_999) {
        loginSessionExpired();
      } else {
        yield ErrorDeleteCustomerState(response.msg ?? '');
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorDeleteCustomerState(
          AppLocalizations.of(Get.context!)?.an_error_occurred ?? '');
      throw e;
    }
    LoadingApi().popLoading();
  }

  Future<dynamic> getClueCustomer(
      {required int id,
      int page = BASE_URL.PAGE_DEFAULT,
      bool isInit = true}) async {
    if (isInit) {
      LoadingApi().pushLoading();
    }
    try {
      final response = await userRepository.getClueCustomer(id, page);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        LoadingApi().popLoading();
        return response.data ?? [];
      } else if (response.code == BASE_URL.SUCCESS_999) {
        LoadingApi().popLoading();
        loginSessionExpired();
      } else {
        LoadingApi().popLoading();
        return response.msg ?? '';
      }
    } catch (e) {
      LoadingApi().popLoading();
    }
  }

  Future<dynamic> getChanceCustomer(
      {required int id,
      int page = BASE_URL.PAGE_DEFAULT,
      bool isInit = true}) async {
    if (isInit) {
      LoadingApi().pushLoading();
    }
    try {
      final response = await userRepository.getChanceCustomer(id, page);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        LoadingApi().popLoading();
        return response.data ?? [];
      } else if (response.code == BASE_URL.SUCCESS_999) {
        loginSessionExpired();
      } else {
        LoadingApi().popLoading();
        return response.msg ?? '';
      }
    } catch (e) {
      LoadingApi().popLoading();
    }
  }

  Future<dynamic> getContractCustomer(
      {required int id,
      int page = BASE_URL.PAGE_DEFAULT,
      bool isInit = true}) async {
    if (isInit) {
      LoadingApi().pushLoading();
    }
    try {
      final response = await userRepository.getContractCustomer(id, page);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        LoadingApi().popLoading();
        return response.data ?? [];
      } else if (response.code == BASE_URL.SUCCESS_999) {
        loginSessionExpired();
      } else {
        LoadingApi().popLoading();
        return response.msg ?? '';
      }
    } catch (e) {
      LoadingApi().popLoading();
    }
  }

  Future<dynamic> getSupportCustomer(
      {required int id,
      int page = BASE_URL.PAGE_DEFAULT,
      bool isInit = true}) async {
    if (isInit) {
      LoadingApi().pushLoading();
    }
    try {
      final response = await userRepository.getSupportCustomer(id, page);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        LoadingApi().popLoading();
        return response.data ?? [];
      } else if (response.code == BASE_URL.SUCCESS_999) {
        loginSessionExpired();
      } else {
        LoadingApi().popLoading();
        return response.msg ?? '';
      }
    } catch (e) {
      LoadingApi().popLoading();
    }
  }

  Future<dynamic> getJobCustomer(
      {required int id,
      int page = BASE_URL.PAGE_DEFAULT,
      bool isInit = true}) async {
    if (isInit) {
      LoadingApi().pushLoading();
    }
    try {
      final response = await userRepository.getJobCustomer(id, page);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        LoadingApi().popLoading();
        return response.data ?? [];
      } else if (response.code == BASE_URL.SUCCESS_999) {
        loginSessionExpired();
      } else {
        LoadingApi().popLoading();
        return response.msg ?? '';
      }
    } catch (e) {
      LoadingApi().popLoading();
    }
  }

  static DetailCustomerBloc of(BuildContext context) =>
      BlocProvider.of<DetailCustomerBloc>(context);
}
