import 'dart:io';

import 'package:dartx/dartx.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/src/models/model_generator/detail_contract.dart';
import 'package:gen_crm/widgets/loading_api.dart';
import 'package:rxdart/rxdart.dart';
import '../../api_resfull/user_repository.dart';
import '../../src/app_const.dart';
import '../../src/base.dart';
import '../../src/messages.dart';
import '../../src/models/model_generator/contract.dart';
import '../../src/models/model_generator/file_response.dart';
import '../../widgets/listview_loadmore_base.dart';

part 'detail_contract_event.dart';
part 'detail_contract_state.dart';

class DetailContractBloc extends Bloc<ContractEvent, DetailContractState> {
  final UserRepository userRepository;
  List<ContractItemData>? list;
  BehaviorSubject<List<FileDataResponse>?> listFileStream = BehaviorSubject();
  LoadMoreController controllerCV = LoadMoreController();
  LoadMoreController controllerHT = LoadMoreController();

  DetailContractBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitDetailContract());

  @override
  Stream<DetailContractState> mapEventToState(ContractEvent event) async* {
    if (event is InitGetDetailContractEvent) {
      initController(event.id);
      yield* _getDetailContract(id: event.id);
    } else if (event is InitDeleteContractEvent) {
      yield* _deleteContract(id: event.id);
    }
  }

  initController(int idTxt) async {
    final dataCv = await getJobContract(
        page: BASE_URL.PAGE_DEFAULT, id: idTxt, isInit: false);
    await controllerCV.initData(dataCv);

    final dataHT = await getSupportContract(
        page: BASE_URL.PAGE_DEFAULT, id: idTxt, isInit: false);
    await controllerHT.initData(dataHT);
  }

  Stream<DetailContractState> _getDetailContract({required int id}) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingDetailContractState();
      final response = await userRepository.getDetailContract(id);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield SuccessDetailContractState(response.data ?? []);
      } else if (response.code == BASE_URL.SUCCESS_999) {
        loginSessionExpired();
      } else
        yield ErrorDetailContractState(response.msg ?? '');
    } catch (e) {
      yield ErrorDetailContractState(MESSAGES.CONNECT_ERROR);
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<DetailContractState> _deleteContract({required int id}) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingDeleteContractState();
      final response = await userRepository.deleteContract({"id": id});
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield SuccessDeleteContractState();
      } else if (response.code == BASE_URL.SUCCESS_999) {
        loginSessionExpired();
      } else
        yield ErrorDeleteContractState(response.msg ?? '');
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorDeleteContractState(MESSAGES.CONNECT_ERROR);
      throw e;
    }
    LoadingApi().popLoading();
  }

  Future<void> getFile(int id, String module) async {
    final response = await userRepository.getFile(module: module, id: id);
    if ((response.code == BASE_URL.SUCCESS) ||
        (response.code == BASE_URL.SUCCESS_200)) {
      listFileStream.add(response.data?.list ?? []);
    }
  }

  Future<bool> deleteFile(List<FileDataResponse> list) async {
    String id = '';
    for (final value in list) {
      id += (id != '' ? ',' : '') + value.id.toString();
    }
    final response = await userRepository.deleteFile(id: id);
    final statusCode =
        (response as Map<String, dynamic>).getOrElse('e', () => -1);
    if (statusCode == 0) {
      return true;
    }
    return false;
  }

  Future<bool> deleteFileOnly(FileDataResponse file) async {
    final response = await userRepository.deleteFile(id: file.id.toString());
    final statusCode =
        (response as Map<String, dynamic>).getOrElse('e', () => -1);
    if (statusCode == 0) {
      return true;
    }
    return false;
  }

  Future<bool> uploadFile({
    required String id,
    required List<File> listFile,
    required String module,
    bool? isAfter,
  }) async {
    final responseUpload = await userRepository.uploadMultiFileBase(
      id: id,
      files: listFile,
      module: module,
      isAfter: isAfter,
    );
    if ((responseUpload.code == BASE_URL.SUCCESS) ||
        (responseUpload.code == BASE_URL.SUCCESS_200)) {
      return true;
    } else {
      return false;
    }
  }

  Future<dynamic> getSupportContract(
      {required int id,
      int page = BASE_URL.PAGE_DEFAULT,
      bool isInit = true}) async {
    if (isInit) {
      LoadingApi().pushLoading();
    }
    try {
      final response = await userRepository.getSupportContract(id, page);
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

  Future<dynamic> getJobContract(
      {required int id,
      int page = BASE_URL.PAGE_DEFAULT,
      bool isInit = true}) async {
    if (isInit) {
      LoadingApi().pushLoading();
    }
    try {
      final response = await userRepository.getJobContract(id, page);
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

  static DetailContractBloc of(BuildContext context) =>
      BlocProvider.of<DetailContractBloc>(context);
}
