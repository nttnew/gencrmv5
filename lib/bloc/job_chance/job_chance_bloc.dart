import 'dart:io';
import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/widgets/loading_api.dart';
import 'package:get/get.dart';

import '../../api_resfull/user_repository.dart';
import '../../src/base.dart';
import '../../src/color.dart';
import '../../src/messages.dart';
import '../../src/models/model_generator/job_chance.dart';

part 'job_chance_event.dart';
part 'job_chance_state.dart';

class GetJobChanceBloc extends Bloc<GetJobChanceEvent, JobChanceState>{
  final UserRepository userRepository;

  GetJobChanceBloc({required UserRepository userRepository}) : userRepository = userRepository, super(InitGetJobChance());

  @override
  Stream<JobChanceState> mapEventToState(GetJobChanceEvent event) async* {
    if (event is InitGetJobEventChance) {
      yield* _getListJobChance(id: event.id);
    }
  }


  Stream<JobChanceState> _getListJobChance({required int id}) async* {
    LoadingApi().pushLoading();
    try {
      final response = await userRepository.getJobChance(id);
      if((response.code == BASE_URL.SUCCESS)||(response.code == BASE_URL.SUCCESS_200)){
        yield UpdateGetJobChanceState(response.data!);
      }
      else
        yield ErrorGetJobChanceState(response.msg ?? '');
    } catch (e) {
      yield ErrorGetJobChanceState(MESSAGES.CONNECT_ERROR);
      throw e;
    }
    LoadingApi().popLoading();
  }


  static GetJobChanceBloc of(BuildContext context) => BlocProvider.of<GetJobChanceBloc>(context);
}