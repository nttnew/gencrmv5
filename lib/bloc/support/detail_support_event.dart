part of 'detail_support_bloc.dart';

abstract class DetailSupportEvent extends Equatable {
  const DetailSupportEvent();
  @override
  List<Object?> get props => [];
}

class InitGetDetailSupportEvent extends DetailSupportEvent {
  final String id;

  InitGetDetailSupportEvent(this.id);
}

class DeleteSupportEvent extends DetailSupportEvent {
  final String id;

  DeleteSupportEvent(this.id);
}
