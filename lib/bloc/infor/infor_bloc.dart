import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../api_resfull/user_repository.dart';
import '../../l10n/key_text.dart';
import '../../src/base.dart';
import '../../widgets/loading_api.dart';

part 'infor_state.dart';
part 'infor_event.dart';

class GetInforBloc extends Bloc<GetInforEvent, InforState> {
  final UserRepository userRepository;

  GetInforBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetInforState());

  @override
  Stream<InforState> mapEventToState(GetInforEvent event) async* {
    if (event is InitGetInforEvent) {
      yield* _getInfor();
    }
  }

  Stream<InforState> _getInfor() async* {
    Loading().showLoading();
    try {
      final response = await userRepository.getInfo();
      if (isSuccess(response.code)) {
        yield UpdateGetInforState(response.data!.gioi_thieu);
      } else
        yield ErrorGetInforState(response.msg ?? '');
    } catch (e) {
      Loading().popLoading();
      yield ErrorGetInforState(
         getT(KeyT.an_error_occurred));
      throw e;
    }
    Loading().popLoading();
  }

  static GetInforBloc of(BuildContext context) =>
      BlocProvider.of<GetInforBloc>(context);
}
