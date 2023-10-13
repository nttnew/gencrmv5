import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/widgets/loading_api.dart';
import '../../api_resfull/user_repository.dart';
import '../../l10n/key_text.dart';
import '../../src/app_const.dart';
import '../../src/base.dart';

part 'phone_event.dart';
part 'phone_state.dart';

class PhoneBloc extends Bloc<PhoneEvent, PhoneState> {
  final UserRepository userRepository;
  String phone = "";

  PhoneBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitPhoneState());

  @override
  Stream<PhoneState> mapEventToState(PhoneEvent event) async* {
    if (event is InitPhoneEvent) {
      yield* _getPhone(event.id);
    }
    if (event is InitAgencyPhoneEvent) {
      yield* _getPhoneAgency(event.id);
    }
  }

  Stream<PhoneState> _getPhone(String id) async* {
    try {
      yield LoadingPhoneState();
      final response = await userRepository.getPhoneCus(id);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield SuccessPhoneState(response.data ?? '');
      } else if (response.code == BASE_URL.SUCCESS_999) {
        loginSessionExpired();
      } else
        yield ErrorPhoneState(response.msg ?? '');
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorPhoneState(
          getT(KeyT.an_error_occurred ));
      throw e;
    }
  }

  Stream<PhoneState> _getPhoneAgency(String id) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingPhoneState();
      final response = await userRepository.getPhoneAgency(id);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        if (response.data != "" && response.data != null) {
          phone = response.data!;
          yield SuccessPhoneState(response.data!);
        } else {
          yield SuccessPhoneState(phone);
        }
      } else if (response.code == BASE_URL.SUCCESS_999) {
        loginSessionExpired();
      } else
        yield ErrorPhoneState(response.msg ?? '');
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorPhoneState(
          getT(KeyT.an_error_occurred ));
      throw e;
    }
    LoadingApi().popLoading();
  }

  static PhoneBloc of(BuildContext context) =>
      BlocProvider.of<PhoneBloc>(context);
}
