import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../api_resfull/user_repository.dart';
import '../../src/base.dart';
import '../../src/color.dart';
import '../../src/messages.dart';
import '../../src/models/model_generator/clue.dart';
import '../../src/navigator.dart';
import '../../widgets/loading_api.dart';
import '../../widgets/widget_dialog.dart';

part 'clue_state.dart';
part 'clue_event.dart';

class GetListClueBloc extends Bloc<GetListClueEvent, ClueState> {
  final UserRepository userRepository;

  GetListClueBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetListClue());

  @override
  Stream<ClueState> mapEventToState(GetListClueEvent event) async* {
    if (event is InitGetListClueEvent) {
      yield* _getListClue(
          filter: event.filter, page: event.page, search: event.search);
    }
  }

  List<ClueData>? listClueData;
  Stream<ClueState> _getListClue(
      {required String filter,
      required int page,
      required String search}) async* {
    LoadingApi().pushLoading();
    try {
      final response = await userRepository.getListClue(page, filter, search);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        if (page == 1) {
          listClueData = response.data!.list!;
        } else {
          listClueData!.addAll(response.data!.list!);
        }

        yield UpdateGetListClueState(
            listClueData!, response.data!.filter!, response.data!.total!);
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
        yield ErrorGetListClueState(response.msg ?? '');
    } catch (e) {
      yield ErrorGetListClueState(MESSAGES.CONNECT_ERROR);
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

  static GetListClueBloc of(BuildContext context) =>
      BlocProvider.of<GetListClueBloc>(context);
}
