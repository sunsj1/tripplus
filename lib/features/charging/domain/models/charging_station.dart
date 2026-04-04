import 'package:freezed_annotation/freezed_annotation.dart';

part 'charging_station.freezed.dart';
part 'charging_station.g.dart';

@freezed
abstract class ChargingStation with _$ChargingStation {
  const factory ChargingStation({
    required int id,
    required String name,
    required double latitude,
    required double longitude,
    String? uuid,
    String? address,
    String? addressLine2,
    String? town,
    String? stateOrProvince,
    String? country,
    String? countryCode,
    String? postcode,
    int? numberOfPoints,
    String? usageType,
    String? usageCost,
    String? statusType,
    bool? isOperational,
    String? operatorName,
    String? operatorWebsite,
    double? distanceKm,
    String? generalComments,
    String? accessComments,
    String? contactPhone,
    String? dateLastVerified,
    bool? isRecentlyVerified,
    @Default([]) List<Connection> connections,
    @Default('ocm') String dataSource,
  }) = _ChargingStation;

  factory ChargingStation.fromJson(Map<String, dynamic> json) =>
      _$ChargingStationFromJson(json);
}

@freezed
abstract class Connection with _$Connection {
  const factory Connection({
    int? id,
    String? connectionType,
    String? formalName,
    String? level,
    bool? isFastCharge,
    double? powerKw,
    int? amps,
    int? voltage,
    String? currentType,
    int? quantity,
    String? statusType,
    bool? isOperational,
  }) = _Connection;

  factory Connection.fromJson(Map<String, dynamic> json) =>
      _$ConnectionFromJson(json);
}
