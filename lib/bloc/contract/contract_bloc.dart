import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/src/models/model_generator/customer_clue.dart';
import 'package:rxdart/rxdart.dart';
import '../../api_resfull/user_repository.dart';
import '../../l10n/key_text.dart';
import '../../src/base.dart';
import '../../src/models/model_generator/contract.dart';
import '../../widgets/listview/list_load_infinity.dart';

part 'contract_event.dart';
part 'contract_state.dart';

class ContractBloc extends Bloc<ContractEvent, ContractState> {
  final UserRepository userRepository;
  BehaviorSubject<List<Customer>> listType = BehaviorSubject.seeded([]);
  LoadMoreController loadMoreController = LoadMoreController();
  String idFilter = '';
  String search = '';
  String ids = '';

  dispose() {
    idFilter = '';
    search = '';
    ids = '';
  }

  ContractBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetContract());

  Future<dynamic> getListContract({
    int page = BASE_URL.PAGE_DEFAULT,
  }) async {
    dynamic resDynamic = '';
    try {
      final response = await userRepository.getListContract(
        page,
        search,
        idFilter,
        ids,
      );
      if (isSuccess(response.code)) {
        if (page == BASE_URL.PAGE_DEFAULT)
          listType.add(response.data?.filter ?? []);
        resDynamic = response.data?.list ?? [];
      } else
        resDynamic = response.msg ?? '';
    } catch (e) {
      resDynamic = getT(KeyT.an_error_occurred);
      return resDynamic;
    }
    return resDynamic;
  }

  static ContractBloc of(BuildContext context) =>
      BlocProvider.of<ContractBloc>(context);
}
