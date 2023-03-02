import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiver/async.dart';
import 'package:gen_crm/api_resfull/user_repository.dart';
import 'package:gen_crm/src/src_index.dart';

part 'resend_event.dart';
part 'resend_state.dart';

class ResendOTPBloc extends Bloc<ResendOTPEvent, ResendOTPState> {
  final UserRepository userRepository;

  ResendOTPBloc({required this.userRepository}): super(ResendOTPState.empty());


  @override
  ResendOTPState get initialState => ResendOTPState.empty();

  @override
  Stream<ResendOTPState> mapEventToState(
      ResendOTPEvent event) async* {
    if (event is TimeInit) {
      yield* _mapTimeInitToState(event.time);
    } else if (event is TimeChanged) {
      yield* _mapTimeChangeToState(event.time);
    } else if (event is ResendOTPSubmit) {
      // yield* _mapResendOtpToState(event.email,event.username,event.timestamp);
    }
  }

  late StreamSubscription _streamSubscription;

  Stream<ResendOTPState> _mapTimeInitToState(Duration time) async* {
    CountdownTimer _countDownTimer;
    _countDownTimer =
    new CountdownTimer(time, Duration(seconds: 1));
    _streamSubscription = _countDownTimer.listen(null);
    _streamSubscription.onData(( duration) {
      print('time: ${duration.remaining.inSeconds}');
      this.add(TimeChanged(time: duration.remaining.inSeconds));
    });

    _streamSubscription.onDone(() async* {
      _streamSubscription.cancel();
    });
  }

  Stream<ResendOTPState> _mapTimeChangeToState(int time) async* {
    yield state.update(time: time, isTimeValid: Validator.isValidResendOtp(time));
  }

  // Stream<ResendOTPState> _mapResendOtpToState(
  //     String username,
  //     String timestamp,
  //     String email) async* {
  //   yield ResendOTPState.loading();
  //   try {
  //     ParamForgotPassword paramForgotPassword = ParamForgotPassword(
  //       username: username,
  //         timestamp: timestamp,
  //         email: email
  //     );
  //     var response = await userRepository.forgotPassword(email: email,username: username,timestamp: timestamp);
  //
  //     if (response.code == true) {
  //       yield ResendOTPState.success(message: response.message!);
  //     } else {
  //       yield ResendOTPState.failure(message: response.message!);
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //     yield ResendOTPState.failure(message: MESSAGES.CONNECT_ERROR);
  //   }
  // }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}
