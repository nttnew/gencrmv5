import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../api_resfull/user_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import '../../src/base.dart';
import '../../widgets/loading_api.dart';

part 'infor_state.dart';
part 'infor_event.dart';

class GetInforBloc extends Bloc<GetInforEvent, InforState> {
  final UserRepository userRepository;

  GetInforBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetInforState());

  @override
  Stream<InforState> mapEventToState(GetInforEvent event) async* {
    if (event is InitGetInforEvent) {
      yield* _getInfor();
    }
  }

  Stream<InforState> _getInfor() async* {
    LoadingApi().pushLoading();
    try {
      final response = await userRepository.getInfor();
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield UpdateGetInforState(response.data!.gioi_thieu);
      } else
        yield ErrorGetInforState(response.msg ?? '');
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorGetInforState(
          AppLocalizations.of(Get.context!)?.an_error_occurred ?? '');
      throw e;
    }
    LoadingApi().popLoading();
  }

  static GetInforBloc of(BuildContext context) =>
      BlocProvider.of<GetInforBloc>(context);
}
