import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/widgets/loading_api.dart';
import '../../api_resfull/user_repository.dart';
import '../../l10n/key_text.dart';
import '../../src/base.dart';

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
      yield* _addNote(
        id: event.id,
        content: event.content,
        module: event.module,
      );
    } else if (event is EditNoteEvent) {
      yield* _editNoteCus(
        id: event.id,
        content: event.content,
        noteId: event.id_note,
        module: event.module,
      );
    } else if (event is DeleteNoteEvent) {
      yield* _deleteNote(
        id: event.id,
        noteId: event.noteId,
        module: event.module,
      );
    }
  }

  Stream<AddNoteState> _addNote({
    required String id,
    required String content,
    required String module,
  }) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingAddNoteState();
      final response = await userRepository.addNote(
        id: id,
        content: content,
        module: getURLModule(module),
      );
      if (isSuccess(response.code)) {
        LoadingApi().popLoading();
        yield SuccessAddNoteState();
      } else {
        yield ErrorAddNoteState(response.msg ?? '');
      }
    } catch (e) {
      yield ErrorAddNoteState(
         getT(KeyT.an_error_occurred));
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<AddNoteState> _editNoteCus({
    required String id,
    required String content,
    required String noteId,
    required String module,
  }) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingAddNoteState();
      final response = await userRepository.editNote(
        id: id,
        content: content,
        noteId: noteId,
        module: getURLModule(module),
      );
      if (isSuccess(response.code)) {
        yield SuccessAddNoteState();
      } else {
        yield ErrorAddNoteState(response.msg ?? '');
        LoadingApi().popLoading();
      }
    } catch (e) {
      yield ErrorAddNoteState(
          getT(KeyT.an_error_occurred),);
      LoadingApi().popLoading();
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<AddNoteState> _deleteNote({
    required String id,
    required String noteId,
    required String module,
  }) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingDeleteNoteState();
      final response = await userRepository.deleteNote(
        noteId,
        id,
        getURLModule(module),
      );
      if (isSuccess(response.code)) {
        yield SuccessAddNoteState();
      } else {
        yield ErrorDeleteNoteState(response.msg ?? '');
        LoadingApi().popLoading();
      }
    } catch (e) {
      yield ErrorDeleteNoteState(
         getT(KeyT.an_error_occurred));
      LoadingApi().popLoading();
      throw e;
    }
    LoadingApi().popLoading();
  }

  static AddNoteBloc of(BuildContext context) =>
      BlocProvider.of<AddNoteBloc>(context);
}
