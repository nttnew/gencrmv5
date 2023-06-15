import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/api_resfull/api.dart';

import '../../src/app_const.dart';
import '../../src/base.dart';
import '../../src/messages.dart';
import '../../widgets/loading_api.dart';
part 'checkin_event.dart';
part 'checkin_state.dart';

class CheckInBloc extends Bloc<CheckInEvent, CheckInState> {
  final UserRepository userRepository;

  CheckInBloc({required this.userRepository}) : super(InitCheckInState());

  @override
  Stream<CheckInState> mapEventToState(CheckInEvent event) async* {
    if (event is SaveCheckIn) {
      yield* saveCheckIn(
        longitude: event.longitude,
        latitude: event.latitude,
        location: event.location,
        id: event.id,
        module: event.module,
          type:event.type,
      );
    }
  }

  Stream<CheckInState> saveCheckIn({
    required String module,
    required String longitude,
    required String latitude,
    required String location,
    required String id,
    required String type,
  }) async* {
    LoadingApi().pushLoading();
    yield LoadingCheckInState();
    try {
      final response = await userRepository.saveCheckIn(
        longitude: longitude,
        latitude: latitude,
        location: location,
        id: id,
        module: module,
        type: type,
      );
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield SuccessCheckInState();
      } else if (response.code == BASE_URL.SUCCESS_999) {
        loginSessionExpired();
      } else {
        yield ErrorCheckInState(response.msg ?? '');
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorCheckInState(MESSAGES.CONNECT_ERROR);
      throw e;
    }
    LoadingApi().popLoading();
  }

  static CheckInBloc of(BuildContext context) =>
      BlocProvider.of<CheckInBloc>(context);
}
