part of 'resend_bloc.dart';

class ResendOTPState {
  final int time;
  final bool isTimeValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final String message;

  ResendOTPState({this.time = 0, this.isTimeValid = true, this.isSubmitting= true, this.isSuccess= true, this.isFailure= true, this.message = ''});

  bool get isFormValid => isTimeValid && time == 0;

  factory ResendOTPState.empty() {
    return ResendOTPState(
        time: 0,
        isTimeValid: true,
        isSubmitting: false,
        isSuccess: false,
        isFailure: false,
        message: '');
  }

  factory ResendOTPState.loading() {
    return ResendOTPState(
        time: 0,
        isTimeValid: false,
        isSubmitting: true,
        isSuccess: false,
        isFailure: false,
        message: '');
  }

  factory ResendOTPState.failure({required String message}) {
    return ResendOTPState(
        time: 0,
        isTimeValid: true,
        isSuccess: false,
        isSubmitting: false,
        isFailure: true,
        message: message);
  }

  factory ResendOTPState.success({required String message}) {
    return ResendOTPState(
        time: 0,
        isTimeValid: false,
        isSuccess: true,
        isSubmitting: false,
        isFailure: false,
        message: message);
  }

  ResendOTPState update({
    required int time,
    required bool isTimeValid,
  }) {
    return copyWith(
      time: time,
      isTimeValid: isTimeValid,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      message: '',
    );
  }

  ResendOTPState copyWith({
    int? time,
    bool? isTimeValid,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFailure,
    String? message,
  }) {
    return ResendOTPState(
      time: time ?? this.time,
      isTimeValid: isTimeValid ?? this.isTimeValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      message: message ?? this.message,
    );
  }
}
