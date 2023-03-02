import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/widgets/loading_api.dart';
import 'package:get/get.dart';

import '../../api_resfull/user_repository.dart';
import '../../src/base.dart';
import '../../src/color.dart';
import '../../src/messages.dart';
import '../../src/models/model_generator/customer.dart';
import '../../src/navigator.dart';
import '../../widgets/widget_dialog.dart';

part 'customer_event.dart';
part 'customer_state.dart';

class GetListCustomerBloc extends Bloc<GetListCustomerEvent, CustomerState>{
  final UserRepository userRepository;

  GetListCustomerBloc({required UserRepository userRepository}) : userRepository = userRepository, super(InitGetListCustomer());

  @override
  Stream<CustomerState> mapEventToState(GetListCustomerEvent event) async* {
    if (event is InitGetListOrderEvent) {
      yield* _getListCustomer(filter: event.filter, page: event.page, search: event.search,isLoadMore: event.isLoadMore);
    }
    else if(event is AddCustomerIndividualEvent){
      yield* _AddCustomerIndividual(data: event.data,files: event.files);
    }
  }

  List<CustomerData>? listCus;

  Stream<CustomerState> _getListCustomer({required String filter, required int page, required String search,bool? isLoadMore=false}) async* {
    LoadingApi().pushLoading();
    try {
      final response = await userRepository.getListCustomer(page, filter, search);
      if((response.code == BASE_URL.SUCCESS)||(response.code == BASE_URL.SUCCESS_200)){
        if(page==1){
          listCus=response.data!.list!;
          yield UpdateGetListCustomerState(response.data!.list!,response.data!.filter!,response.data!.total!);
        }
        else
          {
            listCus!.addAll(response.data!.list!);
            yield UpdateGetListCustomerState(listCus!,response.data!.filter!,response.data!.total!);
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
        yield ErrorGetListCustomerState(response.msg ?? '');
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
      yield ErrorGetListCustomerState(MESSAGES.CONNECT_ERROR);
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<CustomerState> _AddCustomerIndividual({required Map<String,dynamic> data,File? files}) async* {
    LoadingApi().pushLoading();
    try {
      final response = await userRepository.addIndividualCustomer(data: data);

      if((response.code == BASE_URL.SUCCESS)||(response.code == BASE_URL.SUCCESS_200)){
        if(files!=null){
          final responseUpload = await userRepository.uploadFileCus(id:response.data!.id.toString() ,files: files);
          if((responseUpload.code == BASE_URL.SUCCESS)||(responseUpload.code == BASE_URL.SUCCESS_200))
            yield SuccessAddCustomerIndividualState();
          else{
            LoadingApi().popLoading();
            yield ErrorAddCustomerIndividualState(responseUpload.msg ?? '');
          }
        }else
          yield SuccessAddCustomerIndividualState();
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
      else{
        LoadingApi().popLoading();
        yield ErrorAddCustomerIndividualState(response.msg ?? '');
      }

    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorAddCustomerIndividualState(MESSAGES.CONNECT_ERROR);
      throw e;
    }
    LoadingApi().popLoading();
  }


  static GetListCustomerBloc of(BuildContext context) => BlocProvider.of<GetListCustomerBloc>(context);
}