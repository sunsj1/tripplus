import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tripplus/core/theme/app_colors.dart';
import 'package:tripplus/core/theme/app_text_styles.dart';
import 'package:tripplus/core/widgets/app_top_bar.dart';

class CalculatingView extends StatefulWidget {
  final String from;
  final String to;

  const CalculatingView({
    super.key,
    required this.from,
    required this.to,
  });

  @override
  State<CalculatingView> createState() => _CalculatingViewState();
}

class _CalculatingViewState extends State<CalculatingView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _enterCtrl;
  late final Animation<double> _fadeIn;
  late final Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();
    _enterCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeIn = CurvedAnimation(parent: _enterCtrl, curve: Curves.easeOut);
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _enterCtrl, curve: Curves.easeOutCubic));
    _enterCtrl.forward();
  }

  @override
  void dispose() {
    _enterCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeIn,
      child: SlideTransition(
        position: _slideUp,
        child: Column(
          children: [
            const SizedBox(height: 8),
            const AppTopBar(),
            const Spacer(flex: 2),
            const _AnimatedProgress(),
            const SizedBox(height: 40),
            Text(
              'Analyzing route for\ncharging gaps...',
              textAlign: TextAlign.center,
              style: AppTextStyles.h3.copyWith(height: 1.3),
            ),
            const SizedBox(height: 28),
            _RouteChip(from: widget.from, to: widget.to),
            const SizedBox(height: 14),
            Text(
              'Finding stations between ${widget.from}\nand ${widget.to}',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium,
            ),
            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}

class _AnimatedProgress extends StatefulWidget {
  const _AnimatedProgress();

  @override
  State<_AnimatedProgress> createState() => _AnimatedProgressState();
}

class _AnimatedProgressState extends State<_AnimatedProgress>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 160,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _CircularProgressPainter(
              progress: _controller.value,
            ),
            child: Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surface,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.route,
                  size: 36,
                  color: AppColors.primary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;

  _CircularProgressPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;

    final trackPaint = Paint()
      ..color = AppColors.border.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, trackPaint);

    final arcPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2 + (2 * pi * progress),
      pi * 0.7,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CircularProgressPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _RouteChip extends StatelessWidget {
  final String from;
  final String to;

  const _RouteChip({required this.from, required this.to});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              from,
              style: AppTextStyles.titleSmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child:
                Icon(Icons.arrow_forward, size: 18, color: AppColors.warning),
          ),
          Flexible(
            child: Text(
              to,
              style: AppTextStyles.titleSmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
