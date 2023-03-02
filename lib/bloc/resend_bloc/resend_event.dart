part of 'resend_bloc.dart';

abstract class ResendOTPEvent extends Equatable {
  const ResendOTPEvent();

  @override
  List<Object> get props => [];
}

class TimeInit extends ResendOTPEvent {
  final Duration time;

  const TimeInit({required this.time});

  @override
  List<Object> get props => [time];

  @override
  String toString() {
    return 'TimeInit{time: $time}';
  }
}


class TimeChanged extends ResendOTPEvent {
  final int time;

  const TimeChanged({required this.time});

  @override
  List<Object> get props => [time];

  @override
  String toString() {
    return 'TimeChanged{time: $time}';
  }
}


class ResendOTPSubmit extends ResendOTPEvent {
  final String username;
  final String email;
  final String timestamp;

  const ResendOTPSubmit({
    required this.username,
    required this.timestamp,
    required this.email,
  });

  @override
  List<Object> get props => [email,username,timestamp];

  @override
  String toString() {
    return 'ResendOTPSubmit{email: $email}';
  }
}

