part of 'support_bloc.dart';

abstract class SupportEvent extends Equatable {
  const SupportEvent();
  @override
  List<Object?> get props => [];
}

class InitGetSupportEvent extends SupportEvent {
  final String? search, filter, ids;
  final int? page;

  InitGetSupportEvent({this.page, this.search, this.filter, this.ids});
}
