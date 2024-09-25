import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:equatable/equatable.dart';
import 'package:gen_crm/api_resfull/user_repository.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/storages/storages.dart';

part 'authentication_event.dart';

part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;
  AuthenticationBloc(
      {required this.userRepository,
      required EventRepositoryStorage localRepository})
      : _userRepository = userRepository,
        _localRepository = localRepository,
        super(const AuthenticationState.unknown()) {
    _authenticationStatusSubscription = _userRepository.status.listen(
      (status) => add(AuthenticationStatusChanged(status)),
    );
  }
  final EventRepositoryStorage _localRepository;
  final UserRepository _userRepository;
  late StreamSubscription<AuthenticationStatus>
      _authenticationStatusSubscription;

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthenticationStateInit) {
      yield* _mapAuthenticationStatusInit();
    } else if (event is AuthenticationStatusChanged) {
      yield* _mapAuthenticationStatusChangedToState(event);
    } else if (event is AuthenticationLogoutRequested) {
      await _localRepository.saveUser(dotenv.env[PreferencesKey.TOKEN]!);
      await shareLocal.putString(PreferencesKey.TOKEN, '');
      await shareLocal.putString(PreferencesKey.USER_CODE, '');
      await shareLocal.putString(PreferencesKey.USER_EMAIL, '');
      await _localRepository.saveUserID('');
      _userRepository.logOut();

      final deviceToken =
          await shareLocal.getString(PreferencesKey.DEVICE_TOKEN);
      await userRepository.logout(device_token: deviceToken);
      shareLocal.putString(PreferencesKey.DEVICE_TOKEN, '');
    }
  }

  @override
  Future<void> close() {
    _authenticationStatusSubscription.cancel();
    _userRepository.dispose();
    return super.close();
  }

  Stream<AuthenticationState> _mapAuthenticationStatusInit() async* {
    await _localRepository.loadUser();
  }

  Stream<AuthenticationState> _mapAuthenticationStatusChangedToState(
      AuthenticationStatusChanged event) async* {
    try {
      final response = await _localRepository.loadUser();
      if (response != dotenv.env[PreferencesKey.TOKEN]!) {
        try {
          final response = await _userRepository.getListCustomer(
            1,
            '',
            '',
            null,
            null,
          );
          if (isSuccess(response.code)) {
            yield AuthenticationState.authenticated();
          } else
            yield AuthenticationState.unauthenticated();
        } catch (e) {
          yield AuthenticationState.unauthenticated();
          throw e;
        }
      } else {
        yield AuthenticationState.unauthenticated();
      }
    } catch (e) {
      throw e;
    }
  }

  static AuthenticationBloc of(BuildContext context) =>
      BlocProvider.of<AuthenticationBloc>(context);
}
