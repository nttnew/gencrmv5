import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/widgets/loading_api.dart';
import 'package:get/get.dart';

import '../../api_resfull/user_repository.dart';
import '../../src/base.dart';
import '../../src/messages.dart';
import '../../src/models/model_generator/add_customer.dart';
import '../../src/models/model_generator/customer.dart';
import '../../widgets/widget_dialog.dart';

part 'form_edit_event.dart';
part 'form_edit_state.dart';

class FormEditBloc extends Bloc<FormEditEvent, FormEditState>{
  final UserRepository userRepository;

  FormEditBloc({required UserRepository userRepository}) : userRepository = userRepository, super(InitFormEditState());

  @override
  Stream<FormEditState> mapEventToState(FormEditEvent event) async* {
    if (event is InitFormEditCusEvent) {
      yield* _getFormEditCus(event.id!);
    }
    if(event is InitFormEditClueEvent){
      yield* _getFormEditClue(event.id!);
    }
    if(event is InitFormEditChanceEvent){
      yield* _getFormEditChance(event.id!);
    }
    if(event is InitFormEditJobEvent){
      yield* _getFormEditJob(event.id!);
    }
    if(event is InitFormEditSupportEvent){
      yield* _getFormEditSupport(event.id!);
    }
    if(event is InitFormEditContractEvent){
      yield* _getFormEditContract(event.id!);
    }
    if(event is InitGetContactByCustomerEvent){
      yield* _getFormEditContract(event.id!);
    }
  }

  Stream<FormEditState> _getFormEditCus(String id) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingFormEditState();
      final response = await userRepository.getUpdateCustomer(id);
      if((response.code == BASE_URL.SUCCESS)||(response.code == BASE_URL.SUCCESS_200)){
        yield SuccessFormEditState(response.data!);
      }
      else
      {
        yield ErrorFormEditState(response.msg ?? '');
        LoadingApi().popLoading();
      }
    } catch (e) {
      yield ErrorFormEditState(MESSAGES.CONNECT_ERROR);
      LoadingApi().popLoading();
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<FormEditState> _getFormEditClue(String id) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingFormEditState();
      final response = await userRepository.getFormEditClue(id);
      if((response.code == BASE_URL.SUCCESS)||(response.code == BASE_URL.SUCCESS_200)){
        yield SuccessFormEditState(response.data!);
      }
      else
      {
        yield ErrorFormEditState(response.msg ?? '');
        LoadingApi().popLoading();
      }
    } catch (e) {
      yield ErrorFormEditState(MESSAGES.CONNECT_ERROR);
      LoadingApi().popLoading();
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<FormEditState> _getFormEditChance(String id) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingFormEditState();
      final response = await userRepository.getFormAddChance(id);
      if((response.code == BASE_URL.SUCCESS)||(response.code == BASE_URL.SUCCESS_200)){
        print("c?? h???i success");
        yield SuccessFormEditState(response.data!);
      }
      else
      {
        yield ErrorFormEditState(response.msg ?? '');
        LoadingApi().popLoading();
      }
    } catch (e) {
      yield ErrorFormEditState(MESSAGES.CONNECT_ERROR);
      LoadingApi().popLoading();
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<FormEditState> _getFormEditJob(String id) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingFormEditState();
      final response = await userRepository.getFormAddJob(id);
      if((response.code == BASE_URL.SUCCESS)||(response.code == BASE_URL.SUCCESS_200)){
        yield SuccessFormEditState(response.data!);
      }
      else
      {
        yield ErrorFormEditState(response.msg ?? '');
        LoadingApi().popLoading();
      }
    } catch (e) {
      yield ErrorFormEditState(MESSAGES.CONNECT_ERROR);
      LoadingApi().popLoading();
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<FormEditState> _getFormEditSupport(String id) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingFormEditState();
      final response = await userRepository.getFormEditSupport(id);
      if((response.code == BASE_URL.SUCCESS)||(response.code == BASE_URL.SUCCESS_200)){
        yield SuccessFormEditState(response.data!);
      }
      else
      {
        yield ErrorFormEditState(response.msg ?? '');
        LoadingApi().popLoading();
      }
    } catch (e) {
      yield ErrorFormEditState(MESSAGES.CONNECT_ERROR);
      LoadingApi().popLoading();
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<FormEditState> _getFormEditContract(String id) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingFormEditState();
      final response = await userRepository.getFormEditContract(id);
      if((response.code == BASE_URL.SUCCESS)||(response.code == BASE_URL.SUCCESS_200)){
        yield SuccessFormEditState(response.data!);
      }
      else
      {
        yield ErrorFormEditState(response.msg ?? '');
        LoadingApi().popLoading();
      }
    } catch (e) {
      yield ErrorFormEditState(MESSAGES.CONNECT_ERROR);
      LoadingApi().popLoading();
      throw e;
    }
    LoadingApi().popLoading();
  }

  // Stream<FormEditState> _getContactByCustomer(String id) async* {
  //   LoadingApi().pushLoading();
  //   try {
  //     final response = await userRepository.getContactByCustomer(id);
  //     if((response.code == BASE_URL.SUCCESS)||(response.code == BASE_URL.SUCCESS_200)){
  //       yield SuccessFormEditState(response.data!);
  //     }
  //     else
  //     {
  //       yield ErrorFormEditState(response.msg ?? '');
  //       LoadingApi().popLoading();
  //     }
  //   } catch (e) {
  //     yield ErrorFormEditState(MESSAGES.CONNECT_ERROR);
  //     LoadingApi().popLoading();
  //     throw e;
  //   }
  //   LoadingApi().popLoading();
  // }

  static FormEditBloc of(BuildContext context) => BlocProvider.of<FormEditBloc>(context);
}