import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:journeyplus/core/domain/poi.dart';

/// P2-074 — Lightweight zoom-based grid clustering for [GoogleMap] markers.
///
/// At low zoom, POIs in the same coarse lat/lng bucket are merged into a
/// single cluster marker that shows the count. Tapping the cluster zooms in.
/// At zoom ≥ [clusterZoomThreshold] every POI gets its own marker again.
///
/// The pixel-grid math uses the standard "tile-pixels per degree" approximation
/// — close enough for marker bunching, no external dependency.
class PoiMarkerClustering {
  PoiMarkerClustering._();

  /// Zooms ≥ this show every POI individually.
  static const double clusterZoomThreshold = 12.5;

  /// Cell size in screen pixels at the current zoom — POIs within the same
  /// cell merge.
  static const double cellSizePx = 90.0;

  /// Builds [Marker]s for [pois]; clusters when [zoom] is below threshold.
  /// [onMarkerTap] is fired with the POI for single markers, or with `null`
  /// + the cluster centre+pois for cluster taps so the caller can zoom in.
  static Future<Set<Marker>> build({
    required List<Poi> pois,
    required double zoom,
    required void Function(Poi poi) onPoiTap,
    required void Function(LatLng centre) onClusterTap,
  }) async {
    if (pois.isEmpty) return const {};

    if (zoom >= clusterZoomThreshold) {
      return {
        for (final poi in pois)
          Marker(
            markerId: MarkerId(poi.id),
            position: LatLng(poi.latitude, poi.longitude),
            icon: _markerIconForPoi(poi),
            onTap: () => onPoiTap(poi),
          ),
      };
    }

    // Coarse grid bucketing. Cell size in degrees = pixelCellSize / pxPerDeg.
    // Approx Web-Mercator: pxPerDeg(lng) = 256 * 2^zoom / 360.
    final pxPerDeg = (256 * (1 << zoom.floor())) / 360.0;
    final cellSizeDeg = cellSizePx / pxPerDeg;

    final buckets = <String, List<Poi>>{};
    for (final poi in pois) {
      final keyLat = (poi.latitude / cellSizeDeg).floor();
      final keyLng = (poi.longitude / cellSizeDeg).floor();
      buckets.putIfAbsent('$keyLat:$keyLng', () => []).add(poi);
    }

    final markers = <Marker>{};
    for (final entry in buckets.entries) {
      final list = entry.value;
      if (list.length == 1) {
        final poi = list.first;
        markers.add(Marker(
          markerId: MarkerId(poi.id),
          position: LatLng(poi.latitude, poi.longitude),
          icon: _markerIconForPoi(poi),
          onTap: () => onPoiTap(poi),
        ));
        continue;
      }

      // Cluster: average position, count-labelled icon.
      final lat = list.fold<double>(0, (a, p) => a + p.latitude) / list.length;
      final lng = list.fold<double>(0, (a, p) => a + p.longitude) / list.length;
      final icon = await _clusterIcon(list.length);
      markers.add(Marker(
        markerId: MarkerId('cluster:${entry.key}'),
        position: LatLng(lat, lng),
        icon: icon,
        onTap: () => onClusterTap(LatLng(lat, lng)),
      ));
    }

    return markers;
  }

  static BitmapDescriptor _markerIconForPoi(Poi poi) {
    return BitmapDescriptor.defaultMarkerWithHue(
      poi.openNow == false
          ? BitmapDescriptor.hueOrange
          : BitmapDescriptor.hueGreen,
    );
  }

  /// Renders a circular "N" badge into a [BitmapDescriptor] using Skia.
  static final _iconCache = <int, BitmapDescriptor>{};
  static Future<BitmapDescriptor> _clusterIcon(int count) async {
    final cached = _iconCache[count];
    if (cached != null) return cached;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    const size = 96.0;
    final paint = Paint()..color = const Color(0xFF1B5E20); // primary
    final shadowPaint = Paint()..color = Colors.black.withValues(alpha: 0.18);

    // Soft shadow + halo + filled circle.
    canvas.drawCircle(const Offset(size / 2, size / 2 + 2), size / 2.2, shadowPaint);
    canvas.drawCircle(
      const Offset(size / 2, size / 2),
      size / 2.2,
      Paint()..color = const Color(0xFFE8F5E9), // primarySurface halo
    );
    canvas.drawCircle(const Offset(size / 2, size / 2), size / 2.8, paint);

    final tp = TextPainter(
      text: TextSpan(
        text: count >= 100 ? '99+' : '$count',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 30,
          fontWeight: FontWeight.w800,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(
      canvas,
      Offset((size - tp.width) / 2, (size - tp.height) / 2),
    );

    final picture = recorder.endRecording();
    final image = await picture.toImage(size.toInt(), size.toInt());
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    final descriptor =
        BitmapDescriptor.bytes(bytes!.buffer.asUint8List());

    _iconCache[count] = descriptor;
    return descriptor;
  }
}
