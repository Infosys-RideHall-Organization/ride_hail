part of 'vehicle_bloc.dart';

sealed class VehicleState extends Equatable {
  const VehicleState();

  @override
  List<Object?> get props => [];
}

final class VehicleInitial extends VehicleState {}

final class VehicleLoading extends VehicleState {}

final class VehicleLoaded extends VehicleState {
  final Vehicle vehicle;

  const VehicleLoaded({required this.vehicle});

  @override
  List<Object?> get props => [vehicle];
}

final class VehicleFailure extends VehicleState {
  final String message;

  const VehicleFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
