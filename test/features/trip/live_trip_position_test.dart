import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:journeyplus/core/domain/poi.dart';
import 'package:journeyplus/core/domain/trip_position.dart';
import 'package:journeyplus/core/domain/vehicle.dart';
import 'package:journeyplus/core/services/location_service.dart';
import 'package:journeyplus/core/utils/polyline_decoder.dart';
import 'package:journeyplus/features/alerts/domain/alert_route_utils.dart';
import 'package:journeyplus/features/trip/domain/models/trip.dart';
import 'package:journeyplus/features/trip/domain/models/trip_status.dart';
import 'package:journeyplus/features/trip/data/local_db/corridor_cache_box.dart';
import 'package:journeyplus/features/trip/data/local_db/trip_box.dart';
import 'package:journeyplus/features/trip/data/local_db/trip_history_box.dart';
import 'package:journeyplus/features/trip/presentation/controller/active_trip_controller.dart';
import 'package:journeyplus/features/trip/presentation/controller/active_trip_state.dart';
import 'package:journeyplus/features/trip/presentation/controller/trip_providers.dart';

void main() {
  group('Active-trip platform settings', () {
    test('Android uses an ongoing foreground notification and wake lock', () {
      final settings = LocationService.activeTripSettings(
        TargetPlatform.android,
      );

      expect(settings, isA<AndroidSettings>());
      final android = settings as AndroidSettings;
      expect(android.distanceFilter, 25);
      expect(android.intervalDuration, const Duration(seconds: 10));
      expect(android.foregroundNotificationConfig, isNotNull);
      expect(
        android.foregroundNotificationConfig!.notificationChannelName,
        'JourneyPlus trip tracking',
      );
      expect(android.foregroundNotificationConfig!.enableWakeLock, isTrue);
      expect(android.foregroundNotificationConfig!.setOngoing, isTrue);
    });

    test('iOS uses navigation-grade background location settings', () {
      final settings = LocationService.activeTripSettings(TargetPlatform.iOS);

      expect(settings, isA<AppleSettings>());
      final apple = settings as AppleSettings;
      expect(apple.accuracy, LocationAccuracy.bestForNavigation);
      expect(apple.distanceFilter, 25);
      expect(apple.activityType, ActivityType.automotiveNavigation);
      expect(apple.allowBackgroundLocationUpdates, isTrue);
      expect(apple.pauseLocationUpdatesAutomatically, isFalse);
      expect(apple.showBackgroundLocationIndicator, isTrue);
    });

    test('native manifests declare required background capabilities', () {
      final android = File(
        'android/app/src/main/AndroidManifest.xml',
      ).readAsStringSync();
      final ios = File('ios/Runner/Info.plist').readAsStringSync();

      expect(android, contains('android.permission.FOREGROUND_SERVICE'));
      expect(
        android,
        contains('android.permission.FOREGROUND_SERVICE_LOCATION'),
      );
      expect(android, contains('android.permission.WAKE_LOCK'));
      expect(ios, contains('<key>UIBackgroundModes</key>'));
      expect(ios, contains('<string>location</string>'));
      expect(ios, contains('<key>NSLocationAlwaysUsageDescription</key>'));
      expect(
        ios,
        contains('<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>'),
      );
    });
  });

  group('TripPosition watchable state', () {
    test('Riverpod listeners receive every published GPS snapshot', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final observed = <TripPosition?>[];
      container.listen<TripPosition?>(
        tripPositionProvider,
        (_, next) => observed.add(next),
      );

      final first = _tripPosition(latitude: 18.5, longitude: 73.8);
      final second = _tripPosition(latitude: 18.6, longitude: 73.9);
      container.read(tripPositionProvider.notifier).state = first;
      container.read(tripPositionProvider.notifier).state = second;

      expect(observed, [first, second]);
      expect(container.read(tripPositionProvider), second);
    });

    test('maps Geolocator data without leaking plugin type to consumers', () {
      final source = _position(
        latitude: 18.5,
        longitude: 73.8,
        timestamp: DateTime(2026, 7, 18, 16),
        accuracy: 6,
      );

      final position = TripPosition.fromGeolocator(source);

      expect(position.latitude, 18.5);
      expect(position.longitude, 73.8);
      expect(position.accuracyMeters, 6);
      expect(position.capturedAt, source.timestamp);
      expect(position.latLng.latitude, 18.5);
      expect(position.latLng.longitude, 73.8);
    });
  });

  group('ActiveTripController live GPS', () {
    late Directory hiveDirectory;

    setUpAll(() async {
      hiveDirectory = await Directory.systemTemp.createTemp('journeyplus_a12_');
      Hive.init(hiveDirectory.path);
      await Hive.openBox<dynamic>(TripBox.boxName);
      await Hive.openBox<dynamic>(TripHistoryBox.boxName);
      await Hive.openBox<dynamic>(CorridorCacheBox.boxName);
    });

    setUp(() async {
      await TripBox.clear();
      await TripHistoryBox.clearAll();
      await CorridorCacheBox.clear();
    });

    tearDownAll(() async {
      await Hive.close();
      await hiveDirectory.delete(recursive: true);
    });

    test(
      'restored running trip requests an immediate one-shot position',
      () async {
        final initial = _position(
          latitude: 18.51,
          longitude: 73.81,
          timestamp: DateTime(2026, 7, 18, 16),
        );
        final service = _FakeLocationService(oneShot: Future.value(initial));
        final published = <Position?>[];
        final controller = ActiveTripController(
          locationService: service,
          onPositionChanged: published.add,
          initialState: ActiveTripState.running(trip: _runningTrip()),
        );
        addTearDown(() {
          controller.dispose();
          service.dispose();
        });

        await _flushAsync();

        expect(service.currentPositionCalls, 1);
        expect(service.listenCalls, 1);
        expect(controller.lastPosition, initial);
        expect(published, [initial]);
      },
    );

    test('each stream tick publishes a new reactive position', () async {
      final service = _FakeLocationService(oneShot: Future.value(null));
      final published = <Position?>[];
      final controller = ActiveTripController(
        locationService: service,
        onPositionChanged: published.add,
        initialState: ActiveTripState.running(trip: _runningTrip()),
      );
      addTearDown(() {
        controller.dispose();
        service.dispose();
      });

      final first = _position(
        latitude: 18.51,
        longitude: 73.81,
        timestamp: DateTime(2026, 7, 18, 16),
      );
      final second = _position(
        latitude: 18.52,
        longitude: 73.82,
        timestamp: DateTime(2026, 7, 18, 16, 0, 10),
      );
      await _flushAsync();
      service.emit(first);
      service.emit(second);
      await _flushAsync();

      expect(published, [first, second]);
      expect(controller.lastPosition, second);
    });

    test('slow one-shot fix cannot overwrite a newer stream fix', () async {
      final oneShot = Completer<Position?>();
      final service = _FakeLocationService(oneShot: oneShot.future);
      final published = <Position?>[];
      final controller = ActiveTripController(
        locationService: service,
        onPositionChanged: published.add,
        initialState: ActiveTripState.running(trip: _runningTrip()),
      );
      addTearDown(() {
        controller.dispose();
        service.dispose();
      });

      final newer = _position(
        latitude: 18.6,
        longitude: 73.9,
        timestamp: DateTime(2026, 7, 18, 16, 1),
      );
      final older = _position(
        latitude: 18.5,
        longitude: 73.8,
        timestamp: DateTime(2026, 7, 18, 16),
      );
      await _flushAsync();
      service.emit(newer);
      oneShot.complete(older);
      await _flushAsync();

      expect(controller.lastPosition, newer);
      expect(published, [newer]);
    });

    test('late one-shot result is ignored after controller disposal', () async {
      final oneShot = Completer<Position?>();
      final service = _FakeLocationService(oneShot: oneShot.future);
      final published = <Position?>[];
      final controller = ActiveTripController(
        locationService: service,
        onPositionChanged: published.add,
        initialState: ActiveTripState.running(trip: _runningTrip()),
      );

      controller.dispose();
      oneShot.complete(
        _position(
          latitude: 18.5,
          longitude: 73.8,
          timestamp: DateTime(2026, 7, 18, 16),
        ),
      );
      await _flushAsync();
      service.dispose();

      expect(published, isEmpty);
    });

    test(
      'start, pause, resume, and end own the tracking subscription',
      () async {
        final service = _FakeLocationService(oneShot: Future.value(null));
        final published = <Position?>[];
        final controller = ActiveTripController(
          locationService: service,
          onPositionChanged: published.add,
          initialState: ActiveTripState.ready(trip: _readyTrip()),
        );
        addTearDown(() {
          controller.dispose();
          service.dispose();
        });

        final outcome = await controller.startTrip();
        await _flushAsync();
        expect(outcome, TripStartOutcome.started);
        expect(controller.state, isA<ActiveTripRunning>());
        expect(service.listenCalls, 1);

        await controller.pauseTrip();
        expect(controller.state, isA<ActiveTripPaused>());
        expect(service.cancelCalls, 1);

        await controller.resumeTrip();
        await _flushAsync();
        expect(controller.state, isA<ActiveTripRunning>());
        expect(service.listenCalls, 2);

        await controller.endTrip();
        expect(controller.state, isA<ActiveTripCompleted>());
        expect(service.cancelCalls, 2);
        expect(published.last, isNull);
      },
    );

    test('denied location leaves the prepared trip stopped', () async {
      final service = _FakeLocationService(
        oneShot: Future.value(null),
        permission: LocationPermission.denied,
      );
      final controller = ActiveTripController(
        locationService: service,
        onPositionChanged: (_) {},
        initialState: ActiveTripState.ready(trip: _readyTrip()),
      );
      addTearDown(() {
        controller.dispose();
        service.dispose();
      });

      final outcome = await controller.startTrip();

      expect(outcome, TripStartOutcome.locationDenied);
      expect(controller.state, isA<ActiveTripReady>());
      expect(service.listenCalls, 0);
    });

    test(
      'iOS When In Use starts trip but reports background limitation',
      () async {
        final service = _FakeLocationService(
          oneShot: Future.value(null),
          permission: LocationPermission.whileInUse,
          backgroundLimited: true,
        );
        final controller = ActiveTripController(
          locationService: service,
          onPositionChanged: (_) {},
          initialState: ActiveTripState.ready(trip: _readyTrip()),
        );
        addTearDown(() {
          controller.dispose();
          service.dispose();
        });

        final outcome = await controller.startTrip();
        await _flushAsync();

        expect(outcome, TripStartOutcome.startedBackgroundLimited);
        expect(controller.state, isA<ActiveTripRunning>());
        expect(service.listenCalls, 1);
      },
    );
  });

  group('Corridor projection and ahead filtering', () {
    const route = [LatLng(18.5, 73.8), LatLng(18.5, 74.8)];

    test('projects current TripPosition onto corridor once', () {
      final currentKm = AlertRouteUtils.currentDistanceAlongRouteKm(
        _tripPosition(latitude: 18.5, longitude: 74.3),
        route,
      );

      expect(currentKm, isNotNull);
      expect(currentKm!, greaterThan(50));
      expect(currentKm, lessThan(60));
    });

    test('returns null for invalid corridor instead of throwing', () {
      final currentKm = AlertRouteUtils.currentDistanceAlongRouteKm(
        _tripPosition(latitude: 18.5, longitude: 74.3),
        const [LatLng(18.5, 73.8)],
      );

      expect(currentKm, isNull);
    });

    test('excludes behind and unknown-distance POIs, sorting ahead items', () {
      final ahead = AlertRouteUtils.poisAhead([
        _poi('behind', 20),
        _poi('far', 70),
        _poi('near', 55),
        _poi('unknown', null),
        _poi('current', 50),
      ], 50);

      expect(ahead.map((poi) => poi.id), ['near', 'far']);
    });

    test('window filter excludes behind and beyond-window stops', () {
      final inWindow = AlertRouteUtils.poisInWindow(
        [
          _poi('behind', 49),
          _poi('near', 55),
          _poi('edge', 150),
          _poi('beyond', 151),
        ],
        50,
        100,
      );

      expect(inWindow.map((poi) => poi.id), ['near', 'edge']);
    });
  });
}

class _FakeLocationService extends LocationService {
  _FakeLocationService({
    required this.oneShot,
    this.permission = LocationPermission.always,
    this.backgroundLimited = false,
  });

  final Future<Position?> oneShot;
  final LocationPermission permission;
  final bool backgroundLimited;
  late final StreamController<Position> _positions =
      StreamController<Position>.broadcast(
        sync: true,
        onCancel: () => cancelCalls++,
      );

  int currentPositionCalls = 0;
  int listenCalls = 0;
  int cancelCalls = 0;

  @override
  Future<bool> isServiceEnabled() async => true;

  @override
  Future<LocationPermission> requestTripPermission() async => permission;

  @override
  bool hasLimitedBackgroundPermission(LocationPermission permission) {
    return backgroundLimited;
  }

  @override
  Future<Position?> currentPosition() {
    currentPositionCalls++;
    return oneShot;
  }

  @override
  StreamSubscription<Position> listenToPosition(
    void Function(Position) onPosition, {
    void Function(Object)? onError,
  }) {
    listenCalls++;
    return _positions.stream.listen(onPosition, onError: onError);
  }

  void emit(Position position) => _positions.add(position);

  void dispose() => _positions.close();
}

Trip _runningTrip() => Trip(
  id: 'trip-a0',
  from: 'Pune',
  to: 'Mumbai',
  vehicle: const Vehicle(type: VehicleType.petrol),
  status: TripStatus.active,
  totalDistanceKm: 150,
  drivingMinutes: 180,
  createdAt: DateTime(2026, 7, 18),
  startedAt: DateTime(2026, 7, 18, 15),
);

Trip _readyTrip() =>
    _runningTrip().copyWith(status: TripStatus.notStarted, startedAt: null);

TripPosition _tripPosition({
  required double latitude,
  required double longitude,
}) => TripPosition(
  latitude: latitude,
  longitude: longitude,
  accuracyMeters: 5,
  capturedAt: DateTime(2026, 7, 18, 16),
);

Position _position({
  required double latitude,
  required double longitude,
  required DateTime timestamp,
  double accuracy = 5,
}) => Position(
  latitude: latitude,
  longitude: longitude,
  timestamp: timestamp,
  accuracy: accuracy,
  altitude: 0,
  altitudeAccuracy: 0,
  heading: 0,
  headingAccuracy: 0,
  speed: 0,
  speedAccuracy: 0,
);

Poi _poi(String id, double? distanceAlongRouteKm) => Poi(
  id: id,
  name: id,
  category: PoiCategory.fuel,
  latitude: 18.5,
  longitude: 73.8,
  distanceAlongRouteKm: distanceAlongRouteKm,
);

Future<void> _flushAsync() => Future<void>.delayed(Duration.zero);
