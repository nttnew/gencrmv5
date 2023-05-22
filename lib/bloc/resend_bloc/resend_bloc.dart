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

  ResendOTPBloc({required this.userRepository}) : super(ResendOTPState.empty());

  ResendOTPState get initialState => ResendOTPState.empty();

  @override
  Stream<ResendOTPState> mapEventToState(ResendOTPEvent event) async* {
    if (event is TimeInit) {
      yield* _mapTimeInitToState(event.time);
    } else if (event is TimeChanged) {
      yield* _mapTimeChangeToState(event.time);
    } else if (event is ResendOTPSubmit) {}
  }

  late StreamSubscription _streamSubscription;

  Stream<ResendOTPState> _mapTimeInitToState(Duration time) async* {
    CountdownTimer _countDownTimer;
    _countDownTimer = new CountdownTimer(time, Duration(seconds: 1));
    _streamSubscription = _countDownTimer.listen(null);
    _streamSubscription.onData((duration) {
      this.add(TimeChanged(time: duration.remaining.inSeconds));
    });

    _streamSubscription.onDone(() async* {
      _streamSubscription.cancel();
    });
  }

  Stream<ResendOTPState> _mapTimeChangeToState(int time) async* {
    yield state.update(
        time: time, isTimeValid: Validator.isValidResendOtp(time));
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}
