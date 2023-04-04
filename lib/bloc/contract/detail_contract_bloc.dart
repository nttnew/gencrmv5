import 'dart:io';

import 'package:dartx/dartx.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/src/models/model_generator/detail_contract.dart';
import 'package:gen_crm/widgets/loading_api.dart';
import 'package:get/get.dart';

import '../../api_resfull/user_repository.dart';
import '../../src/base.dart';
import '../../src/color.dart';
import '../../src/messages.dart';
import '../../src/models/model_generator/contract.dart';
import '../../src/models/model_generator/file_response.dart';
import '../../src/navigator.dart';
import '../../widgets/widget_dialog.dart';

part 'detail_contract_event.dart';
part 'detail_contract_state.dart';

class DetailContractBloc extends Bloc<ContractEvent, DetailContractState> {
  final UserRepository userRepository;

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

  List<ContractItemData>? list;
  List<FileDataResponse> listFileResponse = [];

  Stream<DetailContractState> _getDetailContract({required int id}) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingDetailContractState();
      final response = await userRepository.getDetailContract(id);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield SuccessDetailContractState(response.data!);
      } else if (response.code == 999) {
        Get.dialog(WidgetDialog(
          title: MESSAGES.NOTIFICATION,
          content: "Phiên đăng nhập hết hạn, hãy đăng nhập lại!",
          textButton1: "OK",
          backgroundButton1: COLORS.PRIMARY_COLOR,
          onTap1: () {
            AppNavigator.navigateLogout();
          },
        ));
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
      } else if (response.code == 999) {
        Get.dialog(WidgetDialog(
          title: MESSAGES.NOTIFICATION,
          content: "Phiên đăng nhập hết hạn, hãy đăng nhập lại!",
          textButton1: "OK",
          backgroundButton1: COLORS.PRIMARY_COLOR,
          onTap1: () {
            AppNavigator.navigateLogout();
          },
        ));
      } else
        yield ErrorDeleteContractState(response.msg ?? '');
    } catch (e) {
      LoadingApi().popLoading();
      Get.dialog(WidgetDialog(
        title: MESSAGES.NOTIFICATION,
        content: "Phiên đăng nhập hết hạn, hãy đăng nhập lại!",
        textButton1: "OK",
        backgroundButton1: COLORS.PRIMARY_COLOR,
        onTap1: () {
          AppNavigator.navigateLogout();
        },
      ));
      yield ErrorDeleteContractState(MESSAGES.CONNECT_ERROR);
      throw e;
    }
    LoadingApi().popLoading();
  }

  Future<void> getFile(int id,String module) async {
    listFileResponse = [];
    final response =
        await userRepository.getFile(module: module, id: id);
    if ((response.code == BASE_URL.SUCCESS) ||
        (response.code == BASE_URL.SUCCESS_200)) {
      if (response.data?.list?.isNotEmpty ?? false) {
        listFileResponse.addAll(response.data?.list ?? []);
      }
    }
  }

  Future<bool?> deleteFile(List<FileDataResponse> list) async {
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

  Future<bool?> uploadFile(
      String id, List<File> listFile, String module) async {
    final responseUpload = await userRepository.uploadMultiFileContract(
      id: id,
      files: listFile,
      module: module,
    );
    if ((responseUpload.code == BASE_URL.SUCCESS) ||
        (responseUpload.code == BASE_URL.SUCCESS_200)) {
      return true;
    } else {
      return false;
    }
  }

  static DetailContractBloc of(BuildContext context) =>
      BlocProvider.of<DetailContractBloc>(context);
}
