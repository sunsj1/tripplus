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
