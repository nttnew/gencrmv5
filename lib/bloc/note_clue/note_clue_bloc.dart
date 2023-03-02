import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/api_resfull/api.dart';
import 'package:gen_crm/src/models/model_generator/clue_detail.dart';

import '../../src/base.dart';
import '../../src/messages.dart';
import '../../src/models/model_generator/note_clue.dart';
import '../../widgets/loading_api.dart';


part 'note_clue_event.dart';
part 'note_clue_state.dart';

class GetNoteClueBloc extends Bloc<GetNoteClueEvent,NoteClueState>{
  UserRepository userRepository;
  GetNoteClueBloc({required UserRepository userRepository}) : userRepository = userRepository, super(InitGetNoteClueState());
  @override
  Stream<NoteClueState> mapEventToState(GetNoteClueEvent event) async*{
    // TODO: implement mapEventToState
    if(event is InitGetNoteClueEvent) {
      yield* _getNoteClue(event.id!);
    }
  }
  Stream<NoteClueState> _getNoteClue(String id) async*{
    LoadingApi().pushLoading();
    try{
      final responseListNoteClue = await userRepository.getListNoteClue(id);
      if( (responseListNoteClue.code == BASE_URL.SUCCESS)||(responseListNoteClue.code == BASE_URL.SUCCESS_200)){
        yield UpdateGetNoteClueState(responseListNoteClue.data!.notes!);
      }
      else{
        yield ErrorGetNoteClueState( responseListNoteClue.msg ?? '');
      }


    } catch(e){
      yield ErrorGetNoteClueState( MESSAGES.CONNECT_ERROR);
      throw(e);
    }
    LoadingApi().popLoading();
  }
  static GetNoteClueBloc of(BuildContext context) => BlocProvider.of<GetNoteClueBloc>(context);
}