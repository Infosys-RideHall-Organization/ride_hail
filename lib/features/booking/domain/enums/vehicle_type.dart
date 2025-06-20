enum VehicleType { buggy, transportTruck, bot, notSpecified }

extension VehicleTypeExtension on VehicleType {
  String get displayValue {
    switch (this) {
      case VehicleType.buggy:
        return 'Buggy';
      case VehicleType.transportTruck:
        return 'Transport Truck';
      case VehicleType.bot:
        return 'Bot';
      case VehicleType.notSpecified:
        return 'Not Specified';
    }
  }

  static VehicleType fromString(String value) {
    switch (value) {
      case 'Buggy':
        return VehicleType.buggy;
      case 'Transport Truck':
        return VehicleType.transportTruck;
      case 'Bot':
        return VehicleType.bot;
      default:
        return VehicleType.notSpecified;
    }
  }
}
