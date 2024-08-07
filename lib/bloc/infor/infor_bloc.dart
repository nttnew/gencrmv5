import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../api_resfull/user_repository.dart';
import '../../l10n/key_text.dart';
import '../../src/base.dart';

part 'infor_state.dart';
part 'infor_event.dart';

class GetInfoBloc extends Bloc<GetInfoEvent, InfoState> {
  final UserRepository userRepository;

  GetInfoBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetInfoState());

  @override
  Stream<InfoState> mapEventToState(GetInfoEvent event) async* {
    if (event is InitGetInfoEvent) {
      yield* _getInfo();
    }
  }

  Stream<InfoState> _getInfo() async* {
    try {
      final response = await userRepository.getInfo();
      if (isSuccess(response.code)) {
        yield UpdateGetInfoState(response.data?.gioi_thieu ?? '');
      } else
        yield ErrorGetInfoState(response.msg ?? '');
    } catch (e) {
      yield ErrorGetInfoState(getT(KeyT.an_error_occurred));
      throw e;
    }
  }

  static GetInfoBloc of(BuildContext context) =>
      BlocProvider.of<GetInfoBloc>(context);
}
