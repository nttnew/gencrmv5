import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/api_resfull/api.dart';
import '../../l10n/key_text.dart';
import '../../src/app_const.dart';
import '../../src/base.dart';
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
        type: event.type,
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
      if (isSuccess(response.code)) {
        yield SuccessCheckInState();
      } else if (isFail(response.code)) {
        loginSessionExpired();
      } else {
        yield ErrorCheckInState(response.msg ?? '');
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorCheckInState(
         getT(KeyT.an_error_occurred));
      throw e;
    }
    LoadingApi().popLoading();
  }

  static CheckInBloc of(BuildContext context) =>
      BlocProvider.of<CheckInBloc>(context);
}
