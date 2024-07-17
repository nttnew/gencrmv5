import 'dart:io';
import 'package:dartx/dartx.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/widgets/loading_api.dart';
import '../../api_resfull/user_repository.dart';
import '../../l10n/key_text.dart';
import '../../src/api/rest_client.dart';
import '../../src/base.dart';

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
    } else if (event is AddCustomerEvent) {
      yield* _addCustomer(event.data, event.files);
    } else if (event is AddContactCustomerEvent) {
      yield* _addContactCus(event.data, event.files, event.isEdit);
    } else if (event is AddOpportunityEvent) {
      yield* _addOpportunity(event.data, event.files, event.isEdit);
    } else if (event is AddContractEvent) {
      yield* _addContract(event.data, event.files, event.isEdit);
    } else if (event is AddJobEvent) {
      yield* _addJob(event.data, event.files);
    } else if (event is AddSupportEvent) {
      yield* _addSupport(event.data, event.files, event.isEdit);
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
      yield* _signature(event.data, event.type);
    } else if (event is QuickContractSaveEvent) {
      yield* _addQuickContract(event.data, event.files);
    } else if (event is AddPayment) {
      yield* _addPayment(event.data);
    } else if (event is EditPayment) {
      yield* _editPayment(event.data);
    }
  }

  Stream<AddDataState> _addCustomerOrganization(
    Map<String, dynamic> data,
    List<File>? files,
  ) async* {
    Loading().showLoading();
    yield LoadingAddData();
    try {
      final response = await userRepository.addOrganizationCustomer(data: data);
      if (isSuccess(response.code)) {
        if (files != null && files.length > 0) {
          final responseUpload = await userRepository.uploadMultiFileBase(
              id: response.data?.id.toString() ?? '',
              files: files,
              module: getURLModule(Module.KHACH_HANG));
          if (isSuccess(responseUpload.code)) {
            Loading().popLoading();
            yield SuccessAddData(
                result: ['${response.id}', '${response.name}']);
          } else {
            Loading().popLoading();
            yield ErrorAddData(responseUpload.msg ?? '');
          }
        } else {
          Loading().popLoading();
          yield SuccessAddData(result: ['${response.id}', '${response.name}']);
        }
      } else {
        Loading().popLoading();
        yield ErrorAddData(response.msg ?? '');
      }
    } catch (e) {
      Loading().popLoading();
      yield ErrorAddData(getT(KeyT.an_error_occurred));
      throw e;
    }
    Loading().popLoading();
  }

  Stream<AddDataState> _addCustomer(
    Map<String, dynamic> data,
    List<File>? files,
  ) async* {
    Loading().showLoading();
    yield LoadingAddData();
    try {
      final response = await userRepository.addIndividualCustomer(data: data);
      if (isSuccess(response.code)) {
        if (files != null && files.length > 0) {
          final responseUpload = await userRepository.uploadMultiFileBase(
              id: response.data?.id.toString() ?? '',
              files: files,
              module: getURLModule(Module.KHACH_HANG));
          if (isSuccess(responseUpload.code)) {
            Loading().popLoading();
            yield SuccessAddData(
                result: ['${response.id}', '${response.name}']);
          } else {
            Loading().popLoading();
            yield ErrorAddData(responseUpload.msg ?? '');
          }
        } else {
          Loading().popLoading();
          yield SuccessAddData(result: ['${response.id}', '${response.name}']);
        }
      } else {
        Loading().popLoading();
        yield ErrorAddData(response.msg ?? '');
      }
    } catch (e) {
      Loading().popLoading();
      yield ErrorAddData(getT(KeyT.an_error_occurred));
      throw e;
    }
    Loading().popLoading();
  }

  Stream<AddDataState> _editCustomer(
    Map<String, dynamic> data,
    List<File>? files,
  ) async* {
    Loading().showLoading();
    try {
      yield LoadingAddData();
      final response = await userRepository.editCustomer(data: data);
      if (isSuccess(response.code)) {
        if (files != null && files.length > 0) {
          final responseUpload = await userRepository.uploadMultiFileBase(
            id: response.idkh.toString(),
            files: files,
            module: getURLModule(Module.KHACH_HANG),
          );
          if (isSuccess(responseUpload.code)) {
            yield SuccessAddData(isEdit: true);
          } else {
            yield ErrorAddData(responseUpload.msg ?? '');
          }
        } else {
          yield SuccessAddData(isEdit: true);
        }
      } else {
        yield ErrorAddData(response.msg ?? '');
      }
    } catch (e) {
      Loading().popLoading();
      yield ErrorAddData(getT(KeyT.an_error_occurred));
      throw e;
    }
    Loading().popLoading();
  }

  Stream<AddDataState> _addContactCus(
    Map<String, dynamic> data,
    List<File>? files,
    bool isEdit,
  ) async* {
    Loading().showLoading();
    try {
      yield LoadingAddData();
      final response = await userRepository.addContactCus(data: data);
      if (isSuccess(response.code)) {
        if (files != null && files.length > 0) {
          final responseUpload = await userRepository.uploadMultiFileBase(
              id: response.data?.id.toString() ?? '',
              files: files,
              module: getURLModule(Module.DAU_MOI));
          if (isSuccess(responseUpload.code)) {
            Loading().popLoading();
            yield SuccessAddData(isEdit: isEdit);
          } else {
            Loading().popLoading();
            yield ErrorAddData(responseUpload.msg ?? '');
          }
        } else {
          Loading().popLoading();
          yield SuccessAddData(isEdit: isEdit);
        }
      } else {
        Loading().popLoading();
        yield ErrorAddData(response.msg ?? '');
      }
    } catch (e) {
      Loading().popLoading();
      yield ErrorAddData(getT(KeyT.an_error_occurred));
      throw e;
    }
    Loading().popLoading();
  }

  Stream<AddDataState> _addOpportunity(
    Map<String, dynamic> data,
    List<File>? files,
    bool isEdit,
  ) async* {
    Loading().showLoading();
    try {
      yield LoadingAddData();
      final response = await userRepository.addOpportunity(data: data);
      if (isSuccess(response.code)) {
        if (files != null && files.length > 0) {
          final responseUpload = await userRepository.uploadMultiFileBase(
              id: response.data?.id.toString() ?? '',
              files: files,
              module: getURLModule(Module.CO_HOI_BH));
          if (isSuccess(responseUpload.code)) {
            Loading().popLoading();
            yield SuccessAddData(isEdit: isEdit);
          } else {
            Loading().popLoading();
            yield ErrorAddData(responseUpload.msg ?? '');
          }
        } else {
          Loading().popLoading();
          yield SuccessAddData(isEdit: isEdit);
        }
      } else {
        Loading().popLoading();
        yield ErrorAddData(response.msg ?? '');
      }
    } catch (e) {
      Loading().popLoading();
      yield ErrorAddData(getT(KeyT.an_error_occurred));
      throw e;
    }
    Loading().popLoading();
  }

  Stream<AddDataState> _addContract(
    Map<String, dynamic> data,
    List<File>? files,
    bool isEdit,
  ) async* {
    Loading().showLoading();
    try {
      yield LoadingAddData();
      final response = await userRepository.addContract(data: data);
      if (isSuccess(response.code)) {
        if (files != null && files.length > 0) {
          final responseUpload = await userRepository.uploadMultiFileBase(
              id: response.data?.id.toString() ?? '',
              files: files,
              module: getURLModule(Module.HOP_DONG));
          if (isSuccess(responseUpload.code)) {
            Loading().popLoading();
            yield SuccessAddData(isEdit: isEdit);
          } else {
            Loading().popLoading();
            yield ErrorAddData(responseUpload.msg ?? '');
          }
        } else {
          Loading().popLoading();
          yield SuccessAddData(isEdit: isEdit);
        }
      } else {
        Loading().popLoading();
        yield ErrorAddData(response.msg ?? '');
      }
    } catch (e) {
      Loading().popLoading();
      yield ErrorAddData(getT(KeyT.an_error_occurred));
      throw e;
    }
    Loading().popLoading();
  }

  Stream<AddDataState> _addJob(
    Map<String, dynamic> data,
    List<File>? files,
  ) async* {
    Loading().showLoading();
    try {
      yield LoadingAddData();
      final response = await userRepository.addJob(data: data);
      if (isSuccess(response.code)) {
        if (files != null && files.length > 0) {
          final responseUpload = await userRepository.uploadMultiFileBase(
            id: response.data?.id.toString() ?? '',
            files: files,
            module: getURLModule(Module.CONG_VIEC),
          );
          if (isSuccess(responseUpload.code)) {
            Loading().popLoading();
            yield SuccessAddData();
          } else {
            Loading().popLoading();
            yield ErrorAddData(responseUpload.msg ?? '');
          }
        } else {
          Loading().popLoading();
          yield SuccessAddData();
        }
      } else {
        Loading().popLoading();
        yield ErrorAddData(response.msg ?? '');
      }
    } catch (e) {
      Loading().popLoading();
      yield ErrorAddData(getT(KeyT.an_error_occurred));
      throw e;
    }
    Loading().popLoading();
  }

  Stream<AddDataState> _addSupport(
    Map<String, dynamic> data,
    List<File>? files,
    bool isEdit,
  ) async* {
    Loading().showLoading();
    try {
      yield LoadingAddData();
      final response = await userRepository.addSupport(data: data);
      if (isSuccess(response.code)) {
        if (files != null && files.length > 0) {
          final responseUpload = await userRepository.uploadMultiFileBase(
              id: response.data?.id.toString() ?? '',
              files: files,
              module: getURLModule(Module.HO_TRO));
          if (isSuccess(responseUpload.code)) {
            Loading().popLoading();
            yield SuccessAddData(isEdit: isEdit);
          } else {
            Loading().popLoading();
            yield ErrorAddData(responseUpload.msg ?? '');
          }
        } else {
          Loading().popLoading();
          yield SuccessAddData(isEdit: isEdit);
        }
      } else {
        Loading().popLoading();
        yield ErrorAddData(response.msg ?? '');
      }
    } catch (e) {
      Loading().popLoading();
      yield ErrorAddData(getT(KeyT.an_error_occurred));
      throw e;
    }
    Loading().popLoading();
  }

  Stream<AddDataState> _editJob(
    Map<String, dynamic> data,
    List<File>? files,
  ) async* {
    Loading().showLoading();
    try {
      yield LoadingAddData();
      final response = await userRepository.editJob(data: data);
      if (isSuccess(response.code)) {
        if (files != null && files.length > 0) {
          final responseUpload = await userRepository.uploadMultiFileBase(
              id: response.data?.id.toString() ?? '',
              files: files,
              module: getURLModule(Module.CONG_VIEC));
          if (isSuccess(responseUpload.code)) {
            Loading().popLoading();
            yield SuccessAddData(isEdit: true);
          } else {
            Loading().popLoading();
            yield ErrorAddData(responseUpload.msg ?? '');
          }
        } else {
          Loading().popLoading();
          yield SuccessAddData(isEdit: true);
        }
      } else {
        Loading().popLoading();
        yield ErrorAddData(response.msg ?? '');
      }
    } catch (e) {
      Loading().popLoading();
      yield ErrorAddData(getT(KeyT.an_error_occurred));
      throw e;
    }
    Loading().popLoading();
  }

  Stream<AddDataState> _addProduct(
    FormDataCustom data,
    List<File>? files,
  ) async* {
    Loading().showLoading();
    try {
      yield LoadingAddData();
      final response = await userRepository.addProduct(
        data: data,
      );
      if (isSuccess(response.code)) {
        if (files != null && files.length > 0) {
          final responseUpload = await userRepository.uploadMultiFileBase(
              id: response.id.toString(),
              files: files,
              module: getURLModule(Module.PRODUCT));
          if (isSuccess(responseUpload.code)) {
            Loading().popLoading();
            yield SuccessAddData();
          } else {
            Loading().popLoading();
            yield ErrorAddData(responseUpload.msg ?? '');
          }
        } else {
          Loading().popLoading();
          yield SuccessAddData();
        }
      } else {
        Loading().popLoading();
        yield ErrorAddData(response.msg ?? '');
      }
    } catch (e) {
      Loading().popLoading();
      yield ErrorAddData(getT(KeyT.an_error_occurred));
      throw e;
    }
    Loading().popLoading();
  }

  Stream<AddDataState> _addProductCustomer(
    Map<String, dynamic> data,
    List<File>? files,
  ) async* {
    Loading().showLoading();
    try {
      yield LoadingAddData();
      final response = await userRepository.saveAddProductCustomer(data: data);
      if (isSuccess(response.code)) {
        if (files != null && files.length > 0) {
          final responseUpload = await userRepository.uploadMultiFileBase(
            id: response.id.toString(),
            files: files,
            module: getURLModule(Module.SAN_PHAM_KH),
          );
          if (isSuccess(response.code)) {
            Loading().popLoading();
            yield SuccessAddData(
              dataSPKH: response.data,
              idKH: response.id.toString(),
            );
          } else {
            Loading().popLoading();
            yield ErrorAddData(responseUpload.msg ?? '');
          }
        } else {
          Loading().popLoading();
          yield SuccessAddData(
            dataSPKH: response.data,
            idKH: response.id.toString(),
          );
        }
      } else {
        Loading().popLoading();
        yield ErrorAddData(response.msg ?? '');
      }
    } catch (e) {
      Loading().popLoading();
      yield ErrorAddData(getT(KeyT.an_error_occurred));
      throw e;
    }
    Loading().popLoading();
  }

  Stream<AddDataState> _editProduct(
      FormDataCustom data, List<File>? files, int id) async* {
    Loading().showLoading();
    try {
      yield LoadingAddData();
      final response = await userRepository.editProduct(data: data, id: id);
      if (isSuccess(response.code)) {
        if (files != null && files.length > 0) {
          final responseUpload = await userRepository.uploadMultiFileBase(
              id: response.data?.id.toString() ?? '',
              files: files,
              module: getURLModule(Module.PRODUCT));
          if (isSuccess(responseUpload.code)) {
            Loading().popLoading();
            yield SuccessAddData(isEdit: true);
          } else {
            Loading().popLoading();
            yield ErrorAddData(responseUpload.msg ?? '');
          }
        } else {
          Loading().popLoading();
          yield SuccessAddData(isEdit: true);
        }
      } else {
        Loading().popLoading();
        yield ErrorAddData(response.msg ?? '');
      }
    } catch (e) {
      Loading().popLoading();
      yield ErrorAddData(getT(KeyT.an_error_occurred));
      throw e;
    }
    Loading().popLoading();
  }

  Stream<AddDataState> _editProductCustomer(
    Map<String, dynamic> data,
    List<File>? files,
  ) async* {
    Loading().showLoading();
    try {
      yield LoadingAddData();
      final response = await userRepository.saveEditProductCustomer(data: data);
      if (isSuccess(response.code)) {
        if (files != null && files.length > 0) {
          final responseUpload = await userRepository.uploadMultiFileBase(
              id: response.data?.id.toString() ?? '',
              files: files,
              module: getURLModule(Module.SAN_PHAM_KH));
          if (isSuccess(responseUpload.code)) {
            Loading().popLoading();
            yield SuccessAddData(isEdit: true);
          } else {
            Loading().popLoading();
            yield ErrorAddData(responseUpload.msg ?? '');
          }
        } else {
          Loading().popLoading();
          yield SuccessAddData(isEdit: true);
        }
      } else {
        Loading().popLoading();
        yield ErrorAddData(response.msg ?? '');
      }
    } catch (e) {
      Loading().popLoading();
      yield ErrorAddData(getT(KeyT.an_error_occurred));
      throw e;
    }
    Loading().popLoading();
  }

  Stream<AddDataState> _signature(
    Map<String, dynamic> data,
    String type,
  ) async* {
    Loading().showLoading();
    try {
      yield LoadingAddData();
      final response =
          await userRepository.saveSignature(data: data, type: type);
      if (isSuccess(response.code)) {
        Loading().popLoading();
        yield SuccessAddData();
      } else {
        Loading().popLoading();
        yield ErrorAddData(response.msg ?? '');
      }
    } catch (e) {
      Loading().popLoading();
      yield ErrorAddData(getT(KeyT.an_error_occurred));
      throw e;
    }
    Loading().popLoading();
  }

  Stream<AddDataState> _addQuickContract(
    Map<String, dynamic> data,
    List<File>? files,
  ) async* {
    Loading().showLoading();
    try {
      yield LoadingAddData();
      final response = await userRepository.saveServiceVoucher(data: data);
      final statusCode =
          (response as Map<String, dynamic>).getOrElse('code', () => -1);
      final msg = response.getOrElse('msg', () => -1);
      final dataR = response.getOrElse('data', () => -1);

      if (isSuccess(statusCode)) {
        if (files != null && files.length > 0) {
          final responseUpload = await userRepository.uploadMultiFileBase(
              id: dataR['recordId'].toString(),
              files: files,
              module: getURLModule(Module.HOP_DONG));
          if (isSuccess(responseUpload.code)) {
            Loading().popLoading();
            yield SuccessAddData();
          } else {
            Loading().popLoading();
            yield ErrorAddData(responseUpload.msg ?? '');
          }
        } else {
          Loading().popLoading();
          yield SuccessAddData();
        }
      } else {
        Loading().popLoading();
        yield ErrorAddData(msg);
      }
    } catch (e) {
      Loading().popLoading();
      yield ErrorAddData(getT(KeyT.an_error_occurred));
      throw e;
    }
    Loading().popLoading();
  }

  Stream<AddDataState> _addPayment(
    Map<String, dynamic> data,
  ) async* {
    Loading().showLoading();
    try {
      yield LoadingAddData();
      final response = await userRepository.addPayment(map: data);
      final statusCode = response.code;
      final msg = response.msg ?? '';

      if (isSuccess(statusCode)) {
        Loading().popLoading();
        yield SuccessAddData();
      } else {
        Loading().popLoading();
        yield ErrorAddData(msg);
      }
    } catch (e) {
      Loading().popLoading();
      yield ErrorAddData(getT(KeyT.an_error_occurred));
      throw e;
    }
    Loading().popLoading();
  }

  Stream<AddDataState> _editPayment(
    Map<String, dynamic> data,
  ) async* {
    Loading().showLoading();
    try {
      yield LoadingAddData();
      final response = await userRepository.updatePayment(map: data);
      final statusCode = response.code;
      final msg = response.msg ?? '';

      if (isSuccess(statusCode)) {
        Loading().popLoading();
        yield SuccessAddData();
      } else {
        Loading().popLoading();
        yield ErrorAddData(msg);
      }
    } catch (e) {
      Loading().popLoading();
      yield ErrorAddData(getT(KeyT.an_error_occurred));
      throw e;
    }
    Loading().popLoading();
  }

  static AddDataBloc of(BuildContext context) =>
      BlocProvider.of<AddDataBloc>(context);
}
