import 'package:flutter/material.dart';
import 'package:journeyplus/core/theme/app_colors.dart';

Future<void> showTripEndDialog(
  BuildContext context, {
  required VoidCallback onConfirm,
}) {
  return showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('End trip?'),
      content: const Text(
        'This will save the trip to your on-device history and finalise the summary. '
        'You cannot resume after ending.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(ctx);
            onConfirm();
          },
          style: FilledButton.styleFrom(backgroundColor: AppColors.error),
          child: const Text('End trip'),
        ),
      ],
    ),
  );
}
