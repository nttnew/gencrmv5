import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/widgets/loading_api.dart';
import 'package:get/get.dart';

import '../../api_resfull/user_repository.dart';
import '../../src/base.dart';
import '../../src/color.dart';
import '../../src/messages.dart';
import '../../src/models/index.dart';
import '../../src/navigator.dart';
import '../../widgets/widget_dialog.dart';

part 'add_job_chance_event.dart';
part 'add_job_chance_state.dart';

class AddJobChanceBloc extends Bloc<AddJobChanceEvent, AddJobChanceState> {
  final UserRepository userRepository;

  AddJobChanceBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetAddJobChance());

  @override
  Stream<AddJobChanceState> mapEventToState(AddJobChanceEvent event) async* {
    if (event is InitGetAddJobEventChance) {
      yield* _getAddJobChance(id: event.id);
    }
  }

  List<ListChanceData>? listChance;

  Stream<AddJobChanceState> _getAddJobChance({required int id}) async* {
    LoadingApi().pushLoading();
    try {
      final response = await userRepository.getAddJobChance(id);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield UpdateGetAddJobChanceState(response.data!);
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
        yield ErrorGetAddJobChanceState(response.msg ?? '');
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
      yield ErrorGetAddJobChanceState(MESSAGES.CONNECT_ERROR);
      throw e;
    }
    LoadingApi().popLoading();
  }

  static AddJobChanceBloc of(BuildContext context) =>
      BlocProvider.of<AddJobChanceBloc>(context);
}
