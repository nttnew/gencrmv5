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

  List<File> listFile = [];

  @override
  Stream<AttackState> mapEventToState(AttackEvent event) async* {
    if (event is InitAttackEvent) {
      if (event.files?.isNotEmpty ?? false) {
        listFile.addAll(event.files ?? []);
        yield* _getAttack(files: listFile);
      } else
        yield* _getAttack();
    }
    if (event is RemoveAttackEvent) {
      listFile.remove(event.file);
      yield* _getAttack(files: listFile);
    }
    if (event is RemoveAllAttackEvent) {
      listFile = [];
      yield* _getAttack(files: []);
    }
    if (event is LoadingAttackEvent) {
      yield LoadingAttackState();
    }
  }

  Stream<AttackState> _getAttack({List<File>? files}) async* {
    yield LoadingAttackState();
    if (files == null) {
      yield SuccessAttackState();
    } else
      yield SuccessAttackState(files: files);
  }

  static AttackBloc of(BuildContext context) =>
      BlocProvider.of<AttackBloc>(context);
}
