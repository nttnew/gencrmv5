import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../api_resfull/user_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import '../../src/base.dart';
import '../../src/models/model_generator/infor_acc.dart';
import '../../widgets/loading_api.dart';

part 'get_infor_acc_event.dart';
part 'get_infor_acc_state.dart';

class GetInforAccBloc extends Bloc<GetInforAccEvent, GetInforAccState> {
  final UserRepository userRepository;

  GetInforAccBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetInforAccState());

  @override
  Stream<GetInforAccState> mapEventToState(GetInforAccEvent event) async* {
    if (event is InitGetInforAcc) {
      yield* _getInfoAcc();
    }
  }

  Stream<GetInforAccState> _getInfoAcc() async* {
    try {
      yield LoadingInforAccState();
      final response = await userRepository.getInfoAcc();
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        LoadingApi().popLoading();
        yield UpdateGetInforAccState(response.data!);
      } else {
        LoadingApi().popLoading();
        yield ErrorGetInForAccState(response.msg ?? "");
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorGetInForAccState(
          AppLocalizations.of(Get.context!)?.an_error_occurred ?? '');
      throw e;
    }
    LoadingApi().popLoading();
  }

  static GetInforAccBloc of(BuildContext context) =>
      BlocProvider.of<GetInforAccBloc>(context);
}
