import 'package:tripplus/features/charging/data/dto/charging_dto.dart';
import 'package:tripplus/features/charging/domain/models/charging_station.dart';

class ChargingMapper {
  ChargingMapper._();

  static ChargingStation fromDto(ChargingDto dto) {
    final address = dto.addressInfo;
    return ChargingStation(
      id: dto.id,
      uuid: dto.uuid,
      name: address?.title ?? 'Unknown Station',
      latitude: address?.latitude ?? 0.0,
      longitude: address?.longitude ?? 0.0,
      address: address?.addressLine1,
      addressLine2: address?.addressLine2,
      town: address?.town,
      stateOrProvince: address?.stateOrProvince,
      country: address?.country?.title,
      countryCode: address?.country?.isoCode,
      postcode: address?.postcode,
      numberOfPoints: dto.numberOfPoints,
      usageType: dto.usageType?.title,
      usageCost: dto.usageCost,
      statusType: dto.statusType?.title,
      isOperational: dto.statusType?.isOperational,
      operatorName: dto.operatorInfo?.title,
      operatorWebsite: dto.operatorInfo?.websiteUrl,
      distanceKm: _convertDistance(address?.distance, address?.distanceUnit),
      generalComments: dto.generalComments,
      accessComments: address?.accessComments,
      contactPhone: address?.contactTelephone1,
      dateLastVerified: dto.dateLastVerified,
      isRecentlyVerified: dto.isRecentlyVerified,
      connections: dto.connections?.map(_mapConnection).toList() ?? [],
    );
  }

  static Connection _mapConnection(ConnectionDto dto) {
    return Connection(
      id: dto.id,
      connectionType: dto.connectionType?.title,
      formalName: dto.connectionType?.formalName,
      level: dto.level?.title,
      isFastCharge: dto.level?.isFastChargeCapable,
      powerKw: dto.powerKw,
      amps: dto.amps,
      voltage: dto.voltage,
      currentType: dto.currentType?.title,
      quantity: dto.quantity,
      statusType: dto.statusType?.title,
      isOperational: dto.statusType?.isOperational,
    );
  }

  static List<ChargingStation> fromDtoList(List<ChargingDto> dtos) {
    return dtos.map(fromDto).toList();
  }

  /// OCM distance unit: 1 = km, 2 = miles.
  static double? _convertDistance(double? distance, int? unit) {
    if (distance == null) return null;
    if (unit == 2) return distance * 1.60934;
    return distance;
  }
}
