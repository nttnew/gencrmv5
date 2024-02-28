import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../api_resfull/user_repository.dart';
import '../../l10n/key_text.dart';
import '../../src/base.dart';
import '../../src/models/model_generator/info_acc.dart';
import '../../widgets/loading_api.dart';

part 'get_infor_acc_event.dart';
part 'get_infor_acc_state.dart';

class GetInfoAccBloc extends Bloc<GetInforAccEvent, GetInforAccState> {
  final UserRepository userRepository;

  GetInfoAccBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetInforAccState());

  @override
  Stream<GetInforAccState> mapEventToState(GetInforAccEvent event) async* {
    if (event is InitGetInforAcc) {
      yield* _getInfoAcc(event.isLoading ?? true);
    }
  }

  Stream<GetInforAccState> _getInfoAcc(bool isLoading) async* {
    try {
      if (isLoading) LoadingApi().pushLoading();
      yield LoadingInforAccState();
      final response = await userRepository.getInfoAcc();
      if (isSuccess(response.code)) {
        if (isLoading) LoadingApi().popLoading();
        yield UpdateGetInforAccState(response.data!);
      } else {
        if (isLoading) LoadingApi().popLoading();
        yield ErrorGetInForAccState(response.msg ?? '');
      }
    } catch (e) {
      if (isLoading) LoadingApi().popLoading();
      yield ErrorGetInForAccState(
        getT(KeyT.an_error_occurred),
      );
    }
  }

  static GetInfoAccBloc of(BuildContext context) =>
      BlocProvider.of<GetInfoAccBloc>(context);
}
