import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/infor/infor_bloc.dart';
import 'package:get/get.dart';

import '../../api_resfull/user_repository.dart';
import '../../src/base.dart';
import '../../src/color.dart';
import '../../src/messages.dart';
import '../../src/models/model_generator/infor_acc.dart';
import '../../src/navigator.dart';
import '../../widgets/loading_api.dart';
import '../../widgets/widget_dialog.dart';

part 'get_infor_acc_event.dart';
part 'get_infor_acc_state.dart';
class GetInforAccBloc extends Bloc<GetInforAccEvent, GetInforAccState>{
  final UserRepository userRepository;

  GetInforAccBloc({required UserRepository userRepository}) : userRepository = userRepository, super(InitGetInforAccState());

  @override
  Stream<GetInforAccState> mapEventToState(GetInforAccEvent event) async* {
    if (event is InitGetInforAcc) {
      yield* _getInfoAcc();
    }
  }

  Stream<GetInforAccState> _getInfoAcc() async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingInforAccState();
      final response = await userRepository.getInforAcc();
      if((response.code == BASE_URL.SUCCESS)||(response.code == BASE_URL.SUCCESS_200)){
        yield UpdateGetInforAccState(response.data!);
        LoadingApi().popLoading();
      }
      else{
        yield ErrorGetInForAccState(response.msg ?? "");
        LoadingApi().popLoading();
      }

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
      yield ErrorGetInForAccState(MESSAGES.CONNECT_ERROR);
      throw e;
    }
    LoadingApi().popLoading();
  }



  static GetInforAccBloc of(BuildContext context) => BlocProvider.of<GetInforAccBloc>(context);
}