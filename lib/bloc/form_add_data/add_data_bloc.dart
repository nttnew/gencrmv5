import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/widgets/loading_api.dart';

import '../../api_resfull/user_repository.dart';
import '../../src/base.dart';
import '../../src/messages.dart';
import '../../src/models/model_generator/add_customer.dart';
import '../../src/models/model_generator/customer.dart';

part 'add_data_event.dart';
part 'add_data_state.dart';

class AddDataBloc extends Bloc<AddDataEvent, AddDataState>{
  final UserRepository userRepository;

  AddDataBloc({required UserRepository userRepository}) : userRepository = userRepository, super(InitAddDataState());

  @override
  Stream<AddDataState> mapEventToState(AddDataEvent event) async* {
    if(event is AddCustomerOrEvent){
      yield* _addCustomerOrganization(event.data,event.files);
    }
    else if(event is EditCustomerEvent){
      yield* _editCustomer(event.data,event.files);
    }
    else if(event is AddContactCustomerEvent){
      yield* _addContactCus(event.data,event.files);
    }
    else if(event is AddOpportunityEvent){
      yield* _addOpportunity(event.data,event.files);
    }
    else if(event is AddContractEvent){
      yield* _addContract(event.data,event.files);
    }
    else if(event is AddJobEvent){
      yield* _addJob(event.data,event.files);
    }
    else if(event is AddSupportEvent){
      yield* _addSupport(event.data,event.files);
    }
    else if(event is EditJobEvent){
      yield* _editJob(event.data,event.files);
    }
  }

  Stream<AddDataState> _addCustomerOrganization(Map<String,dynamic> data,File? files) async* {
    LoadingApi().pushLoading();
    yield LoadingAddCustomerOrState();
    try {
      final response = await userRepository.addOrganizationCustomer(data: data);
      if((response.code == BASE_URL.SUCCESS)||(response.code == BASE_URL.SUCCESS_200)){
        if(files!=null)
          {
            final responseUpload = await userRepository.uploadFileCus(id:response.data!.id.toString() ,files: files);
            if((responseUpload.code == BASE_URL.SUCCESS)||(responseUpload.code == BASE_URL.SUCCESS_200))
             {
               LoadingApi().popLoading();
               yield SuccessAddCustomerOrState();
             }
        else{
              LoadingApi().popLoading();
              yield ErrorAddCustomerOrState(responseUpload.msg ?? '');
            }
          }
        else
        {
          LoadingApi().popLoading();
          yield SuccessAddCustomerOrState();
        }
      }
      else{
        LoadingApi().popLoading();
        yield ErrorAddCustomerOrState(response.msg ?? '');
      }
    } catch (e) {
      yield ErrorAddCustomerOrState(MESSAGES.CONNECT_ERROR);
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<AddDataState> _editCustomer(Map<String,dynamic> data,File? files) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingEditCustomerState();
      final response = await userRepository.editCustomer(data: data);
      if((response.code == BASE_URL.SUCCESS)||(response.code == BASE_URL.SUCCESS_200)){
        if(files!=null)
        {
          final responseUpload = await userRepository.uploadFileCus(id:response.idkh.toString() ,files: files);
          if((responseUpload.code == BASE_URL.SUCCESS)||(responseUpload.code == BASE_URL.SUCCESS_200))
            {
              LoadingApi().popLoading();
              yield SuccessEditCustomerState();
            }
          else{
            LoadingApi().popLoading();
            yield ErrorEditCustomerState(responseUpload.msg ?? '');
          }
        }
        else
        {
          LoadingApi().popLoading();
          yield SuccessEditCustomerState();
        }
      }
      else {
        yield ErrorEditCustomerState(response.msg ?? '');
        LoadingApi().popLoading();
      }
    } catch (e) {
      yield ErrorEditCustomerState(MESSAGES.CONNECT_ERROR);
      LoadingApi().popLoading();
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<AddDataState> _addContactCus(Map<String,dynamic> data,File? files) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingAddContactCustomerState();
      final response = await userRepository.addContactCus(data: data);
      if((response.code == BASE_URL.SUCCESS)||(response.code == BASE_URL.SUCCESS_200)) {
        if (files != null)
      {
        final responseUpload = await userRepository.uploadFileContact(id:response.data!.id.toString() ,files: files);
        if((responseUpload.code == BASE_URL.SUCCESS)||(responseUpload.code == BASE_URL.SUCCESS_200))
          yield SuccessAddContactCustomerState();
        else{
          LoadingApi().popLoading();
          yield ErrorAddContactCustomerState(responseUpload.msg ?? '');
        }
      }
        else yield SuccessAddContactCustomerState();
      }
      else {
        yield ErrorAddContactCustomerState(response.msg ?? '');
        LoadingApi().popLoading();
      }
    } catch (e) {
      yield ErrorAddContactCustomerState(MESSAGES.CONNECT_ERROR);
      LoadingApi().popLoading();
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<AddDataState> _addOpportunity(Map<String,dynamic> data,File? files) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingAddContactCustomerState();
      final response = await userRepository.addOpportunity(data: data);
      if((response.code == BASE_URL.SUCCESS)||(response.code == BASE_URL.SUCCESS_200)){
        if(files!=null){
          final responseUpload = await userRepository.uploadFileOpp(id:response.data!.id.toString() ,files: files);
          if((responseUpload.code == BASE_URL.SUCCESS)||(responseUpload.code == BASE_URL.SUCCESS_200))
            yield SuccessAddContactCustomerState();
          else{
            LoadingApi().popLoading();
            yield ErrorAddContactCustomerState(responseUpload.msg ?? '');
          }
        }
        else
          yield SuccessAddContactCustomerState();
      }
      else {
        yield ErrorAddContactCustomerState(response.msg ?? '');
        LoadingApi().popLoading();
      }
    } catch (e) {
      yield ErrorAddContactCustomerState(MESSAGES.CONNECT_ERROR);
      LoadingApi().popLoading();
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<AddDataState> _addContract(Map<String,dynamic> data,File? files) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingAddContactCustomerState();
      final response = await userRepository.addContract(data: data);
      if((response.code == BASE_URL.SUCCESS)||(response.code == BASE_URL.SUCCESS_200)){
        if(files!=null)
          {

            final responseUpload = await userRepository.uploadFileContract(id:response.data!.id.toString() ,files: files);
            if((responseUpload.code == BASE_URL.SUCCESS)||(responseUpload.code == BASE_URL.SUCCESS_200))
              yield SuccessAddContactCustomerState();
            else{
              LoadingApi().popLoading();
              yield ErrorAddContactCustomerState(responseUpload.msg ?? '');
            }
          }
        else
          yield SuccessAddContactCustomerState();
      }
      else {
        yield ErrorAddContactCustomerState(response.msg ?? '');
        LoadingApi().popLoading();
      }
    } catch (e) {
      yield ErrorAddContactCustomerState(MESSAGES.CONNECT_ERROR);
      LoadingApi().popLoading();
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<AddDataState> _addJob(Map<String,dynamic> data,File? files) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingAddContactCustomerState();
      final response = await userRepository.addJob(data: data);
      if((response.code == BASE_URL.SUCCESS)||(response.code == BASE_URL.SUCCESS_200)){
        if(files!=null){
          final responseUpload = await userRepository.uploadFileJob(id:response.data!.id.toString() ,files: files);
          if((responseUpload.code == BASE_URL.SUCCESS)||(responseUpload.code == BASE_URL.SUCCESS_200))
            yield SuccessAddContactCustomerState();
          else{
            LoadingApi().popLoading();
            yield ErrorAddContactCustomerState(responseUpload.msg ?? '');
          }
        }
        else
        yield SuccessAddContactCustomerState();
      }
      else {
        yield ErrorAddContactCustomerState(response.msg ?? '');
        LoadingApi().popLoading();
      }
    } catch (e) {
      yield ErrorAddContactCustomerState(MESSAGES.CONNECT_ERROR);
      LoadingApi().popLoading();
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<AddDataState> _addSupport(Map<String,dynamic> data,File? files) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingAddContactCustomerState();
      final response = await userRepository.addSupport(data: data);
      if((response.code == BASE_URL.SUCCESS)||(response.code == BASE_URL.SUCCESS_200)){
        if(files!=null){
          final responseUpload = await userRepository.uploadFileSupport(id:response.data!.id.toString() ,files: files);
          if((responseUpload.code == BASE_URL.SUCCESS)||(responseUpload.code == BASE_URL.SUCCESS_200))
            yield SuccessAddContactCustomerState();
          else{
            LoadingApi().popLoading();
            yield ErrorAddContactCustomerState(responseUpload.msg ?? '');
          }
        }
        else
        yield SuccessAddContactCustomerState();
      }
      else {
        yield ErrorAddContactCustomerState(response.msg ?? '');
        LoadingApi().popLoading();
      }
    } catch (e) {
      yield ErrorAddContactCustomerState(MESSAGES.CONNECT_ERROR);
      LoadingApi().popLoading();
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<AddDataState> _editJob(Map<String,dynamic> data,File? files) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingAddContactCustomerState();
      final response = await userRepository.editJob(data: data);
      if((response.code == BASE_URL.SUCCESS)||(response.code == BASE_URL.SUCCESS_200)){
        if(files!=null){
          final responseUpload = await userRepository.uploadFileJob(id:response.data!.id.toString() ,files: files);
          if((responseUpload.code == BASE_URL.SUCCESS)||(responseUpload.code == BASE_URL.SUCCESS_200))
            yield SuccessAddContactCustomerState();
          else{
            LoadingApi().popLoading();
            yield ErrorAddContactCustomerState(responseUpload.msg ?? '');
          }
        }
        else
        yield SuccessAddContactCustomerState();
      }
      else {
        yield ErrorAddContactCustomerState(response.msg ?? '');
        LoadingApi().popLoading();
      }
    } catch (e) {
      yield ErrorAddContactCustomerState(MESSAGES.CONNECT_ERROR);
      LoadingApi().popLoading();
      throw e;
    }
    LoadingApi().popLoading();
  }

  static AddDataBloc of(BuildContext context) => BlocProvider.of<AddDataBloc>(context);
}