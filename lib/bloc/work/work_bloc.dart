import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/api_resfull/api.dart';
import 'package:gen_crm/src/models/model_generator/clue_detail.dart';

import '../../src/base.dart';
import '../../src/messages.dart';
import '../../src/models/model_generator/work.dart';
import '../../widgets/loading_api.dart';


part 'work_event.dart';
part 'work_state.dart';

class WorkBloc extends Bloc<WorkEvent,WorkState>{
  UserRepository userRepository;
  WorkBloc({required UserRepository userRepository}) : userRepository = userRepository, super(InitGetListWorkState());
  @override
  Stream<WorkState> mapEventToState(WorkEvent event) async*{
    // TODO: implement mapEventToState
    if(event is InitGetListWorkEvent) {
      yield* _getListWork(event.pageIndex!,event.text!,event.filter_id!);
    }
  }

  List<WorkItemData> data=[];

  Stream<WorkState> _getListWork(String pageIndex,String text,String filter_id) async*{
    LoadingApi().pushLoading();
    try{
      final response = await userRepository.getListJob(pageIndex,text,filter_id);
      if((response.code == BASE_URL.SUCCESS)||(response.code == BASE_URL.SUCCESS_200)){
        if(int.parse(pageIndex)==1){
          data=response.data!.data_list!;
          yield SuccessGetListWorkState(response.data!.data_list!,response.data!.pageCount!,response.data!.data_filter!);
        }
        else{
          data=[...data,...response.data!.data_list!];
          yield SuccessGetListWorkState(data,response.data!.pageCount!,response.data!.data_filter!);
        }

      }
      else{
        yield ErrorGetListWorkState(response.msg ?? '');
      }


    } catch(e){
      yield ErrorGetListWorkState(MESSAGES.CONNECT_ERROR);
      throw(e);
    }
    LoadingApi().popLoading();
  }
  static WorkBloc of(BuildContext context) => BlocProvider.of<WorkBloc>(context);
}