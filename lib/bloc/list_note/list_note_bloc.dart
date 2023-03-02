import 'dart:io';
import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/src/models/model_generator/note.dart';
import 'package:gen_crm/widgets/loading_api.dart';
import 'package:get/get.dart';

import '../../api_resfull/user_repository.dart';
import '../../src/base.dart';
import '../../src/color.dart';
import '../../src/messages.dart';
import '../../src/models/model_generator/detail_chance.dart';
import '../../src/navigator.dart';
import '../../widgets/widget_dialog.dart';

part 'list_note_event.dart';
part 'list_note_state.dart';

class ListNoteBloc extends Bloc<ListNoteEvent, ListNoteState>{
  final UserRepository userRepository;

  ListNoteBloc({required UserRepository userRepository}) : userRepository = userRepository, super(InitGetListNoteState());

  @override
  Stream<ListNoteState> mapEventToState(ListNoteEvent event) async* {
    if (event is InitNoteOppEvent) {
      yield* _getListNoteOpp(id: event.id,page: event.page);
    }
    else if (event is InitNoteCusEvent) {
      yield* _getListNoteCus(id: event.id,page: event.page);
    }
    else if (event is InitNoteContactEvent) {
      yield* _getListNoteContact(id: event.id,page: event.page);
    }
    else if (event is InitNoteContractEvent) {
      yield* _getListNoteContract(id: event.id,page: event.page);
    }
    else if (event is InitNoteJobEvent) {
      yield* _getListNoteJob(id: event.id,page: event.page);
    }
    else if (event is InitNoteSupEvent) {
      yield* _getListNoteSup(id: event.id,page: event.page);
    }
  }


  Stream<ListNoteState> _getListNoteOpp({required String id,required String page}) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingGetNoteOppState();
      final response = await userRepository.getListNoteOpp(id,page);
      if((response.code == BASE_URL.SUCCESS)||(response.code == BASE_URL.SUCCESS_200)){
        // if(response.data != []){
          yield SuccessGetNoteOppState(response.data!.notes??[]);
        // }

        // else{
        //   yield SuccessGetNoteOppState([]);
        // }
      }
      else
      {
        yield ErrorGetNoteOppState(response.msg ?? '');
        LoadingApi().popLoading();
      }
    } catch (e) {
      yield ErrorGetNoteOppState(MESSAGES.CONNECT_ERROR);
      LoadingApi().popLoading();
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<ListNoteState> _getListNoteCus({required String id,required String page}) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingGetNoteOppState();
      final response = await userRepository.getListNoteCus(id,page);
      if((response.code == BASE_URL.SUCCESS)||(response.code == BASE_URL.SUCCESS_200)){
        yield SuccessGetNoteOppState(response.data!.notes??[]);
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
      {
        yield ErrorGetNoteOppState(response.msg ?? '');
        LoadingApi().popLoading();
      }
    } catch (e) {
      yield ErrorGetNoteOppState(MESSAGES.CONNECT_ERROR);
      LoadingApi().popLoading();
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<ListNoteState> _getListNoteContact({required String id,required String page}) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingGetNoteOppState();
      final response = await userRepository.getListNoteContact(id,page);
      if((response.code == BASE_URL.SUCCESS)||(response.code == BASE_URL.SUCCESS_200)){
        yield SuccessGetNoteOppState(response.data!.notes??[]);
      }
      else
      {
        yield ErrorGetNoteOppState(response.msg ?? '');
        LoadingApi().popLoading();
      }
    } catch (e) {
      yield ErrorGetNoteOppState(MESSAGES.CONNECT_ERROR);
      LoadingApi().popLoading();
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<ListNoteState> _getListNoteContract({required String id,required String page}) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingGetNoteOppState();
      final response = await userRepository.getListNoteContract(id,page);
      if((response.code == BASE_URL.SUCCESS)||(response.code == BASE_URL.SUCCESS_200)){
        yield SuccessGetNoteOppState(response.data!.notes??[]);
      }
      else
      {
        yield ErrorGetNoteOppState(response.msg ?? '');
        LoadingApi().popLoading();
      }
    } catch (e) {
      yield ErrorGetNoteOppState(MESSAGES.CONNECT_ERROR);
      LoadingApi().popLoading();
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<ListNoteState> _getListNoteJob({required String id,required String page}) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingGetNoteOppState();
      final response = await userRepository.getListNoteJob(id,page);
      if((response.code == BASE_URL.SUCCESS)||(response.code == BASE_URL.SUCCESS_200)){
        yield SuccessGetNoteOppState(response.data!.notes??[]);
      }
      else
      {
        yield ErrorGetNoteOppState(response.msg ?? '');
        LoadingApi().popLoading();
      }
    } catch (e) {
      yield ErrorGetNoteOppState(MESSAGES.CONNECT_ERROR);
      LoadingApi().popLoading();
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<ListNoteState> _getListNoteSup({required String id,required String page}) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingGetNoteOppState();
      final response = await userRepository.getListNoteSup(id,page);
      if((response.code == BASE_URL.SUCCESS)||(response.code == BASE_URL.SUCCESS_200)){
        yield SuccessGetNoteOppState(response.data!.notes??[]);
      }
      else
      {
        yield ErrorGetNoteOppState(response.msg ?? '');
        LoadingApi().popLoading();
      }
    } catch (e) {
      yield ErrorGetNoteOppState(MESSAGES.CONNECT_ERROR);
      LoadingApi().popLoading();
      throw e;
    }
    LoadingApi().popLoading();
  }

  static ListNoteBloc of(BuildContext context) => BlocProvider.of<ListNoteBloc>(context);
}