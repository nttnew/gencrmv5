import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/src/models/model_generator/note.dart';
import 'package:gen_crm/widgets/loading_api.dart';
import '../../api_resfull/user_repository.dart';
import '../../src/base.dart';
import '../../src/messages.dart';

part 'list_note_event.dart';
part 'list_note_state.dart';

class ListNoteBloc extends Bloc<ListNoteEvent, ListNoteState> {
  final UserRepository userRepository;

  ListNoteBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetListNoteState());

  @override
  Stream<ListNoteState> mapEventToState(ListNoteEvent event) async* {
    if (event is InitNoteEvent) {
      yield* _getListNote(
        module: event.module,
        id: event.id,
        page: event.page,
      );
    } else if (event is ReloadEvent) {
      yield SuccessGetNoteOppState([]);
    }
  }

  Stream<ListNoteState> _getListNote({
    required String id,
    required String module,
    required String page,
  }) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingGetNoteOppState();
      final response = await userRepository.getNoteList(
        getURLModule(module),
        id,
        page,
      );
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield SuccessGetNoteOppState(response.data?.notes ?? []);
      } else {
        yield ErrorGetNoteOppState(response.msg ?? '');
        LoadingApi().popLoading();
      }
    } catch (e) {
      yield ErrorGetNoteOppState(MESSAGES.CONNECT_ERROR);
      LoadingApi().popLoading();
      throw e;
    }
    LoadingApi().popLoading();
  }

  static ListNoteBloc of(BuildContext context) =>
      BlocProvider.of<ListNoteBloc>(context);
}
