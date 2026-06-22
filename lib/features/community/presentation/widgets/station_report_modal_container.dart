import 'package:flutter/material.dart';
import 'package:journeyplus/core/theme/app_colors.dart';

/// Draggable-style sheet chrome for the report wizard.
class StationReportModalContainer extends StatelessWidget {
  final Widget child;
  final double heightFactor;

  const StationReportModalContainer({
    super.key,
    required this.child,
    this.heightFactor = 0.88,
  });

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height * heightFactor;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Material(
          color: Colors.transparent,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: Container(
              width: double.infinity,
              height: h,
              color: AppColors.background,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
