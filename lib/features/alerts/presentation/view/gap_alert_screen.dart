import 'package:flutter/material.dart';
import 'package:tripplus/core/theme/app_colors.dart';
import 'package:tripplus/core/theme/app_text_styles.dart';
import 'package:tripplus/core/widgets/app_top_bar.dart';
import 'package:tripplus/features/alerts/presentation/widget/journey_timeline.dart';

class GapAlertScreen extends StatefulWidget {
  final double gapKm;
  final double distanceToEmpty;
  final String nextStationName;
  final double nextStationKm;

  const GapAlertScreen({
    super.key,
    required this.gapKm,
    required this.distanceToEmpty,
    required this.nextStationName,
    required this.nextStationKm,
  });

  @override
  State<GapAlertScreen> createState() => _GapAlertScreenState();
}

class _GapAlertScreenState extends State<GapAlertScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animCtrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fade = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic));
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fade,
          child: SlideTransition(
            position: _slide,
            child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(height: 8),
            AppTopBar(
              title: 'Gap Alert',
              showBack: true,
              onBack: () => Navigator.pop(context),
            ),
            const SizedBox(height: 12),

            // Critical alert banner
            _CriticalAlertBanner(
              gapKm: widget.gapKm,
              onPlanStop: () {},
              onDismiss: () => Navigator.pop(context),
            ),
            const SizedBox(height: 20),

            // Gap visualization
            _GapVisualization(gapKm: widget.gapKm),
            const SizedBox(height: 24),

            // Distance to empty
            _DistanceToEmpty(distanceKm: widget.distanceToEmpty),
            const SizedBox(height: 20),

            // Next station
            _NextStationCard(name: widget.nextStationName, distanceKm: widget.nextStationKm),
            const SizedBox(height: 24),

            // Journey outlook
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Journey Outlook',
                style: AppTextStyles.titleMedium,
              ),
            ),
            const SizedBox(height: 14),
            JourneyTimeline(
              gapKm: widget.gapKm,
              nextStationName: widget.nextStationName,
              nextStationKm: widget.nextStationKm,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
        ),
      ),
    );
  }
}

class _CriticalAlertBanner extends StatelessWidget {
  final double gapKm;
  final VoidCallback onPlanStop;
  final VoidCallback onDismiss;

  const _CriticalAlertBanner({
    required this.gapKm,
    required this.onPlanStop,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.errorSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 14,
                      color: AppColors.textOnDark,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'CRITICAL ALERT',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: AppColors.textOnDark,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '${gapKm.round()} km charging\ngap ahead',
            style: AppTextStyles.h2.copyWith(height: 1.2),
          ),
          const SizedBox(height: 10),
          Text(
            'If you miss the next station, the one after is ${gapKm.round()} km away. Ensure you have sufficient range before proceeding.',
            style: AppTextStyles.bodyMedium.copyWith(height: 1.6),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton.icon(
              onPressed: onPlanStop,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.ev_station, size: 18, color: AppColors.textOnDark),
              label: const Text(
                'Plan Stop Now',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textOnDark,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: TextButton(
              onPressed: onDismiss,
              child: Text(
                'Dismiss',
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GapVisualization extends StatelessWidget {
  final double gapKm;

  const _GapVisualization({required this.gapKm});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: CustomPaint(
          painter: _GapMapPainter(gapKm: gapKm),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _GapMapPainter extends CustomPainter {
  final double gapKm;

  _GapMapPainter({required this.gapKm});

  @override
  void paint(Canvas canvas, Size size) {
    // Dark road background
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF37474F), Color(0xFF263238)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(20),
      ),
      bgPaint,
    );

    // Road
    final roadPaint = Paint()..color = const Color(0xFF546E7A);
    final roadPath = Path();
    roadPath.moveTo(size.width * 0.3, size.height);
    roadPath.quadraticBezierTo(
      size.width * 0.4, size.height * 0.3,
      size.width * 0.5, size.height * 0.05,
    );
    roadPath.lineTo(size.width * 0.55, size.height * 0.05);
    roadPath.quadraticBezierTo(
      size.width * 0.65, size.height * 0.3,
      size.width * 0.7, size.height,
    );
    roadPath.close();
    canvas.drawPath(roadPath, roadPaint);

    // Road center line
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.4)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    final centerPath = Path();
    centerPath.moveTo(size.width * 0.5, size.height);
    centerPath.quadraticBezierTo(
      size.width * 0.5, size.height * 0.3,
      size.width * 0.525, size.height * 0.05,
    );
    canvas.drawPath(centerPath, linePaint);

    // Gap zone label
    final gapBg = Paint()..color = AppColors.error.withValues(alpha: 0.85);
    final gapRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.45),
        width: 120,
        height: 36,
      ),
      const Radius.circular(10),
    );
    canvas.drawRRect(gapRect, gapBg);

    // "GAP ZONE" text
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'GAP ZONE',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        size.width * 0.5 - textPainter.width / 2,
        size.height * 0.42,
      ),
    );

    // Distance text
    final distPainter = TextPainter(
      text: TextSpan(
        text: '${gapKm.round()}km',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w800,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    distPainter.layout();
    distPainter.paint(
      canvas,
      Offset(
        size.width * 0.5 - distPainter.width / 2,
        size.height * 0.5,
      ),
    );

    // Red zone indicator
    final zonePaint = Paint()
      ..color = AppColors.error.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.7),
      30,
      zonePaint,
    );
    final dotPaint = Paint()..color = AppColors.error;
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.7),
      5,
      dotPaint,
    );

    // Station icon
    final stationPaint = Paint()..color = AppColors.success;
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.15),
      5,
      stationPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _GapMapPainter oldDelegate) =>
      oldDelegate.gapKm != gapKm;
}

class _DistanceToEmpty extends StatelessWidget {
  final double distanceKm;

  const _DistanceToEmpty({required this.distanceKm});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'DISTANCE TO EMPTY',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textTertiary,
                  letterSpacing: 1.5,
                ),
              ),
              Icon(Icons.battery_std, size: 18, color: AppColors.primary),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${distanceKm.round()}',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  height: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8, left: 4),
                child: Text(
                  'km',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (distanceKm / 400).clamp(0, 1),
              minHeight: 6,
              backgroundColor: AppColors.border,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _NextStationCard extends StatelessWidget {
  final String name;
  final double distanceKm;

  const _NextStationCard({required this.name, required this.distanceKm});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'NEXT STATION',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primary,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: AppTextStyles.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                      'Approx. ${(distanceKm / 1.3).round()} min away',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ),
              Text(
                '${distanceKm.round()}km',
                style: AppTextStyles.h3.copyWith(color: AppColors.success),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.bolt, size: 16, color: AppColors.primary),
              const SizedBox(width: 4),
              Icon(Icons.bolt, size: 16, color: AppColors.primary),
            ],
          ),
        ],
      ),
    );
  }
}
