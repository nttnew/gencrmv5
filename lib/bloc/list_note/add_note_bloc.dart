import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/widgets/loading_api.dart';

import '../../api_resfull/user_repository.dart';
import '../../src/base.dart';
import '../../src/messages.dart';

part 'add_note_event.dart';
part 'add_note_state.dart';

class AddNoteBloc extends Bloc<AddNoteEvent, AddNoteState> {
  final UserRepository userRepository;

  AddNoteBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitAddNoteState());

  @override
  Stream<AddNoteState> mapEventToState(AddNoteEvent event) async* {
    if (event is InitAddNoteEvent) {
      yield* _addNote(id: event.id, content: event.content, type: event.type);
    } else if (event is InitEditNoteEvent) {
      yield* _editNoteCus(
          id: event.id,
          content: event.content,
          noteId: event.id_note,
          type: event.type);
    } else if (event is InitDeleteNoteEvent) {
      yield* _deleteNote(id: event.id, noteId: event.noteId, type: event.type);
    }
  }

  Stream<AddNoteState> _addNote(
      {required String id, required String content, required int type}) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingAddNoteState();
      final response;
      if (type == 1)
        response = await userRepository.addNoteCus(id: id, content: content);
      else if (type == 2)
        response =
            await userRepository.addNoteContact(id: id, content: content);
      else if (type == 3)
        response = await userRepository.addNoteOpp(id: id, content: content);
      else if (type == 4)
        response =
            await userRepository.addNoteContract(id: id, content: content);
      else if (type == 5)
        response = await userRepository.addNoteJob(id: id, content: content);
      else
        response = await userRepository.addNoteSup(id: id, content: content);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        LoadingApi().popLoading();
        yield SuccessAddNoteState();
      } else {
        yield ErrorAddNoteState(response.msg ?? '');
        LoadingApi().popLoading();
      }
    } catch (e) {
      yield ErrorAddNoteState(MESSAGES.CONNECT_ERROR);
      LoadingApi().popLoading();
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<AddNoteState> _editNoteCus(
      {required String id,
      required String content,
      required String noteId,
      required int type}) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingAddNoteState();
      final response;
      if (type == 1)
        response = await userRepository.editNoteCus(
            id: id, content: content, noteId: noteId);
      else if (type == 2)
        response = await userRepository.editNoteContact(
            id: id, content: content, noteId: noteId);
      else if (type == 3)
        response = await userRepository.editNoteOop(
            id: id, content: content, noteId: noteId);
      else if (type == 4)
        response = await userRepository.editNoteContract(
            id: id, content: content, noteId: noteId);
      else if (type == 5)
        response = await userRepository.editNoteJob(
            id: id, content: content, noteId: noteId);
      else
        response = await userRepository.editNoteSup(
            id: id, content: content, noteId: noteId);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield SuccessAddNoteState();
      } else {
        yield ErrorAddNoteState(response.msg ?? '');
        LoadingApi().popLoading();
      }
    } catch (e) {
      yield ErrorAddNoteState(MESSAGES.CONNECT_ERROR);
      LoadingApi().popLoading();
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<AddNoteState> _deleteNote(
      {required String id, required String noteId, required int type}) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingDeleteNoteState();
      final response;
      if (type == 1)
        response = await userRepository.deleteNoteCus(noteId, id);
      else if (type == 2)
        response = await userRepository.deleteNoteContact(noteId, id);
      else if (type == 3)
        response = await userRepository.deleteNoteOop(noteId, id);
      else if (type == 4)
        response = await userRepository.deleteNoteContract(noteId, id);
      else if (type == 5)
        response = await userRepository.deleteNoteJob(noteId, id);
      else
        response = await userRepository.deleteNoteSup(noteId, id);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield SuccessAddNoteState();
      } else {
        yield ErrorDeleteNoteState(response.msg ?? '');
        LoadingApi().popLoading();
      }
    } catch (e) {
      yield ErrorDeleteNoteState(MESSAGES.CONNECT_ERROR);
      LoadingApi().popLoading();
      throw e;
    }
    LoadingApi().popLoading();
  }

  static AddNoteBloc of(BuildContext context) =>
      BlocProvider.of<AddNoteBloc>(context);
}
