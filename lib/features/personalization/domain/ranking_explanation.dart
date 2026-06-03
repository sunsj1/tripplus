import 'package:flutter/material.dart';

/// P2-033 — A single signal in a [RankingExplanation].
///
/// `weight` is the contribution this signal made to the POI's overall score,
/// so the UI can order reasons by impact. `label` is the user-facing phrase
/// ("Highly rated", "Open now", "On your route") and `icon` is the glyph.
class RankingReason {
  const RankingReason({
    required this.kind,
    required this.label,
    required this.weight,
    required this.icon,
  });

  final RankingReasonKind kind;
  final String label;
  final double weight;
  final IconData icon;
}

enum RankingReasonKind {
  quality,
  proximity,
  openNow,
  dietary,
  family,
  womenSafe,
  pet,
  scenic,
  budget,
  fuelBrand,
}

/// Structured "why we recommend this" for a single POI. `topReasons` is sorted
/// by `weight` desc so callers can show the top N without re-sorting.
class RankingExplanation {
  RankingExplanation({required this.totalScore, required this.reasons})
      : topReasons = ([...reasons]..sort((a, b) => b.weight.compareTo(a.weight)));

  final double totalScore;
  final List<RankingReason> reasons;
  final List<RankingReason> topReasons;

  bool get hasReasons => reasons.isNotEmpty;

  /// Convenience for headline text on the chip.
  String get headline {
    if (topReasons.isEmpty) return 'Standard match';
    final first = topReasons.first;
    switch (first.kind) {
      case RankingReasonKind.quality:
        return 'Highly rated by drivers';
      case RankingReasonKind.proximity:
        return 'Right on your route';
      case RankingReasonKind.openNow:
        return 'Open right now';
      case RankingReasonKind.dietary:
        return 'Matches your dietary preference';
      case RankingReasonKind.family:
        return 'Family-friendly';
      case RankingReasonKind.womenSafe:
        return 'Reported women-safe';
      case RankingReasonKind.pet:
        return 'Pet-friendly';
      case RankingReasonKind.scenic:
        return 'Scenic stop';
      case RankingReasonKind.budget:
        return 'Matches your budget';
      case RankingReasonKind.fuelBrand:
        return 'Your preferred brand';
    }
  }
}
