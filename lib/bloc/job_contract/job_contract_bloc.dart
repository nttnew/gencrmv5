import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/api_resfull/api.dart';
import 'package:get/get.dart';

import '../../src/base.dart';
import '../../src/color.dart';
import '../../src/messages.dart';
import '../../src/models/model_generator/job_chance.dart';
import '../../src/navigator.dart';
import '../../widgets/loading_api.dart';
import '../../widgets/widget_dialog.dart';

part 'job_contract_event.dart';
part 'job_contract_state.dart';

class JobContractBloc extends Bloc<JobContractEvent, JobContractState> {
  UserRepository userRepository;
  JobContractBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitJobContractState());
  @override
  Stream<JobContractState> mapEventToState(JobContractEvent event) async* {
    if (event is InitGetJobContractEvent) {
      yield* _getListJobContract(id: event.id);
    }
  }

  Stream<JobContractState> _getListJobContract({required int id}) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingJobContractState();
      final response = await userRepository.getJobContract(id);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield SuccessJobContractState(response.data!);
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
        yield ErrorJobContractState(response.msg ?? '');
    } catch (e) {
      yield ErrorJobContractState(MESSAGES.CONNECT_ERROR);
      throw e;
    }
    LoadingApi().popLoading();
  }

  static JobContractBloc of(BuildContext context) =>
      BlocProvider.of<JobContractBloc>(context);
}
