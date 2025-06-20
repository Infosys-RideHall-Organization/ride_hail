import 'package:fpdart/fpdart.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../entities/vehicle/vehicle.dart';
import '../../repositories/vehicle/vehicle_repository.dart';

class GetVehicleByDriverIdUsecase implements Usecase<Vehicle, NoParams> {
  final VehicleRepository vehicleRepository;

  const GetVehicleByDriverIdUsecase({required this.vehicleRepository});

  @override
  Future<Either<Failure, Vehicle>> call(NoParams noParams) {
    return vehicleRepository.fetchVehicleByDriverId();
  }
}
