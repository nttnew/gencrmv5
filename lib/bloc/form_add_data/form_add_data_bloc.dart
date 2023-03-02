import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/widgets/loading_api.dart';

import '../../api_resfull/user_repository.dart';
import '../../src/base.dart';
import '../../src/messages.dart';
import '../../src/models/model_generator/add_customer.dart';
import '../../src/models/model_generator/customer.dart';

part 'form_add_data_event.dart';
part 'form_add_data_state.dart';

class FormAddBloc extends Bloc<FormAddEvent, FormAddState>{
  final UserRepository userRepository;

  FormAddBloc({required UserRepository userRepository}) : userRepository = userRepository, super(InitFormAddState());

  @override
  Stream<FormAddState> mapEventToState(FormAddEvent event) async* {
    if (event is InitFormAddCusOrEvent) {
      yield* _getFormAddCustomerOrganization();
    }
    else if(event is InitFormAddContactCusEvent){
      yield* _getFormAddContactCustomer(event.id!);
    }
    else if(event is InitFormAddOppCusEvent){
      yield* _getFormAddOppCus(event.id!);
    }
    else if(event is InitFormAddContractCusEvent){
      yield* _getFormAddContractCus(event.id!);
    }
    else if(event is InitFormAddJobCusEvent){
      yield* _getFormAddJobCus(event.id!);
    }
    else if(event is InitFormAddSupportCusEvent){
      yield* _getFormAddSupportCus(event.id!);
    }
    else if(event is InitFormAddAgencyEvent){
      yield* _getFormAddAgency(event.id??'');
    }
    else if(event is InitFormAddChanceEvent){
      yield* _getFormAddChance(event.id??'');
    }
    else if(event is InitFormAddContractEvent){
      yield* _getFormAddContract(event.id??'');
    }
    else if(event is InitFormAddJobEvent){
      yield* _getFormAddJob(event.id??'');
    }
    else if(event is InitFormAddSupportEvent){
      yield* _getFormAddSupport(event.id??'');
    }
    else if(event is InitFormAddJobOppEvent){
      yield* _getFormAddJobOpp(event.id??'');
    }
    else if(event is InitFormAddJobChanceEvent){
      yield* _getFormAddJobChance(event.id??'');
    }
    else if(event is InitFormAddSupportContractEvent){
      yield* _getFormAddSupportContract(event.id??'');
    }
    else if(event is InitFormAddJobContractEvent){
      yield* _getFormAddJobContract(event.id??'');
    }
  }

  Stream<FormAddState> _getFormAddCustomerOrganization() async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingFormAddCustomerOrState();
      final response = await userRepository.getAddCusOr();
      if((response.code == BASE_URL.SUCCESS)||(response.code == BASE_URL.SUCCESS_200)){
        yield SuccessFormAddCustomerOrState(response.data!);
      }
      else
        {
          yield ErrorFormAddCustomerOrState(response.msg ?? '');
          LoadingApi().popLoading();
        }
    } catch (e) {
      yield ErrorFormAddCustomerOrState(MESSAGES.CONNECT_ERROR);
      LoadingApi().popLoading();
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<FormAddState> _getFormAddContactCustomer(String customer_id) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingFormAddCustomerOrState();
      final response = await userRepository.getFormAddContactCus(customer_id);
      if((response.code == BASE_URL.SUCCESS)||(response.code == BASE_URL.SUCCESS_200)){
        yield SuccessFormAddCustomerOrState(response.data!);
      }
      else
        {
          yield ErrorFormAddCustomerOrState(response.msg ?? '');
          LoadingApi().popLoading();
        }
    } catch (e) {
      yield ErrorFormAddCustomerOrState(MESSAGES.CONNECT_ERROR);
      LoadingApi().popLoading();
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<FormAddState> _getFormAddOppCus(String customer_id) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingFormAddCustomerOrState();
      final response = await userRepository.getFormAddOppCus(customer_id);
      if((response.code == BASE_URL.SUCCESS)||(response.code == BASE_URL.SUCCESS_200)){
        yield SuccessFormAddCustomerOrState(response.data!);
      }
      else
      {
        yield ErrorFormAddCustomerOrState(response.msg ?? '');
        LoadingApi().popLoading();
      }
    } catch (e) {
      yield ErrorFormAddCustomerOrState(MESSAGES.CONNECT_ERROR);
      LoadingApi().popLoading();
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<FormAddState> _getFormAddContractCus(String customer_id) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingFormAddCustomerOrState();
      final response = await userRepository.getFormAddContractCus(customer_id);
      if((response.code == BASE_URL.SUCCESS)||(response.code == BASE_URL.SUCCESS_200)){
        yield SuccessFormAddCustomerOrState(response.data!);
      }
      else
      {
        yield ErrorFormAddCustomerOrState(response.msg ?? '');
        LoadingApi().popLoading();
      }
    } catch (e) {
      yield ErrorFormAddCustomerOrState(MESSAGES.CONNECT_ERROR);
      LoadingApi().popLoading();
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<FormAddState> _getFormAddJobCus(String customer_id) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingFormAddCustomerOrState();
      final response = await userRepository.getFormAddJobCus(customer_id);
      if((response.code == BASE_URL.SUCCESS)||(response.code == BASE_URL.SUCCESS_200)){
        yield SuccessFormAddCustomerOrState(response.data!);
      }
      else
      {
        yield ErrorFormAddCustomerOrState(response.msg ?? '');
        LoadingApi().popLoading();
      }
    } catch (e) {
      yield ErrorFormAddCustomerOrState(MESSAGES.CONNECT_ERROR);
      LoadingApi().popLoading();
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<FormAddState> _getFormAddSupportCus(String customer_id) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingFormAddCustomerOrState();
      final response = await userRepository.getFormAddSupportCus(customer_id);
      if((response.code == BASE_URL.SUCCESS)||(response.code == BASE_URL.SUCCESS_200)){
        yield SuccessFormAddCustomerOrState(response.data!);
      }
      else
      {
        yield ErrorFormAddCustomerOrState(response.msg ?? '');
        LoadingApi().popLoading();
      }
    } catch (e) {
      yield ErrorFormAddCustomerOrState(MESSAGES.CONNECT_ERROR);
      LoadingApi().popLoading();
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<FormAddState> _getFormAddAgency(String id) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingFormAddCustomerOrState();
      final response = await userRepository.getFormAddAgency(id);
      if((response.code == BASE_URL.SUCCESS)||(response.code == BASE_URL.SUCCESS_200)){
        yield SuccessFormAddCustomerOrState(response.data!);
      }
      else
      {
        yield ErrorFormAddContactCustomerState(response.msg ?? '');
        LoadingApi().popLoading();
      }
    } catch (e) {
      yield ErrorFormAddContactCustomerState(MESSAGES.CONNECT_ERROR);
      LoadingApi().popLoading();
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<FormAddState> _getFormAddChance(String id) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingFormAddCustomerOrState();
      final response = await userRepository.getFormAddChance(id);
      if((response.code == BASE_URL.SUCCESS)||(response.code == BASE_URL.SUCCESS_200)){
        yield SuccessFormAddCustomerOrState(response.data!);
      }
      else
      {
        yield ErrorFormAddCustomerOrState(response.msg ?? '');
        LoadingApi().popLoading();
      }
    } catch (e) {
      yield ErrorFormAddCustomerOrState(MESSAGES.CONNECT_ERROR);
      LoadingApi().popLoading();
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<FormAddState> _getFormAddContract(String id) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingFormAddCustomerOrState();
      final response = await userRepository.getFormAddContract(id);
      if((response.code == BASE_URL.SUCCESS)||(response.code == BASE_URL.SUCCESS_200)){
        yield SuccessFormAddCustomerOrState(response.data!);
      }
      else
      {
        yield ErrorFormAddCustomerOrState(response.msg ?? '');
        LoadingApi().popLoading();
      }
    } catch (e) {
      yield ErrorFormAddCustomerOrState(MESSAGES.CONNECT_ERROR);
      LoadingApi().popLoading();
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<FormAddState> _getFormAddJob(String id) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingFormAddCustomerOrState();
      final response = await userRepository.getFormAddJob(id);
      if((response.code == BASE_URL.SUCCESS)||(response.code == BASE_URL.SUCCESS_200)){
        yield SuccessFormAddCustomerOrState(response.data!);
      }
      else
      {
        yield ErrorFormAddCustomerOrState(response.msg ?? '');
        LoadingApi().popLoading();
      }
    } catch (e) {
      yield ErrorFormAddCustomerOrState(MESSAGES.CONNECT_ERROR);
      LoadingApi().popLoading();
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<FormAddState> _getFormAddSupport(String id) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingFormAddCustomerOrState();
      final response = await userRepository.getFormAddSupport(id);
      if((response.code == BASE_URL.SUCCESS)||(response.code == BASE_URL.SUCCESS_200)){
        yield SuccessFormAddCustomerOrState(response.data!);
      }
      else
      {
        yield ErrorFormAddCustomerOrState(response.msg ?? '');
        LoadingApi().popLoading();
      }
    } catch (e) {
      yield ErrorFormAddCustomerOrState(MESSAGES.CONNECT_ERROR);
      LoadingApi().popLoading();
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<FormAddState> _getFormAddJobOpp(String id) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingFormAddCustomerOrState();
      final response = await userRepository.getFormAddJobOpp(id);
      if((response.code == BASE_URL.SUCCESS)||(response.code == BASE_URL.SUCCESS_200)){
        yield SuccessFormAddCustomerOrState(response.data!);
      }
      else
      {
        yield ErrorFormAddCustomerOrState(response.msg ?? '');
        LoadingApi().popLoading();
      }
    } catch (e) {
      yield ErrorFormAddCustomerOrState(MESSAGES.CONNECT_ERROR);
      LoadingApi().popLoading();
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<FormAddState> _getFormAddJobChance(String id) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingFormAddCustomerOrState();
      final response = await userRepository.getFormAddJobChance(id);
      if((response.code == BASE_URL.SUCCESS)||(response.code == BASE_URL.SUCCESS_200)){
        yield SuccessFormAddCustomerOrState(response.data!);
      }
      else
      {
        yield ErrorFormAddCustomerOrState(response.msg ?? '');
        LoadingApi().popLoading();
      }
    } catch (e) {
      yield ErrorFormAddCustomerOrState(MESSAGES.CONNECT_ERROR);
      LoadingApi().popLoading();
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<FormAddState> _getFormAddSupportContract(String id) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingFormAddCustomerOrState();
      final response = await userRepository.getFormAddSupportContract(id);
      if((response.code == BASE_URL.SUCCESS)||(response.code == BASE_URL.SUCCESS_200)){
        yield SuccessFormAddCustomerOrState(response.data!);
      }
      else
      {
        yield ErrorFormAddCustomerOrState(response.msg ?? '');
        LoadingApi().popLoading();
      }
    } catch (e) {
      yield ErrorFormAddCustomerOrState(MESSAGES.CONNECT_ERROR);
      LoadingApi().popLoading();
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<FormAddState> _getFormAddJobContract(String id) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingFormAddCustomerOrState();
      final response = await userRepository.getFormAddJobContract(id);
      if((response.code == BASE_URL.SUCCESS)||(response.code == BASE_URL.SUCCESS_200)){
        yield SuccessFormAddCustomerOrState(response.data!);
      }
      else
      {
        yield ErrorFormAddCustomerOrState(response.msg ?? '');
        LoadingApi().popLoading();
      }
    } catch (e) {
      yield ErrorFormAddCustomerOrState(MESSAGES.CONNECT_ERROR);
      LoadingApi().popLoading();
      throw e;
    }
    LoadingApi().popLoading();
  }

  static FormAddBloc of(BuildContext context) => BlocProvider.of<FormAddBloc>(context);
}