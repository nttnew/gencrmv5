import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../api_resfull/user_repository.dart';
import '../../src/app_const.dart';
import '../../src/base.dart';
import '../../src/messages.dart';
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
    // LoadingApi().pushLoading();
    try {
      yield LoadingInforAccState();
      final response = await userRepository.getInforAcc();
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
      loginSessionExpired();
      yield ErrorGetInForAccState(MESSAGES.CONNECT_ERROR);
      throw e;
    }
    LoadingApi().popLoading();
  }

  static GetInforAccBloc of(BuildContext context) =>
      BlocProvider.of<GetInforAccBloc>(context);
}
