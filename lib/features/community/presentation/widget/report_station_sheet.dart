import 'package:flutter/material.dart';
import 'package:tripplus/core/theme/app_colors.dart';
import 'package:tripplus/core/theme/app_text_styles.dart';
import 'package:tripplus/features/community/domain/models/community_report.dart';

class ReportStationSheet extends StatefulWidget {
  final String stationId;
  final String stationName;

  const ReportStationSheet({
    super.key,
    required this.stationId,
    required this.stationName,
  });

  @override
  State<ReportStationSheet> createState() => _ReportStationSheetState();
}

class _ReportStationSheetState extends State<ReportStationSheet> {
  String _condition = 'working';
  final _costController = TextEditingController();
  bool _fastCharger = false;
  final _commentsController = TextEditingController();

  @override
  void dispose() {
    _costController.dispose();
    _commentsController.dispose();
    super.dispose();
  }

  void _submit() {
    final report = CommunityReport(
      stationId: widget.stationId,
      condition: _condition,
      costPerKwh:
          _costController.text.trim().isEmpty ? null : _costController.text.trim(),
      fastChargerAvailable: _fastCharger,
      comments:
          _commentsController.text.trim().isEmpty ? null : _commentsController.text.trim(),
      reportedAtMs: DateTime.now().millisecondsSinceEpoch,
    );
    Navigator.of(context).pop(report);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Report Station', style: AppTextStyles.h3),
            const SizedBox(height: 4),
            Text(
              widget.stationName,
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textSecondary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 24),

            Text(
              'STATION CONDITION',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textTertiary,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _ConditionTab(
                  label: 'Working',
                  icon: Icons.check_circle_outline,
                  selected: _condition == 'working',
                  color: AppColors.success,
                  onTap: () => setState(() => _condition = 'working'),
                ),
                const SizedBox(width: 10),
                _ConditionTab(
                  label: 'Not Working',
                  icon: Icons.cancel_outlined,
                  selected: _condition == 'not_working',
                  color: AppColors.error,
                  onTap: () => setState(() => _condition = 'not_working'),
                ),
              ],
            ),
            const SizedBox(height: 22),

            Text(
              'CHARGING COST',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textTertiary,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _costController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: 'e.g. 12.50',
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 14, right: 6),
                  child: Text('₹',
                      style:
                          TextStyle(fontSize: 16, color: AppColors.textPrimary)),
                ),
                prefixIconConstraints:
                    const BoxConstraints(minWidth: 0, minHeight: 0),
                suffixText: '/ kWh',
                suffixStyle: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.textTertiary),
                filled: true,
                fillColor: AppColors.surfaceElevated,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              ),
              style: AppTextStyles.titleSmall,
            ),
            const SizedBox(height: 22),

            Text(
              'FAST CHARGER',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textTertiary,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _ConditionTab(
                  label: 'Yes',
                  icon: Icons.bolt,
                  selected: _fastCharger,
                  color: AppColors.teal,
                  onTap: () => setState(() => _fastCharger = true),
                ),
                const SizedBox(width: 10),
                _ConditionTab(
                  label: 'No',
                  icon: Icons.bolt_outlined,
                  selected: !_fastCharger,
                  color: AppColors.textTertiary,
                  onTap: () => setState(() => _fastCharger = false),
                ),
              ],
            ),
            const SizedBox(height: 22),

            Text(
              'ADDITIONAL COMMENTS (Optional)',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textTertiary,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _commentsController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'Any other observations...',
                hintStyle: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.textHint),
                filled: true,
                fillColor: AppColors.surfaceElevated,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              ),
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: FilledButton(
                onPressed: _submit,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Submit Report',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textOnDark,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConditionTab extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _ConditionTab({
    required this.label,
    required this.icon,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: selected
                ? color.withValues(alpha: 0.12)
                : AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? color : AppColors.borderLight,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: selected ? color : AppColors.textTertiary),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  color: selected ? color : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
