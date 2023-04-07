import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api_resfull/user_repository.dart';

part 'attack_event.dart';
part 'attack_state.dart';

class AttackBloc extends Bloc<AttackEvent, AttackState> {
  final UserRepository userRepository;

  AttackBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitAttackState());

  @override
  Stream<AttackState> mapEventToState(AttackEvent event) async* {
    if (event is InitAttackEvent) {
      if (event.file != null)
        yield* _getAttack(file: event.file);
      else
        yield* _getAttack();
    }
    if (event is LoadingAttackEvent) {
      yield LoadingAttackState();
    }
  }

  Stream<AttackState> _getAttack({File? file}) async* {
    yield LoadingAttackState();
    if (file == null) {
      yield SuccessAttackState();
    } else
      yield SuccessAttackState(file: file);
  }

  static AttackBloc of(BuildContext context) =>
      BlocProvider.of<AttackBloc>(context);
}
