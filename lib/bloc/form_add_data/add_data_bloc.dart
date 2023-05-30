import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/widgets/loading_api.dart';

import '../../api_resfull/user_repository.dart';
import '../../src/base.dart';
import '../../src/messages.dart';

part 'add_data_event.dart';
part 'add_data_state.dart';

class AddDataBloc extends Bloc<AddDataEvent, AddDataState> {
  final UserRepository userRepository;

  AddDataBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitAddDataState());

  @override
  Stream<AddDataState> mapEventToState(AddDataEvent event) async* {
    if (event is AddCustomerOrEvent) {
      yield* _addCustomerOrganization(event.data, event.files);
    } else if (event is EditCustomerEvent) {
      yield* _editCustomer(event.data, event.files);
    } else if (event is AddContactCustomerEvent) {
      yield* _addContactCus(event.data, event.files);
    } else if (event is AddOpportunityEvent) {
      yield* _addOpportunity(event.data, event.files);
    } else if (event is AddContractEvent) {
      yield* _addContract(event.data, event.files);
    } else if (event is AddJobEvent) {
      yield* _addJob(event.data, event.files);
    } else if (event is AddSupportEvent) {
      yield* _addSupport(event.data, event.files);
    } else if (event is EditJobEvent) {
      yield* _editJob(event.data, event.files);
    } else if (event is AddProductEvent) {
      yield* _addProduct(event.data, event.files);
    } else if (event is EditProductEvent) {
      yield* _editProduct(event.data, event.files, event.id);
    } else if (event is AddProductCustomerEvent) {
      yield* _addProductCustomer(event.data, event.files);
    } else if (event is EditProductCustomerEvent) {
      yield* _editProductCustomer(event.data, event.files);
    } else if (event is SignEvent) {
      yield* _signature(event.data);
    }
  }

  Stream<AddDataState> _addCustomerOrganization(
      Map<String, dynamic> data, List<File>? files) async* {
    LoadingApi().pushLoading();
    yield LoadingAddCustomerOrState();
    try {
      final response = await userRepository.addOrganizationCustomer(data: data);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        if (files != null) {
          final responseUpload = await userRepository.uploadMultiFileBase(
              id: response.data!.id.toString(),
              files: files,
              module: getURLModule(Module.KHACH_HANG));
          if ((responseUpload.code == BASE_URL.SUCCESS) ||
              (responseUpload.code == BASE_URL.SUCCESS_200)) {
            LoadingApi().popLoading();
            yield SuccessAddCustomerOrState();
          } else {
            LoadingApi().popLoading();
            yield ErrorAddCustomerOrState(responseUpload.msg ?? '');
          }
        } else {
          LoadingApi().popLoading();
          yield SuccessAddCustomerOrState();
        }
      } else {
        LoadingApi().popLoading();
        yield ErrorAddCustomerOrState(response.msg ?? '');
      }
    } catch (e) {
      yield ErrorAddCustomerOrState(MESSAGES.CONNECT_ERROR);
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<AddDataState> _editCustomer(
      Map<String, dynamic> data, List<File>? files) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingEditCustomerState();
      final response = await userRepository.editCustomer(data: data);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        if (files != null) {
          final responseUpload = await userRepository.uploadMultiFileBase(
              id: response.idkh.toString(),
              files: files,
              module: getURLModule(Module.KHACH_HANG));
          if ((responseUpload.code == BASE_URL.SUCCESS) ||
              (responseUpload.code == BASE_URL.SUCCESS_200)) {
            LoadingApi().popLoading();
            yield SuccessEditCustomerState();
          } else {
            LoadingApi().popLoading();
            yield ErrorEditCustomerState(responseUpload.msg ?? '');
          }
        } else {
          LoadingApi().popLoading();
          yield SuccessEditCustomerState();
        }
      } else {
        yield ErrorEditCustomerState(response.msg ?? '');
        LoadingApi().popLoading();
      }
    } catch (e) {
      yield ErrorEditCustomerState(MESSAGES.CONNECT_ERROR);
      LoadingApi().popLoading();
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<AddDataState> _addContactCus(
      Map<String, dynamic> data, List<File>? files) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingAddContactCustomerState();
      final response = await userRepository.addContactCus(data: data);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        if (files != null) {
          final responseUpload = await userRepository.uploadMultiFileBase(
              id: response.data?.id.toString() ?? '',
              files: files,
              module: getURLModule(Module.DAU_MOI));
          if ((responseUpload.code == BASE_URL.SUCCESS) ||
              (responseUpload.code == BASE_URL.SUCCESS_200)) {
            LoadingApi().popLoading();
            yield SuccessAddContactCustomerState();
          } else {
            LoadingApi().popLoading();
            yield ErrorAddContactCustomerState(responseUpload.msg ?? '');
          }
        } else {
          LoadingApi().popLoading();
          yield SuccessAddContactCustomerState();
        }
      } else {
        LoadingApi().popLoading();
        yield ErrorAddContactCustomerState(response.msg ?? '');
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorAddContactCustomerState(MESSAGES.CONNECT_ERROR);
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<AddDataState> _addOpportunity(
      Map<String, dynamic> data, List<File>? files) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingAddContactCustomerState();
      final response = await userRepository.addOpportunity(data: data);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        if (files != null) {
          final responseUpload = await userRepository.uploadMultiFileBase(
              id: response.data!.id.toString(),
              files: files,
              module: getURLModule(Module.CO_HOI_BH));
          if ((responseUpload.code == BASE_URL.SUCCESS) ||
              (responseUpload.code == BASE_URL.SUCCESS_200)) {
            LoadingApi().popLoading();
            yield SuccessAddContactCustomerState();
          } else {
            LoadingApi().popLoading();
            yield ErrorAddContactCustomerState(responseUpload.msg ?? '');
          }
        } else {
          LoadingApi().popLoading();
          yield SuccessAddContactCustomerState();
        }
      } else {
        LoadingApi().popLoading();
        yield ErrorAddContactCustomerState(response.msg ?? '');
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorAddContactCustomerState(MESSAGES.CONNECT_ERROR);
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<AddDataState> _addContract(
      Map<String, dynamic> data, List<File>? files) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingAddContactCustomerState();
      final response = await userRepository.addContract(data: data);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        if (files != null) {
          final responseUpload = await userRepository.uploadMultiFileBase(
              id: response.data!.id.toString(),
              files: files,
              module: getURLModule(Module.HOP_DONG));
          if ((responseUpload.code == BASE_URL.SUCCESS) ||
              (responseUpload.code == BASE_URL.SUCCESS_200)) {
            LoadingApi().popLoading();
            yield SuccessAddContactCustomerState();
          } else {
            LoadingApi().popLoading();
            yield ErrorAddContactCustomerState(responseUpload.msg ?? '');
          }
        } else {
          LoadingApi().popLoading();
          yield SuccessAddContactCustomerState();
        }
      } else {
        LoadingApi().popLoading();
        yield ErrorAddContactCustomerState(response.msg ?? '');
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorAddContactCustomerState(MESSAGES.CONNECT_ERROR);
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<AddDataState> _addJob(
      Map<String, dynamic> data, List<File>? files) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingAddContactCustomerState();
      final response = await userRepository.addJob(data: data);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        if (files != null) {
          final responseUpload = await userRepository.uploadMultiFileBase(
            id: response.data!.id.toString(),
            files: files,
            module: getURLModule(Module.CONG_VIEC),
          );
          if ((responseUpload.code == BASE_URL.SUCCESS) ||
              (responseUpload.code == BASE_URL.SUCCESS_200)) {
            LoadingApi().popLoading();
            yield SuccessAddContactCustomerState();
          } else {
            LoadingApi().popLoading();
            yield ErrorAddContactCustomerState(responseUpload.msg ?? '');
          }
        } else {
          LoadingApi().popLoading();
          yield SuccessAddContactCustomerState();
        }
      } else {
        LoadingApi().popLoading();
        yield ErrorAddContactCustomerState(response.msg ?? '');
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorAddContactCustomerState(MESSAGES.CONNECT_ERROR);
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<AddDataState> _addSupport(
      Map<String, dynamic> data, List<File>? files) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingAddContactCustomerState();
      final response = await userRepository.addSupport(data: data);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        if (files != null) {
          final responseUpload = await userRepository.uploadMultiFileBase(
              id: response.data!.id.toString(),
              files: files,
              module: getURLModule(Module.HO_TRO));
          if ((responseUpload.code == BASE_URL.SUCCESS) ||
              (responseUpload.code == BASE_URL.SUCCESS_200)) {
            LoadingApi().popLoading();
            yield SuccessAddContactCustomerState();
          } else {
            LoadingApi().popLoading();
            yield ErrorAddContactCustomerState(responseUpload.msg ?? '');
          }
        } else {
          LoadingApi().popLoading();
          yield SuccessAddContactCustomerState();
        }
      } else {
        LoadingApi().popLoading();
        yield ErrorAddContactCustomerState(response.msg ?? '');
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorAddContactCustomerState(MESSAGES.CONNECT_ERROR);
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<AddDataState> _editJob(
      Map<String, dynamic> data, List<File>? files) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingAddContactCustomerState();
      final response = await userRepository.editJob(data: data);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        if (files != null) {
          final responseUpload = await userRepository.uploadMultiFileBase(
              id: response.data!.id.toString(),
              files: files,
              module: getURLModule(Module.CONG_VIEC));
          if ((responseUpload.code == BASE_URL.SUCCESS) ||
              (responseUpload.code == BASE_URL.SUCCESS_200)) {
            LoadingApi().popLoading();
            yield SuccessAddContactCustomerState();
          } else {
            LoadingApi().popLoading();
            yield ErrorAddContactCustomerState(responseUpload.msg ?? '');
          }
        } else {
          LoadingApi().popLoading();
          yield SuccessAddContactCustomerState();
        }
      } else {
        LoadingApi().popLoading();
        yield ErrorAddContactCustomerState(response.msg ?? '');
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorAddContactCustomerState(MESSAGES.CONNECT_ERROR);
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<AddDataState> _addProduct(
      Map<String, dynamic> data, List<File>? files) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingAddContactCustomerState();
      final response = await userRepository.addProduct(data: data);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        if (files != null) {
          final responseUpload = await userRepository.uploadMultiFileBase(
              id: response.id.toString(),
              files: files,
              module: getURLModule(Module.PRODUCT));
          if ((responseUpload.code == BASE_URL.SUCCESS) ||
              (responseUpload.code == BASE_URL.SUCCESS_200)) {
            LoadingApi().popLoading();
            yield SuccessAddContactCustomerState();
          } else {
            LoadingApi().popLoading();
            yield ErrorAddContactCustomerState(responseUpload.msg ?? '');
          }
        } else {
          LoadingApi().popLoading();
          yield SuccessAddContactCustomerState();
        }
      } else {
        LoadingApi().popLoading();
        yield ErrorAddContactCustomerState(response.msg ?? '');
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorAddContactCustomerState(MESSAGES.CONNECT_ERROR);
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<AddDataState> _addProductCustomer(
      Map<String, dynamic> data, List<File>? files) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingAddContactCustomerState();
      final response = await userRepository.saveAddProductCustomer(data: data);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        if (files != null) {
          final responseUpload = await userRepository.uploadMultiFileBase(
              id: response.id.toString(),
              files: files,
              module: getURLModule(Module.SAN_PHAM_KH));
          if ((responseUpload.code == BASE_URL.SUCCESS) ||
              (responseUpload.code == BASE_URL.SUCCESS_200)) {
            LoadingApi().popLoading();
            yield SuccessAddContactCustomerState();
          } else {
            LoadingApi().popLoading();
            yield ErrorAddContactCustomerState(responseUpload.msg ?? '');
          }
        } else {
          LoadingApi().popLoading();
          yield SuccessAddContactCustomerState();
        }
      } else {
        LoadingApi().popLoading();
        yield ErrorAddContactCustomerState(response.msg ?? '');
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorAddContactCustomerState(MESSAGES.CONNECT_ERROR);
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<AddDataState> _editProduct(
      Map<String, dynamic> data, List<File>? files, int id) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingAddContactCustomerState();
      final response = await userRepository.editProduct(data: data, id: id);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        if (files != null) {
          final responseUpload = await userRepository.uploadMultiFileBase(
              id: response.data?.id.toString() ?? '',
              files: files,
              module: getURLModule(Module.PRODUCT));
          if ((responseUpload.code == BASE_URL.SUCCESS) ||
              (responseUpload.code == BASE_URL.SUCCESS_200)) {
            LoadingApi().popLoading();
            yield SuccessAddContactCustomerState();
          } else {
            LoadingApi().popLoading();
            yield ErrorAddContactCustomerState(responseUpload.msg ?? '');
          }
        } else {
          LoadingApi().popLoading();
          yield SuccessAddContactCustomerState();
        }
      } else {
        LoadingApi().popLoading();
        yield ErrorAddContactCustomerState(response.msg ?? '');
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorAddContactCustomerState(MESSAGES.CONNECT_ERROR);
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<AddDataState> _editProductCustomer(
      Map<String, dynamic> data, List<File>? files) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingAddContactCustomerState();
      final response = await userRepository.saveEditProductCustomer(data: data);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        if (files != null) {
          final responseUpload = await userRepository.uploadMultiFileBase(
              id: response.data?.id.toString() ?? '',
              files: files,
              module: getURLModule(Module.SAN_PHAM_KH));
          if ((responseUpload.code == BASE_URL.SUCCESS) ||
              (responseUpload.code == BASE_URL.SUCCESS_200)) {
            LoadingApi().popLoading();
            yield SuccessAddContactCustomerState();
          } else {
            LoadingApi().popLoading();
            yield ErrorAddContactCustomerState(responseUpload.msg ?? '');
          }
        } else {
          LoadingApi().popLoading();
          yield SuccessAddContactCustomerState();
        }
      } else {
        LoadingApi().popLoading();
        yield ErrorAddContactCustomerState(response.msg ?? '');
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorAddContactCustomerState(MESSAGES.CONNECT_ERROR);
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<AddDataState> _signature(Map<String, dynamic> data) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingAddContactCustomerState();
      final response = await userRepository.saveSignature(data: data);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        LoadingApi().popLoading();
        yield SuccessAddContactCustomerState();
      } else {
        LoadingApi().popLoading();
        yield ErrorAddContactCustomerState(response.msg ?? '');
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorAddContactCustomerState(MESSAGES.CONNECT_ERROR);
      throw e;
    }
    LoadingApi().popLoading();
  }

  static AddDataBloc of(BuildContext context) =>
      BlocProvider.of<AddDataBloc>(context);
}
