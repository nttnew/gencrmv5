import 'dart:io';
import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/src/models/model_generator/detail_customer.dart';
import 'package:gen_crm/widgets/loading_api.dart';
import 'package:get/get.dart';

import '../../api_resfull/user_repository.dart';
import '../../src/base.dart';
import '../../src/color.dart';
import '../../src/messages.dart';
import '../../src/models/model_generator/customer.dart';
import '../../src/navigator.dart';
import '../../widgets/widget_dialog.dart';

part 'detail_customer_event.dart';
part 'detail_customer_state.dart';

class DetailCustomerBloc
    extends Bloc<DetailCustomerEvent, DetailCustomerState> {
  final UserRepository userRepository;

  DetailCustomerBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetDetailCustomer());

  @override
  Stream<DetailCustomerState> mapEventToState(
      DetailCustomerEvent event) async* {
    if (event is InitGetDetailCustomerEvent) {
      yield* _getDetailCustomer(id: event.id);
    } else if (event is DeleteCustomerEvent) {
      yield* _deleteCustomer(id: event.id);
    }
  }

  List<CustomerData>? listCus;

  Stream<DetailCustomerState> _getDetailCustomer({required int id}) async* {
    LoadingApi().pushLoading();
    try {
      final response = await userRepository.getDetailCustomer(id);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield UpdateGetDetailCustomerState(
            response.data!.customer_info!, response.data!.customer_note!);
        // if(page==1){
        //   listCus=response.data.list!;
        //   yield UpdateGetListCustomerState(response.data.list!,response.data.filter!,response.data.total!);
        // }
        //
        // else
        // {
        //   listCus!.addAll(response.data.list!);
        //   yield UpdateGetListCustomerState(listCus!,response.data.filter!,response.data.total!);
        // }
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
      } else {
        yield ErrorGetDetailCustomerState(response.msg ?? '');
        LoadingApi().popLoading();
      }
    } catch (e) {
      yield ErrorGetDetailCustomerState(MESSAGES.CONNECT_ERROR);
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
        LoadingApi().popLoading();

        yield SuccessDeleteCustomerState();
      } else if (response.code == 999) {
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
      } else {
        LoadingApi().popLoading();

        yield ErrorDeleteCustomerState(response.msg ?? '');
      }
    } catch (e) {
      yield ErrorDeleteCustomerState(MESSAGES.CONNECT_ERROR);
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
      throw e;
    }
    LoadingApi().popLoading();
  }

  static DetailCustomerBloc of(BuildContext context) =>
      BlocProvider.of<DetailCustomerBloc>(context);
}
