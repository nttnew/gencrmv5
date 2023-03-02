part of 'infor_bloc.dart';
abstract class InforState extends Equatable {

  @override
  List<Object?> get props => [];

  InforState();
}
class InitGetInforState extends InforState {}

class UpdateGetInforState extends InforState{
  final String? gioi_thieu;


  UpdateGetInforState(this.gioi_thieu);
}
class LoadingGetInforState extends InforState{

}


class ErrorGetInforState extends InforState{
  final String msg;

  ErrorGetInforState(this.msg);
  @override
  List<Object> get props => [msg];
}