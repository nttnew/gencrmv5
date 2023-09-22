import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../api_resfull/user_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import '../../src/app_const.dart';
import '../../src/base.dart';
import '../../src/models/model_generator/customer.dart';

part 'contact_by_customer_event.dart';
part 'contact_by_customer_state.dart';

class ContactByCustomerBloc
    extends Bloc<ContactByCustomerEvent, ContactByCustomerState> {
  final UserRepository userRepository;
  List<CustomerData>? listCus;
  BehaviorSubject<List<List<dynamic>>> listXe = BehaviorSubject.seeded([]);
  BehaviorSubject<String> chiTietXe = BehaviorSubject.seeded('');
  Map<String, dynamic> dataCarNew = {};

  ContactByCustomerBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetContactByCustomer());

  @override
  Stream<ContactByCustomerState> mapEventToState(
      ContactByCustomerEvent event) async* {
    if (event is InitGetContactByCustomerrEvent) {
      await getXe(event.id, isAddCarNew: event.isAddNewCar);
      yield* _getContactByCustomer(customer_id: event.id);
    }
    if (event is InitGetCustomerContractEvent) {
      yield* _getCustomerContract(
          page: event.page, search: event.search, success: event.success);
    }
  }

  bool checkXeKhach(String id, List<List<dynamic>>? list) {
    if (list != null) {
      for (final value in listXe.value) {
        if (value[0] == id) {
          return false;
        }
      }
    }
    return true;
  }

  void getCar(String id) {
    if (id.trim() == '') {
      chiTietXe.add('');
    } else {
      userRepository.postInfoCar(id).then((value) {
        chiTietXe.add(value.chiTietXe ?? '');
      });
    }
  }

  Future<void> getXe(String id, {isAddCarNew = false}) async {
    final res = await userRepository.getXe(id: id);
    if ((res.code == BASE_URL.SUCCESS) || (res.code == BASE_URL.SUCCESS_200)) {
      listXe.add(res.data?.products ?? []);
    }
    if (isAddCarNew)
      listXe.add([
        ...[
          [ADD_NEW_CAR, ADD_NEW_CAR, '', '']
        ],
        ...listXe.value
      ]);
  }

  Stream<ContactByCustomerState> _getContactByCustomer(
      {required String customer_id}) async* {
    try {
      yield LoadingContactByCustomerState();
      final response = await userRepository.getContactByCustomer(customer_id);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield UpdateGetContacBytCustomerState(response.data!);
      } else if (response.code == BASE_URL.SUCCESS_999) {
        loginSessionExpired();
      } else
        yield ErrorGetContactByCustomerState(response.msg ?? '');
    } catch (e) {
      yield ErrorGetContactByCustomerState(
          AppLocalizations.of(Get.context!)?.an_error_occurred ?? '');
      throw e;
    }
  }

  Stream<ContactByCustomerState> _getCustomerContract(
      {required String page,
      required String search,
      required Function success}) async* {
    try {
      yield LoadingContactByCustomerState();
      final response = await userRepository.getCustomerContract(page, search);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        success(response);
      } else if (response.code == BASE_URL.SUCCESS_999) {
        loginSessionExpired();
      } else
        yield ErrorGetContactByCustomerState(response.msg ?? '');
    } catch (e) {
      yield ErrorGetContactByCustomerState(
          AppLocalizations.of(Get.context!)?.an_error_occurred ?? '');
      throw e;
    }
  }

  static ContactByCustomerBloc of(BuildContext context) =>
      BlocProvider.of<ContactByCustomerBloc>(context);
}
