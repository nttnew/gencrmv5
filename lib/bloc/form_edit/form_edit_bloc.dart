// import 'package:equatable/equatable.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:gen_crm/widgets/loading_api.dart';
// import '../../api_resfull/user_repository.dart';
// import '../../l10n/key_text.dart';
// import '../../src/base.dart';
// import '../../src/models/model_generator/add_customer.dart';
//
// part 'form_edit_event.dart';
// part 'form_edit_state.dart';
//
// class FormEditBloc extends Bloc<FormEditEvent, FormEditState> {
//   final UserRepository userRepository;
//
//   FormEditBloc({required UserRepository userRepository})
//       : userRepository = userRepository,
//         super(InitFormEditState());
//
//   @override
//   Stream<FormEditState> mapEventToState(FormEditEvent event) async* {
//     if (event is InitFormEditCusEvent) {
//       yield* _getFormEditCus(event.id!);
//     } else if (event is InitFormEditClueEvent) {
//       yield* _getFormEditClue(event.id!);
//     } else if (event is InitFormEditChanceEvent) {
//       yield* _getFormEditChance(event.id!);
//     } else if (event is InitFormEditJobEvent) {
//       yield* _getFormEditJob(event.id!);
//     } else if (event is InitFormEditSupportEvent) {
//       yield* _getFormEditSupport(event.id!);
//     } else if (event is InitFormEditContractEvent) {
//       yield* _getFormEditContract(event.id!);
//     } else if (event is InitGetContactByCustomerEvent) {
//       yield* _getFormEditContract(event.id!);
//     } else if (event is InitFormEditProductEvent) {
//       yield* _getFormEditProduct(event.id!);
//     } else if (event is InitFormEditProductCustomerEvent) {
//       yield* _getFormEditProductCustomer(event.id!);
//     }
//   }
//
//   Stream<FormEditState> _getFormEditCus(String id) async* {
//     LoadingApi().pushLoading();
//     try {
//       yield LoadingFormEditState();
//       final response = await userRepository.getUpdateCustomer(id);
//       if (isSuccess(response.code)) {
//         yield SuccessFormEditState(response.data!);
//       } else {
//         LoadingApi().popLoading();
//         yield ErrorFormEditState(response.msg ?? '');
//       }
//     } catch (e) {
//       LoadingApi().popLoading();
//       yield ErrorFormEditState(getT(KeyT.an_error_occurred));
//       throw e;
//     }
//     LoadingApi().popLoading();
//   }
//
//   Stream<FormEditState> _getFormEditClue(String id) async* {
//     LoadingApi().pushLoading();
//     try {
//       yield LoadingFormEditState();
//       final response = await userRepository.getFormEditClue(id);
//       if (isSuccess(response.code)) {
//         yield SuccessFormEditState(response.data!);
//       } else {
//         yield ErrorFormEditState(response.msg ?? '');
//         LoadingApi().popLoading();
//       }
//     } catch (e) {
//       yield ErrorFormEditState(getT(KeyT.an_error_occurred));
//       LoadingApi().popLoading();
//       throw e;
//     }
//     LoadingApi().popLoading();
//   }
//
//   Stream<FormEditState> _getFormEditChance(String id) async* {
//     LoadingApi().pushLoading();
//     try {
//       yield LoadingFormEditState();
//       final response = await userRepository.getFormAddChance(id);
//       if (isSuccess(response.code)) {
//         yield SuccessFormEditState(response.data!);
//       } else {
//         yield ErrorFormEditState(response.msg ?? '');
//         LoadingApi().popLoading();
//       }
//     } catch (e) {
//       yield ErrorFormEditState(getT(KeyT.an_error_occurred));
//       LoadingApi().popLoading();
//       throw e;
//     }
//     LoadingApi().popLoading();
//   }
//
//   Stream<FormEditState> _getFormEditJob(String id) async* {
//     LoadingApi().pushLoading();
//     try {
//       yield LoadingFormEditState();
//       final response = await userRepository.getFormAddJob(id);
//       if (isSuccess(response.code)) {
//         yield SuccessFormEditState(response.data!);
//       } else {
//         yield ErrorFormEditState(response.msg ?? '');
//         LoadingApi().popLoading();
//       }
//     } catch (e) {
//       yield ErrorFormEditState(getT(KeyT.an_error_occurred));
//       LoadingApi().popLoading();
//       throw e;
//     }
//     LoadingApi().popLoading();
//   }
//
//   Stream<FormEditState> _getFormEditSupport(String id) async* {
//     LoadingApi().pushLoading();
//     try {
//       yield LoadingFormEditState();
//       final response = await userRepository.getFormEditSupport(id);
//       if (isSuccess(response.code)) {
//         yield SuccessFormEditState(response.data!);
//       } else {
//         yield ErrorFormEditState(response.msg ?? '');
//         LoadingApi().popLoading();
//       }
//     } catch (e) {
//       yield ErrorFormEditState(getT(KeyT.an_error_occurred));
//       LoadingApi().popLoading();
//       throw e;
//     }
//     LoadingApi().popLoading();
//   }
//
//   Stream<FormEditState> _getFormEditContract(String id) async* {
//     LoadingApi().pushLoading();
//     try {
//       yield LoadingFormEditState();
//       final response = await userRepository.getFormEditContract(id);
//       if (isSuccess(response.code)) {
//         yield SuccessFormEditState(response.data!);
//       } else {
//         yield ErrorFormEditState(response.msg ?? '');
//         LoadingApi().popLoading();
//       }
//     } catch (e) {
//       yield ErrorFormEditState(getT(KeyT.an_error_occurred));
//       LoadingApi().popLoading();
//       throw e;
//     }
//     LoadingApi().popLoading();
//   }
//
//   Stream<FormEditState> _getFormEditProduct(String id) async* {
//     LoadingApi().pushLoading();
//     try {
//       yield LoadingFormEditState();
//       final response = await userRepository.getEditProduct(id: id);
//       if (isSuccess(response.code)) {
//         yield SuccessFormEditState(response.data!);
//       } else {
//         yield ErrorFormEditState(response.msg ?? '');
//         LoadingApi().popLoading();
//       }
//     } catch (e) {
//       yield ErrorFormEditState(getT(KeyT.an_error_occurred));
//       LoadingApi().popLoading();
//       throw e;
//     }
//     LoadingApi().popLoading();
//   }
//
//   Stream<FormEditState> _getFormEditProductCustomer(String id) async* {
//     LoadingApi().pushLoading();
//     try {
//       yield LoadingFormEditState();
//       final response = await userRepository.getFormEditProductCustomer(id: id);
//       if (isSuccess(response.code)) {
//         yield SuccessFormEditState(response.data!);
//       } else {
//         yield ErrorFormEditState(response.msg ?? '');
//         LoadingApi().popLoading();
//       }
//     } catch (e) {
//       yield ErrorFormEditState(getT(KeyT.an_error_occurred));
//       LoadingApi().popLoading();
//       throw e;
//     }
//     LoadingApi().popLoading();
//   }
//
//   static FormEditBloc of(BuildContext context) =>
//       BlocProvider.of<FormEditBloc>(context);
// }
