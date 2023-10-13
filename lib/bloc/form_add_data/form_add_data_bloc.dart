import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/widgets/loading_api.dart';
import 'package:rxdart/rxdart.dart';
import '../../api_resfull/user_repository.dart';
import '../../l10n/key_text.dart';
import '../../src/base.dart';
import '../../src/models/model_generator/add_customer.dart';

part 'form_add_data_event.dart';
part 'form_add_data_state.dart';

class FormAddBloc extends Bloc<FormAddEvent, FormAddState> {
  final UserRepository userRepository;
  final BehaviorSubject<String> addressStream = BehaviorSubject();
  final BehaviorSubject<List<dynamic>> customerNewStream =
      BehaviorSubject.seeded([]);

  FormAddBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitFormAddState());

  @override
  Stream<FormAddState> mapEventToState(FormAddEvent event) async* {
    addressStream.add('');
    if (event is InitFormAddCusOrEvent) {
      yield* _getFormAddCustomerOrganization();
    } else if (event is InitFormAddContactCusEvent) {
      yield* _getFormAddContactCustomer(checkId(event.id ?? ''));
    } else if (event is InitFormAddOppCusEvent) {
      yield* _getFormAddOppCus(checkId(event.id ?? ''));
    } else if (event is InitFormAddContractCusEvent) {
      yield* _getFormAddContractCus(checkId(event.id ?? ''));
    } else if (event is InitFormAddJobCusEvent) {
      yield* _getFormAddJobCus(checkId(event.id ?? ''));
    } else if (event is InitFormAddSupportCusEvent) {
      yield* _getFormAddSupportCus(checkId(event.id ?? ''));
    } else if (event is InitFormAddAgencyEvent) {
      yield* _getFormAddAgency(checkId(event.id ?? ''));
    } else if (event is InitFormAddChanceEvent) {
      yield* _getFormAddChance(checkId(event.id ?? ''));
    } else if (event is InitFormAddContractEvent) {
      yield* _getFormAddContract(checkId(event.id ?? ''));
    } else if (event is InitFormAddJobEvent) {
      yield* _getFormAddJob(checkId(event.id ?? ''));
    } else if (event is InitFormAddSupportEvent) {
      yield* _getFormAddSupport(checkId(event.id ?? ''));
    } else if (event is InitFormAddJobOppEvent) {
      yield* _getFormAddJobOpp(checkId(event.id ?? ''));
    } else if (event is InitFormAddJobChanceEvent) {
      yield* _getFormAddJobChance(checkId(event.id ?? ''));
    } else if (event is InitFormAddSupportContractEvent) {
      yield* _getFormAddSupportContract(checkId(event.id ?? ''));
    } else if (event is InitFormAddJobContractEvent) {
      yield* _getFormAddJobContract(checkId(event.id ?? ''));
    } else if (event is InitFormAddProductEvent) {
      yield* _getFormAddProduct();
    } else if (event is InitFormAddProductCustomerEvent) {
      yield* _getFormAddProductCustomer();
    } else if (event is InitFormAddSignEvent) {
      yield* _getFormAddSign(id: event.id ?? '');
    } else if (event is InitFormAddSignEvent) {
      yield* _getFormAddSign(id: event.id ?? '');
    } else if (event is InitFormAddCVProductCustomerEvent) {
      yield* _getFormAddCVProductCustomer(id: event.id);
    } else if (event is InitFormAddHDProductCustomerEvent) {
      yield* _getFormAddHDProductCustomer(id: event.id);
    } else if (event is InitFormAddHTProductCustomerEvent) {
      yield* _getFormAddHTProductCustomer(id: event.id);
    } else if (event is InitFormAddCHProductCustomerEvent) {
      yield* _getFormAddCHProductCustomer(id: event.id);
    } else if (event is ResetDataEvent) {
      yield SuccessFormAddCustomerOrState(
        [],
      );
    }
  }

  String checkId(String id) {
    if (id != '' && id != '' && id != 'null') {
      return id;
    }
    return '';
  }

  void getAddressCustomer(String id) async {
    try {
      final result = await userRepository.getAddressCustomer(id: id);
      addressStream.add(result?.data ?? 'Chưa có');
    } catch (e) {
      throw e;
    }
  }

  Stream<FormAddState> _getFormAddCustomerOrganization() async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingFormAddCustomerOrState();
      final response = await userRepository.getAddCusOr();
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield SuccessFormAddCustomerOrState(response.data!);
      } else {
        LoadingApi().popLoading();
        yield ErrorFormAddCustomerOrState(response.msg ?? '');
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorFormAddCustomerOrState(getT(KeyT.an_error_occurred));
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<FormAddState> _getFormAddContactCustomer(String customer_id) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingFormAddCustomerOrState();
      final response = await userRepository.getFormAddContactCus(customer_id);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield SuccessFormAddCustomerOrState(response.data!);
      } else {
        LoadingApi().popLoading();
        yield ErrorFormAddCustomerOrState(response.msg ?? '');
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorFormAddCustomerOrState(getT(KeyT.an_error_occurred));
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<FormAddState> _getFormAddOppCus(String customer_id) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingFormAddCustomerOrState();
      final response = await userRepository.getFormAddOppCus(customer_id);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield SuccessFormAddCustomerOrState(response.data!);
      } else {
        LoadingApi().popLoading();
        yield ErrorFormAddCustomerOrState(response.msg ?? '');
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorFormAddCustomerOrState(getT(KeyT.an_error_occurred));
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<FormAddState> _getFormAddContractCus(String customer_id) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingFormAddCustomerOrState();
      final response = await userRepository.getFormAddContractCus(customer_id);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield SuccessFormAddCustomerOrState(response.data!);
      } else {
        LoadingApi().popLoading();
        yield ErrorFormAddCustomerOrState(response.msg ?? '');
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorFormAddCustomerOrState(getT(KeyT.an_error_occurred));
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<FormAddState> _getFormAddJobCus(String customer_id) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingFormAddCustomerOrState();
      final response = await userRepository.getFormAddJobCus(customer_id);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield SuccessFormAddCustomerOrState(response.data!);
      } else {
        LoadingApi().popLoading();
        yield ErrorFormAddCustomerOrState(response.msg ?? '');
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorFormAddCustomerOrState(getT(KeyT.an_error_occurred));
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<FormAddState> _getFormAddSupportCus(String customer_id) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingFormAddCustomerOrState();
      final response = await userRepository.getFormAddSupportCus(customer_id);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield SuccessFormAddCustomerOrState(response.data!);
      } else {
        LoadingApi().popLoading();
        yield ErrorFormAddCustomerOrState(response.msg ?? '');
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorFormAddCustomerOrState(getT(KeyT.an_error_occurred));
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<FormAddState> _getFormAddAgency(String id) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingFormAddCustomerOrState();
      final response = await userRepository.getFormAddAgency(id);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield SuccessFormAddCustomerOrState(response.data!);
      } else {
        LoadingApi().popLoading();
        yield ErrorFormAddContactCustomerState(response.msg ?? '');
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorFormAddContactCustomerState(getT(KeyT.an_error_occurred));
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<FormAddState> _getFormAddChance(String id) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingFormAddCustomerOrState();
      final response = await userRepository.getFormAddChance(id);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield SuccessFormAddCustomerOrState(response.data!);
      } else {
        LoadingApi().popLoading();
        yield ErrorFormAddCustomerOrState(response.msg ?? '');
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorFormAddCustomerOrState(getT(KeyT.an_error_occurred));
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<FormAddState> _getFormAddContract(String id) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingFormAddCustomerOrState();
      final response = await userRepository.getFormAddContract(id);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield SuccessFormAddCustomerOrState(response.data!);
      } else {
        yield ErrorFormAddCustomerOrState(response.msg ?? '');
        LoadingApi().popLoading();
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorFormAddCustomerOrState(getT(KeyT.an_error_occurred));
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<FormAddState> _getFormAddJob(String id) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingFormAddCustomerOrState();
      final response = await userRepository.getFormAddJob(id);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield SuccessFormAddCustomerOrState(response.data!);
      } else {
        LoadingApi().popLoading();
        yield ErrorFormAddCustomerOrState(response.msg ?? '');
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorFormAddCustomerOrState(getT(KeyT.an_error_occurred));
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<FormAddState> _getFormAddSupport(String id) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingFormAddCustomerOrState();
      final response = await userRepository.getFormAddSupport(id);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield SuccessFormAddCustomerOrState(response.data!);
      } else {
        LoadingApi().popLoading();
        yield ErrorFormAddCustomerOrState(response.msg ?? '');
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorFormAddCustomerOrState(getT(KeyT.an_error_occurred));
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<FormAddState> _getFormAddJobOpp(String id) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingFormAddCustomerOrState();
      final response = await userRepository.getFormAddJobOpp(id);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield SuccessFormAddCustomerOrState(response.data!);
      } else {
        LoadingApi().popLoading();
        yield ErrorFormAddCustomerOrState(response.msg ?? '');
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorFormAddCustomerOrState(getT(KeyT.an_error_occurred));
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<FormAddState> _getFormAddJobChance(String id) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingFormAddCustomerOrState();
      final response = await userRepository.getFormAddJobChance(id);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield SuccessFormAddCustomerOrState(response.data!);
      } else {
        LoadingApi().popLoading();
        yield ErrorFormAddCustomerOrState(response.msg ?? '');
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorFormAddCustomerOrState(getT(KeyT.an_error_occurred));
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<FormAddState> _getFormAddSupportContract(String id) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingFormAddCustomerOrState();
      final response = await userRepository.getFormAddSupportContract(id);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield SuccessFormAddCustomerOrState(response.data!);
      } else {
        LoadingApi().popLoading();
        yield ErrorFormAddCustomerOrState(response.msg ?? '');
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorFormAddCustomerOrState(getT(KeyT.an_error_occurred));
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<FormAddState> _getFormAddJobContract(String id) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingFormAddCustomerOrState();
      final response = await userRepository.getFormAddJobContract(id);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield SuccessFormAddCustomerOrState(response.data!);
      } else {
        LoadingApi().popLoading();
        yield ErrorFormAddCustomerOrState(response.msg ?? '');
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorFormAddCustomerOrState(getT(KeyT.an_error_occurred));
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<FormAddState> _getFormAddProduct() async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingFormAddCustomerOrState();
      final response = await userRepository.getFormAddProduct();
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield SuccessFormAddCustomerOrState(response.data ?? []);
      } else {
        LoadingApi().popLoading();
        yield ErrorFormAddCustomerOrState(response.msg ?? '');
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorFormAddCustomerOrState(getT(KeyT.an_error_occurred));
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<FormAddState> _getFormAddProductCustomer() async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingFormAddCustomerOrState();
      final response = await userRepository.getFormAddProductCustomer();
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield SuccessFormAddCustomerOrState(response.data ?? []);
      } else {
        LoadingApi().popLoading();
        yield ErrorFormAddCustomerOrState(response.msg ?? '');
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorFormAddCustomerOrState(getT(KeyT.an_error_occurred));
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<FormAddState> _getFormAddSign({
    required String id,
  }) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingFormAddCustomerOrState();
      final response = await userRepository.getFormAddSign(id: id);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield SuccessFormAddCustomerOrState(
          response.data ?? [],
          chuKyResponse: response.chu_ky,
          soTien: response.chuathanhtoan,
        );
      } else {
        LoadingApi().popLoading();
        yield ErrorFormAddCustomerOrState(response.msg ?? '');
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorFormAddCustomerOrState(getT(KeyT.an_error_occurred));
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<FormAddState> _getFormAddCHProductCustomer({
    required int id,
  }) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingFormAddCustomerOrState();
      final response = await userRepository.getFormCHProductCustomer(id: id);
      print(response);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield SuccessFormAddCustomerOrState(
          response.data ?? [],
        );
      } else {
        LoadingApi().popLoading();
        yield ErrorFormAddCustomerOrState(response.msg ?? '');
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorFormAddCustomerOrState(getT(KeyT.an_error_occurred));
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<FormAddState> _getFormAddCVProductCustomer({
    required int id,
  }) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingFormAddCustomerOrState();
      final response = await userRepository.getFormCVProductCustomer(id: id);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield SuccessFormAddCustomerOrState(
          response.data ?? [],
        );
      } else {
        LoadingApi().popLoading();
        yield ErrorFormAddCustomerOrState(response.msg ?? '');
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorFormAddCustomerOrState(getT(KeyT.an_error_occurred));
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<FormAddState> _getFormAddHDProductCustomer({
    required int id,
  }) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingFormAddCustomerOrState();
      final response = await userRepository.getFormHDProductCustomer(id: id);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield SuccessFormAddCustomerOrState(
          response.data ?? [],
        );
      } else {
        LoadingApi().popLoading();
        yield ErrorFormAddCustomerOrState(response.msg ?? '');
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorFormAddCustomerOrState(getT(KeyT.an_error_occurred));
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<FormAddState> _getFormAddHTProductCustomer({
    required int id,
  }) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingFormAddCustomerOrState();
      final response = await userRepository.getFormHTProductCustomer(id: id);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield SuccessFormAddCustomerOrState(
          response.data ?? [],
        );
      } else {
        LoadingApi().popLoading();
        yield ErrorFormAddCustomerOrState(response.msg ?? '');
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorFormAddCustomerOrState(getT(KeyT.an_error_occurred));
      throw e;
    }
    LoadingApi().popLoading();
  }

  static FormAddBloc of(BuildContext context) =>
      BlocProvider.of<FormAddBloc>(context);
}
