import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:journeyplus/features/trip/domain/models/trip.dart';
import 'package:journeyplus/features/trip/domain/trip_share_text.dart';

/// P2-052 — Drops the trip share text into the OS share sheet.
///
/// We pass [BuildContext.size] to [ShareParams.sharePositionOrigin] because
/// iPads need an anchor rect for the popover.
Future<void> shareTrip(BuildContext context, Trip trip) async {
  final box = context.findRenderObject() as RenderBox?;
  final origin =
      box != null ? box.localToGlobal(Offset.zero) & box.size : null;

  await SharePlus.instance.share(
    ShareParams(
      text: buildTripShareText(trip),
      subject: '${trip.from} → ${trip.to} on JourneyPlus',
      sharePositionOrigin: origin,
    ),
  );
}
