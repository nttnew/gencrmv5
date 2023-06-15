import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../api_resfull/user_repository.dart';
import '../../src/base.dart';
import '../../src/messages.dart';
import '../../widgets/loading_api.dart';

part 'policy_state.dart';
part 'policy_event.dart';

class GetPolicyBloc extends Bloc<GetPolicyEvent, PolicyState> {
  final UserRepository userRepository;

  GetPolicyBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetPolicy());

  @override
  Stream<PolicyState> mapEventToState(GetPolicyEvent event) async* {
    if (event is InitGetPolicyEvent) {
      yield* _getPolicy();
    }
  }

  Stream<PolicyState> _getPolicy() async* {
    LoadingApi().pushLoading();
    try {
      final response = await userRepository.getPolicy();
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield UpdateGetPolicyState(response.data!.chinh_sach);
      } else
        yield ErrorGetPolicyState(response.msg ?? '');
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorGetPolicyState(MESSAGES.CONNECT_ERROR);
      throw e;
    }
    LoadingApi().popLoading();
  }

  static GetPolicyBloc of(BuildContext context) =>
      BlocProvider.of<GetPolicyBloc>(context);
}
