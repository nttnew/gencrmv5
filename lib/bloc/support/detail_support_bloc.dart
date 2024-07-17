import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/widgets/loading_api.dart';
import '../../api_resfull/user_repository.dart';
import '../../l10n/key_text.dart';
import '../../src/base.dart';
import '../../src/models/model_generator/detail_customer.dart';
import '../../src/models/model_generator/support.dart';
import '../../src/models/model_generator/work.dart';

part 'detail_support_event.dart';
part 'detail_support_state.dart';

class DetailSupportBloc extends Bloc<DetailSupportEvent, DetailSupportState> {
  final UserRepository userRepository;

  DetailSupportBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetDetailSupport());

  @override
  Stream<DetailSupportState> mapEventToState(DetailSupportEvent event) async* {
    if (event is InitGetDetailSupportEvent) {
      yield* _getDetailSupport(id: event.id);
    }
    if (event is DeleteSupportEvent) {
      yield* _deleteSupport(id: event.id);
    }
  }

  List<SupportItemData>? list;

  Stream<DetailSupportState> _getDetailSupport({required String id}) async* {
    try {
      yield LoadingDetailSupportState();
      final response = await userRepository.getDetailSupport(id);
      if (isSuccess(response.code)) {
        yield SuccessGetDetailSupportState(
          response.data ?? [],
          response.location,
          response.checkin,
          response.checkout,
        );
      } else {
        yield ErrorGetDetailSupportState(response.msg ?? '');
      }
    } catch (e) {
      yield ErrorGetDetailSupportState(getT(KeyT.an_error_occurred));
    }
  }

  Stream<DetailSupportState> _deleteSupport({required String id}) async* {
    Loading().showLoading();
    try {
      final response = await userRepository.deleteSupport({"id": id});
      if (isSuccess(response.code)) {
        yield SuccessDeleteSupportState();
      } else {
        Loading().popLoading();
        yield ErrorDeleteSupportState(response.msg ?? '');
      }
    } catch (e) {
      Loading().popLoading();
      yield ErrorDeleteSupportState(getT(KeyT.an_error_occurred));
      throw e;
    }
    Loading().popLoading();
  }

  static DetailSupportBloc of(BuildContext context) =>
      BlocProvider.of<DetailSupportBloc>(context);
}
