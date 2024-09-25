import 'dart:io';

import 'package:dartx/dartx.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/widgets/loading_api.dart';
import 'package:rxdart/rxdart.dart';
import '../../api_resfull/user_repository.dart';
import '../../l10n/key_text.dart';
import '../../src/app_const.dart';
import '../../src/base.dart';
import '../../src/models/model_generator/detail_customer.dart';
import '../../src/models/model_generator/file_response.dart';
import '../../widgets/listview/list_load_infinity.dart';

part 'detail_contract_event.dart';
part 'detail_contract_state.dart';

class DetailContractBloc extends Bloc<ContractEvent, DetailContractState> {
  final UserRepository userRepository;
  BehaviorSubject<List<FileDataResponse>?> listFileStream = BehaviorSubject();
  LoadMoreController controllerCV = LoadMoreController();
  LoadMoreController controllerHT = LoadMoreController();

  DetailContractBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitDetailContract());

  @override
  Stream<DetailContractState> mapEventToState(ContractEvent event) async* {
    if (event is InitGetDetailContractEvent) {
      yield* _getDetailContract(id: event.id);
    } else if (event is InitDeleteContractEvent) {
      yield* _deleteContract(id: event.id);
    }
  }

  Stream<DetailContractState> _getDetailContract({
    required int id,
  }) async* {
    try {
      yield LoadingDetailContractState();
      final response = await userRepository.getDetailContract(id);
      if (isSuccess(response.code)) {
        yield SuccessDetailContractState(response.data ?? []);
      } else if (isFail(response.code)) {
        loginSessionExpired();
      } else {
        yield ErrorDetailContractState(response.msg ?? '');
      }
    } catch (e) {
      yield ErrorDetailContractState(getT(KeyT.an_error_occurred));
    }
  }

  Stream<DetailContractState> _deleteContract({required int id}) async* {
    Loading().showLoading();
    try {
      yield LoadingDeleteContractState();
      final response = await userRepository.deleteContract({"id": id});
      if (isSuccess(response.code)) {
        yield SuccessDeleteContractState();
      } else if (isFail(response.code)) {
        loginSessionExpired();
      } else
        yield ErrorDeleteContractState(response.msg ?? '');
    } catch (e) {
      Loading().popLoading();
      yield ErrorDeleteContractState(getT(KeyT.an_error_occurred));
      throw e;
    }
    Loading().popLoading();
  }

  Future<void> getFile(int id, String module) async {
    final response = await userRepository.getFile(module: module, id: id);
    try {
      if (isSuccess(response.code)) {
        listFileStream.add(response.data?.list ?? []);
      }
    } catch (e) {
      listFileStream.add([]);
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

  Future<String> deleteFileOnly(FileDataResponse file) async {
    final response = await userRepository.deleteFile(id: file.id.toString());
    String mes = getT(KeyT.fail.toLowerCase());
    try {
      final statusCode =
          (response as Map<String, dynamic>).getOrElse('e', () => -1);
      final mesRes = response.getOrElse('m', () => -1);
      if (statusCode == 0) {
        mes = '';
      } else {
        mes = mesRes;
      }
    } catch (e) {
      return mes;
    }
    return mes;
  }

  Future<String> uploadFile({
    required String id,
    required List<File> listFile,
    required String module,
    bool? isAfter,
  }) async {
    String _data = getT(KeyT.fail);
    try {
      final responseUpload = await userRepository.uploadMultiFileBase(
        id: id,
        files: listFile,
        module: module,
        isAfter: isAfter,
      );
      if (isSuccess(responseUpload.code)) {
        _data = SUCCESS;
        return _data;
      } else {
        _data = responseUpload.msg ?? '';
        return _data;
      }
    } catch (e) {
      return _data;
    }
  }

  Future<dynamic> getSupportContract({
    required int id,
    int page = BASE_URL.PAGE_DEFAULT,
  }) async {
    try {
      final response = await userRepository.getSupportContract(id, page);
      if (isSuccess(response.code)) {
        return response.data ?? [];
      } else if (isFail(response.code)) {
        loginSessionExpired();
      } else {
        return response.msg ?? '';
      }
    } catch (e) {
      return getT(KeyT.an_error_occurred);
    }
  }

  Future<dynamic> getJobContract({
    required int id,
    int page = BASE_URL.PAGE_DEFAULT,
  }) async {
    try {
      final response = await userRepository.getJobContract(id, page);
      if (isSuccess(response.code)) {
        return response.data ?? [];
      } else if (isFail(response.code)) {
        loginSessionExpired();
      } else {
        return response.msg ?? '';
      }
    } catch (e) {
      return getT(KeyT.an_error_occurred);
    }
  }

  static DetailContractBloc of(BuildContext context) =>
      BlocProvider.of<DetailContractBloc>(context);
}
