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

  SaveCheckIn(this.longitude, this.latitude, this.location,this.id);

}
