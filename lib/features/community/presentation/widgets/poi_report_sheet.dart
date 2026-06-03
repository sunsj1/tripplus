import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripplus/core/domain/poi.dart';
import 'package:tripplus/core/theme/app_colors.dart';
import 'package:tripplus/core/theme/app_text_styles.dart';
import 'package:tripplus/features/auth/presentation/providers/auth_providers.dart';
import 'package:tripplus/features/community/domain/community_target_type.dart';
import 'package:tripplus/features/community/domain/models/station_community_submit_input.dart';
import 'package:tripplus/features/community/presentation/controller/community_providers.dart';
import 'package:tripplus/features/pois/domain/community_poi_key.dart';

/// Opens a lightweight pulse sheet for any [Poi].
///
/// Reuses the existing [StationCommunitySubmitInput] schema with
/// [CommunityTargetType.poi] so submissions land in the same Firestore
/// collection and are readable by [poiCommunityControllerProvider].
Future<bool?> showPoiReportSheet({
  required BuildContext context,
  required Poi poi,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => _PoiReportSheet(poi: poi),
  );
}

class _PoiReportSheet extends ConsumerStatefulWidget {
  const _PoiReportSheet({required this.poi});
  final Poi poi;

  @override
  ConsumerState<_PoiReportSheet> createState() => _PoiReportSheetState();
}

class _PoiReportSheetState extends ConsumerState<_PoiReportSheet> {
  int _rating = 0;
  final _commentCtrl = TextEditingController();
  bool _submitting = false;
  // P2-023 — mode-relevant tags. null = unanswered (default), bool = explicit.
  bool? _babyFriendly;
  bool? _womenSafe;
  bool? _hygienic;
  // P2-043 — Road condition near the place. null = unanswered.
  String? _roadCondition;

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please tap a star to rate this place.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final user = ref.read(userAppStateProvider);
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sign in to share a pulse.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _submitting = true);

    final targetKey = communityPoiKey(widget.poi);
    final controller = ref.read(poiCommunityControllerProvider(targetKey).notifier);

    final input = StationCommunitySubmitInput(
      stationKey: targetKey,
      stationNameSnapshot: widget.poi.name,
      reporterUserId: user.userId,
      reporterDisplayName: user.displayName,
      rating: _rating,
      // 'good' / 'fair' / 'poor' map to positive / neutral / negative tones
      // in CommunityReportSnippetCard._toneForReport (POI branch).
      condition: _rating >= 4 ? 'good' : _rating >= 3 ? 'fair' : 'poor',
      comment: _commentCtrl.text.trim().isEmpty ? null : _commentCtrl.text.trim(),
      targetType: CommunityTargetType.poi,
      targetKey: targetKey,
      // P2-023 — only attach tags the user explicitly answered.
      babyFriendly: _babyFriendly,
      womenSafe: _womenSafe,
      hygienic: _hygienic,
      // P2-043 — Road condition (if picked).
      roadCondition: _roadCondition,
    );

    final result = await controller.submit(input);
    if (!mounted) return;

    setState(() => _submitting = false);

    result.match(
      (err) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(err),
          behavior: SnackBarBehavior.floating,
        ),
      ),
      (_) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Thanks — your pulse helps the next traveller.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              Text('Rate this place', style: AppTextStyles.h4),
              const SizedBox(height: 4),
              Text(
                widget.poi.name,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 24),

              // Star rating
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(5, (i) {
                    final filled = i < _rating;
                    return GestureDetector(
                      onTap: () => setState(() => _rating = i + 1),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Icon(
                          filled ? Icons.star_rounded : Icons.star_outline_rounded,
                          size: 40,
                          color: filled
                              ? AppColors.warning
                              : AppColors.borderLight,
                        ),
                      ),
                    );
                  }),
                ),
              ),
              if (_rating > 0) ...[
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    _ratingLabel(_rating),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.warning,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),

              // Optional comment
              TextField(
                controller: _commentCtrl,
                maxLines: 3,
                maxLength: 280,
                decoration: InputDecoration(
                  hintText: 'Add a note (optional)…',
                  hintStyle: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textTertiary,
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.borderLight),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.borderLight),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: AppColors.primary.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // P2-023 — Mode-relevant tags (optional). Tri-state chips so
              // unanswered tags don't bias the aggregation.
              Text(
                'OPTIONAL — for other travellers',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textTertiary,
                  letterSpacing: 1.0,
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 8),
              _TriStateTag(
                label: 'Baby/kids friendly',
                value: _babyFriendly,
                onChanged: (v) => setState(() => _babyFriendly = v),
              ),
              const SizedBox(height: 6),
              _TriStateTag(
                label: 'Felt safe for women',
                value: _womenSafe,
                onChanged: (v) => setState(() => _womenSafe = v),
              ),
              const SizedBox(height: 6),
              _TriStateTag(
                label: 'Clean / hygienic',
                value: _hygienic,
                onChanged: (v) => setState(() => _hygienic = v),
              ),
              const SizedBox(height: 14),
              // P2-043 — Road condition near the place.
              Text(
                'Road near here',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                children: [
                  _RoadConditionChip(
                    label: 'Smooth',
                    value: 'good',
                    selected: _roadCondition == 'good',
                    color: AppColors.success,
                    onTap: (v) => setState(
                        () => _roadCondition = _roadCondition == v ? null : v),
                  ),
                  _RoadConditionChip(
                    label: 'Rough',
                    value: 'rough',
                    selected: _roadCondition == 'rough',
                    color: AppColors.warning,
                    onTap: (v) => setState(
                        () => _roadCondition = _roadCondition == v ? null : v),
                  ),
                  _RoadConditionChip(
                    label: 'Construction',
                    value: 'construction',
                    selected: _roadCondition == 'construction',
                    color: AppColors.error,
                    onTap: (v) => setState(
                        () => _roadCondition = _roadCondition == v ? null : v),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Submit
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  onPressed: _submitting ? null : _submit,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  icon: _submitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.bolt_outlined),
                  label: Text(_submitting ? 'Sending…' : 'Share pulse'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _ratingLabel(int r) {
    switch (r) {
      case 1: return 'Poor';
      case 2: return 'Fair';
      case 3: return 'Good';
      case 4: return 'Very good';
      case 5: return 'Excellent';
      default: return '';
    }
  }
}

/// P2-023 — Tri-state tag row: Yes / No / no-answer. Tapping the active button
/// clears it back to unanswered so a user can correct a misclick without
/// committing to either answer.
class _TriStateTag extends StatelessWidget {
  const _TriStateTag({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool? value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(width: 8),
        _TagButton(
          icon: Icons.check_rounded,
          color: AppColors.success,
          selected: value == true,
          onTap: () => onChanged(value == true ? null : true),
        ),
        const SizedBox(width: 6),
        _TagButton(
          icon: Icons.close_rounded,
          color: AppColors.error,
          selected: value == false,
          onTap: () => onChanged(value == false ? null : false),
        ),
      ],
    );
  }
}

/// P2-043 — Single-select chip for `good` / `rough` / `construction`. Tap the
/// active chip again to deselect (mirrors `_TriStateTag` UX).
class _RoadConditionChip extends StatelessWidget {
  const _RoadConditionChip({
    required this.label,
    required this.value,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  final String label;
  final String value;
  final bool selected;
  final Color color;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? color : AppColors.borderLight,
            width: selected ? 1.4 : 1,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: selected ? color : AppColors.textSecondary,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class _TagButton extends StatelessWidget {
  const _TagButton({
    required this.icon,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: selected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? color : AppColors.borderLight,
            width: 1.2,
          ),
        ),
        child: Icon(
          icon,
          size: 18,
          color: selected ? Colors.white : color,
        ),
      ),
    );
  }
}
