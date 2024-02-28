import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/src/models/model_generator/note.dart';
import 'package:gen_crm/widgets/loading_api.dart';
import '../../api_resfull/user_repository.dart';
import '../../l10n/key_text.dart';
import '../../src/base.dart';

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
      if (isSuccess(response.code)) {
        yield SuccessGetNoteOppState(response.data?.notes ?? []);
      } else {
        if (isAdd) LoadingApi().popLoading();
        yield ErrorGetNoteOppState(response.msg ?? '');
      }
    } catch (e) {
      if (isAdd) LoadingApi().popLoading();
      yield ErrorGetNoteOppState(getT(KeyT.an_error_occurred));
      throw e;
    }
    if (isAdd) LoadingApi().popLoading();
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
      if (isSuccess(response.code)) {
        LoadingApi().popLoading();
        return response.data?.notes ?? [];
      } else if (isFail(response.code)) {
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
