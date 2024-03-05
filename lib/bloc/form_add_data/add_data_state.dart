part of 'add_data_bloc.dart';

abstract class AddDataState extends Equatable {
  const AddDataState();
  @override
  List<Object?> get props => [];
}

class InitAddDataState extends AddDataState {}

class LoadingAddData extends AddDataState {}

class SuccessAddData extends AddDataState {
  final List<dynamic>? dataSPKH;
  final String? idKH;
  final List<String>? result;
  final bool isEdit;

  SuccessAddData({
    this.dataSPKH,
    this.idKH,
    this.result,
    this.isEdit = false,
  });
}

class ErrorAddData extends AddDataState {
  final String msg;

  ErrorAddData(this.msg);
  @override
  List<Object> get props => [msg];
}
