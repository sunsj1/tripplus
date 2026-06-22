import 'package:flutter/material.dart';
import 'package:journeyplus/core/theme/app_colors.dart';

class StationReportHandleBar extends StatelessWidget {
  const StationReportHandleBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        margin: const EdgeInsets.only(top: 10, bottom: 6),
        decoration: BoxDecoration(
          color: AppColors.borderLight,
          borderRadius: BorderRadius.circular(99),
        ),
      ),
    );
  }
}
