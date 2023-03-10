import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/src/models/model_generator/detail_contract.dart';
import 'package:gen_crm/widgets/loading_api.dart';

import '../../api_resfull/user_repository.dart';
import '../../src/base.dart';
import '../../src/messages.dart';
import '../../src/models/model_generator/contract.dart';
import '../../src/models/model_generator/customer.dart';
import '../../src/models/model_generator/job_chance.dart';
import '../../src/models/model_generator/support.dart';

part 'support_event.dart';
part 'support_state.dart';

class SupportBloc extends Bloc<SupportEvent, SupportState>{
  final UserRepository userRepository;

  SupportBloc({required UserRepository userRepository}) : userRepository = userRepository, super(InitGetSupport());

  @override
  Stream<SupportState> mapEventToState(SupportEvent event) async* {
    if (event is InitGetSupportEvent) {
      yield* _getListSupport(filter: event.filter, page: event.page, search: event.search);
    }
  }

  List<SupportItemData>? list;

  Stream<SupportState> _getListSupport({required String filter, required int page, required String search}) async* {
    LoadingApi().pushLoading();
    try {
      final response = await userRepository.getListSupport(page,search, filter);
      if((response.code == BASE_URL.SUCCESS)||(response.code == BASE_URL.SUCCESS_200)){
        if(page==1){
          list=response.data.list;
          yield SuccessGetSupportState(response.data.list!,response.data.total!,response.data.filter!);
        }
        else
        {
          list=[...list!,...response.data.list!];
          yield SuccessGetSupportState(list!,response.data.total!,response.data.filter!);
        }
      }
      else
        yield ErrorGetSupportState(response.msg ?? '');
    } catch (e) {
      yield ErrorGetSupportState(MESSAGES.CONNECT_ERROR);
      throw e;
    }
    LoadingApi().popLoading();
  }

  static SupportBloc of(BuildContext context) => BlocProvider.of<SupportBloc>(context);
}