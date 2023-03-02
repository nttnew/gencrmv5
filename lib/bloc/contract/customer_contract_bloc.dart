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
import '../../src/models/model_generator/customer.dart';
import '../../src/models/model_generator/job_chance.dart';
import '../../src/navigator.dart';
import '../../widgets/widget_dialog.dart';

part 'customer_contract_event.dart';
part 'customer_contract_state.dart';

class CustomerContractBloc extends Bloc<CustomerContractEvent, CustomerContractState>{
  final UserRepository userRepository;

  CustomerContractBloc({required UserRepository userRepository}) : userRepository = userRepository, super(InitGetContractCustomer());

  @override
  Stream<CustomerContractState> mapEventToState(CustomerContractEvent event) async* {
    if (event is InitGetContractCustomerEvent) {
      yield* _getListContractCustomer(search: event.querySearch,page: event.page);
    }
    else if (event is InitGetContactCusEvent) {
      yield* _getListContactCus(id: event.id);
    }
  }

  List<List<dynamic>>? list;

  Stream<CustomerContractState> _getListContractCustomer({required String page, required String search}) async* {
    LoadingApi().pushLoading();
    try {
      if(page=="1")
        yield LoadingContractCustomerState();
      final response = await userRepository.getCustomerContract(page,search);
      if((response.code == BASE_URL.SUCCESS)||(response.code == BASE_URL.SUCCESS_200)){
        if(page=="1"){
          list=response.data;
          yield SuccessGetContractCustomerState(response.data!);
        }
        else
        {
          if(response.data!.length>0)
          {
            list=[...list!,...response.data!];
            yield SuccessGetContractCustomerState(list!);
          }
        }
      }
      else if(response.code==999){
        Get.dialog(WidgetDialog(
          title: MESSAGES.NOTIFICATION,
          content: "Phiên đăng nhập hết hạn, hãy đăng nhập lại!",
          textButton1: "OK",
          backgroundButton1: COLORS.PRIMARY_COLOR,
          onTap1: () {
            AppNavigator.navigateLogout();
          },
        ));
      }
      else
        yield ErrorGetContractCustomerState(response.msg ?? '');
    } catch (e) {
      yield ErrorGetContractCustomerState(MESSAGES.CONNECT_ERROR);
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<CustomerContractState> _getListContactCus({required String id}) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingContractCustomerState();
      final response = await userRepository.getContactByCustomer(id);
      if((response.code == BASE_URL.SUCCESS)||(response.code == BASE_URL.SUCCESS_200)){
          yield SuccessGetContractCustomerState(response.data!);
      }
      else if(response.code==999){
        Get.dialog(WidgetDialog(
          title: MESSAGES.NOTIFICATION,
          content: "Phiên đăng nhập hết hạn, hãy đăng nhập lại!",
          textButton1: "OK",
          backgroundButton1: COLORS.PRIMARY_COLOR,
          onTap1: () {
            AppNavigator.navigateLogout();
          },
        ));
      }
      else
        yield ErrorGetContractCustomerState(response.msg ?? '');
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
      yield ErrorGetContractCustomerState(MESSAGES.CONNECT_ERROR);
      throw e;
    }
    LoadingApi().popLoading();
  }

  static CustomerContractBloc of(BuildContext context) => BlocProvider.of<CustomerContractBloc>(context);
}