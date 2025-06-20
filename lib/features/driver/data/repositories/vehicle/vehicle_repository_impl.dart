import 'package:fpdart/fpdart.dart';
import 'package:ride_hail/core/constants/constants.dart';
import 'package:ride_hail/core/services/secure_storage/secure_storage_service.dart';

import '../../../../../core/error/failure.dart';
import '../../../domain/entities/vehicle/vehicle.dart';
import '../../../domain/repositories/vehicle/vehicle_repository.dart';
import '../../datasources/vehicle/vehicle_remote_data_source.dart';

class VehicleRepositoryImpl implements VehicleRepository {
  final VehicleRemoteDataSource vehicleRemoteDataSource;
  final SecureStorageService secureStorageService;

  VehicleRepositoryImpl({
    required this.vehicleRemoteDataSource,
    required this.secureStorageService,
  });

  @override
  Future<Either<Failure, Vehicle>> fetchVehicleByDriverId() async {
    try {
      final driverId = await secureStorageService.getString(
        Constants.userIdKey,
      );
      final vehicle = await vehicleRemoteDataSource.fetchVehicleByDriverId(
        driverId!,
      );
      return right(vehicle);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
