part of 'vehicle_bloc.dart';

sealed class VehicleEvent extends Equatable {
  const VehicleEvent();

  @override
  List<Object?> get props => [];
}

final class GetVehicleByDriverId extends VehicleEvent {
  const GetVehicleByDriverId();

  @override
  List<Object?> get props => [];
}
