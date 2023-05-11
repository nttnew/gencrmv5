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
      );
    }
  }

  Stream<CheckInState> saveCheckIn({
    required String longitude,
    required String latitude,
    required String location,
    required String id,
  }) async* {
    LoadingApi().pushLoading();
    try {
      final response = await userRepository.saveCheckIn(
        longitude: longitude,
        latitude: latitude,
        location: location,
        id: id,
      );
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield SuccessCheckInState();
      } else if (response.code == 999) {
        loginSessionExpired();
      } else {
        yield ErrorCheckInState(response.msg ?? '');
      }
    } catch (e) {
      yield ErrorCheckInState(MESSAGES.CONNECT_ERROR);
      LoadingApi().popLoading();
      loginSessionExpired();
      throw e;
    }
    LoadingApi().popLoading();
  }

  static CheckInBloc of(BuildContext context) =>
      BlocProvider.of<CheckInBloc>(context);
}