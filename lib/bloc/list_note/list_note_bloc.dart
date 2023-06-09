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
  String? module;
  String? id;
  bool? isAdd;

  ListNoteBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetListNoteState());

  @override
  Stream<ListNoteState> mapEventToState(ListNoteEvent event) async* {
    if (event is InitNoteEvent) {
      module = event.module;
      id = event.id;
      isAdd = event.isAdd;
      yield* _getListNote(
        module: event.module,
        id: event.id,
        page: event.page,
        isAdd: event.isAdd,
      );
    } else if (event is ReloadEvent) {
      yield SuccessGetNoteOppState([]);
    } else if (event is RefreshEvent) {
      yield* _getListNote(
        module: module ?? '',
        id: id ?? '',
        page: BASE_URL.PAGE_DEFAULT.toString(),
        isAdd: isAdd ?? false,
      );
    }
  }

  Stream<ListNoteState> _getListNote({
    required String id,
    required String module,
    required String page,
    required bool isAdd,
  }) async* {
    if (isAdd) LoadingApi().pushLoading();
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

  Future<dynamic> getListNote({
    required String id,
    required String module,
    required String page,
    required bool isAdd,
    required bool isInit,
  }) async {
    if (isInit) {
      LoadingApi().pushLoading();
    }
    try {
      final response = await userRepository.getNoteList(
        getURLModule(module),
        id,
        page,
      );
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        LoadingApi().popLoading();
        return response.data?.notes ?? [];
      } else if (response.code == 999) {
        LoadingApi().popLoading();
        return response.msg ?? '';
      } else {
        LoadingApi().popLoading();
        return response.msg ?? '';
      }
    } catch (e) {
      LoadingApi().popLoading();
    }
  }

  static ListNoteBloc of(BuildContext context) =>
      BlocProvider.of<ListNoteBloc>(context);
}
