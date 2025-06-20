import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ride_hail/core/usecase/usecase.dart';

import '../../../domain/entities/vehicle/vehicle.dart';
import '../../../domain/usecases/vehicle/get_vehicle_by_driver_id.dart';

part 'vehicle_event.dart';
part 'vehicle_state.dart';

class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  final GetVehicleByDriverIdUsecase _getVehicleByDriverId;

  VehicleBloc({required GetVehicleByDriverIdUsecase getVehicleByDriverId})
    : _getVehicleByDriverId = getVehicleByDriverId,
      super(VehicleInitial()) {
    on<GetVehicleByDriverId>(_onLoadVehicleByDriverId);
  }

  Future<void> _onLoadVehicleByDriverId(
    GetVehicleByDriverId event,
    Emitter<VehicleState> emit,
  ) async {
    emit(VehicleLoading());

    final result = await _getVehicleByDriverId(NoParams());

    result.fold(
      (failure) => emit(VehicleFailure(message: failure.message)),
      (vehicle) => emit(VehicleLoaded(vehicle: vehicle)),
    );
  }
}
