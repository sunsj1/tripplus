import 'package:flutter/material.dart';
import 'package:journeyplus/core/theme/app_colors.dart';

class CommunityReportCtaButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool busy;

  const CommunityReportCtaButton({
    super.key,
    required this.onPressed,
    this.busy = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        onPressed: busy ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        icon: busy
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.bolt_outlined, size: 20),
        label: Text(
          busy ? 'Sending…' : 'Share a quick pulse',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
