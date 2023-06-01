part of 'checkin_bloc.dart';

abstract class CheckInEvent extends Equatable {
  const CheckInEvent();

  @override
  List<Object> get props => [];
}

class SaveCheckIn extends CheckInEvent {
  final String longitude;
  final String latitude;
  final String location;
  final String id;
  final String module;
  final String type;

  SaveCheckIn(
    this.longitude,
    this.latitude,
    this.location,
    this.id,
    this.module,
    this.type,
  );

  @override
  List<Object> get props => [
        longitude,
        latitude,
        location,
        id,
        module,
        type,
      ];
}
