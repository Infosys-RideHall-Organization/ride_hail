import 'package:fpdart/fpdart.dart';

import '../../../../../core/error/failure.dart';
import '../../entities/vehicle/vehicle.dart';

abstract interface class VehicleRepository {
  Future<Either<Failure, Vehicle>> fetchVehicleByDriverId();
}
