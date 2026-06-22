import 'package:flutter/material.dart';
import 'package:journeyplus/core/theme/app_colors.dart';
import 'package:journeyplus/core/theme/app_text_styles.dart';

class EmptyStateScreen extends StatelessWidget {
  final VoidCallback onSearchAgain;
  final VoidCallback? onViewMap;

  const EmptyStateScreen({
    super.key,
    required this.onSearchAgain,
    this.onViewMap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 8),
          SizedBox(
            height: 220,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: CustomPaint(painter: _RoadIllustrationPainter()),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ROUTE STATUS: EMPTY',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textTertiary,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No charging stations\nfound on this route.',
            textAlign: TextAlign.center,
            style: AppTextStyles.h2.copyWith(height: 1.2),
          ),
          const SizedBox(height: 14),
          Text(
            'Try an alternative route or search for\na different destination. Our network is\nconstantly expanding.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(height: 1.7),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton.icon(
              onPressed: onSearchAgain,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: const Icon(Icons.search, color: AppColors.textOnDark),
              label: const Text(
                'Search Again',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textOnDark,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: OutlinedButton.icon(
              onPressed: onViewMap,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: const Icon(Icons.map_outlined, color: AppColors.textPrimary),
              label: const Text(
                'View Network Map',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _ProTipCard(),
        ],
      ),
    );
  }
}

class _ProTipCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.lightbulb_outline, size: 22, color: AppColors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pro Tip', style: AppTextStyles.titleSmall),
                const SizedBox(height: 2),
                Text(
                  'Charging station visibility can be filtered by plug type in your settings.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RoadIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Sky gradient
    final skyPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB), Color(0xFFE8F5E9)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height * 0.65));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height * 0.65), skyPaint);

    // Ground
    final groundPaint = Paint()..color = const Color(0xFFE0E0E0);
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.55, size.width, size.height * 0.45),
      groundPaint,
    );

    // Road
    final roadPaint = Paint()..color = const Color(0xFF757575);
    final roadPath = Path();
    roadPath.moveTo(size.width * 0.35, size.height);
    roadPath.lineTo(size.width * 0.45, size.height * 0.4);
    roadPath.lineTo(size.width * 0.55, size.height * 0.4);
    roadPath.lineTo(size.width * 0.65, size.height);
    roadPath.close();
    canvas.drawPath(roadPath, roadPaint);

    // Road lines
    final linePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    for (double i = 0.45; i < 1.0; i += 0.08) {
      final y = size.height * i;
      final t = (i - 0.4) / 0.6;
      final lineWidth = 4 + t * 10;
      canvas.drawLine(
        Offset(size.width * 0.5 - lineWidth / 2, y),
        Offset(size.width * 0.5 + lineWidth / 2, y + 8),
        linePaint,
      );
    }

    // Clouds
    final cloudPaint = Paint()..color = Colors.white.withValues(alpha: 0.9);
    _drawCloud(canvas, Offset(size.width * 0.2, size.height * 0.15), 30, cloudPaint);
    _drawCloud(canvas, Offset(size.width * 0.7, size.height * 0.1), 25, cloudPaint);
    _drawCloud(canvas, Offset(size.width * 0.85, size.height * 0.25), 20, cloudPaint);

    // Sun
    final sunPaint = Paint()..color = const Color(0xFFFFF176);
    canvas.drawCircle(Offset(size.width * 0.78, size.height * 0.12), 18, sunPaint);

    // JourneyPlus icon in sky
    final iconBg = Paint()..color = AppColors.teal.withValues(alpha: 0.15);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.32), 28, iconBg);

    final boltPaint = Paint()
      ..color = AppColors.teal.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;
    final cx = size.width * 0.5;
    final cy = size.height * 0.32;
    final boltPath = Path();
    boltPath.moveTo(cx - 6, cy - 12);
    boltPath.lineTo(cx + 2, cy - 1);
    boltPath.lineTo(cx - 1, cy - 1);
    boltPath.lineTo(cx + 6, cy + 12);
    boltPath.lineTo(cx - 2, cy + 1);
    boltPath.lineTo(cx + 1, cy + 1);
    boltPath.close();
    canvas.drawPath(boltPath, boltPaint);
  }

  void _drawCloud(Canvas canvas, Offset center, double radius, Paint paint) {
    canvas.drawCircle(center, radius, paint);
    canvas.drawCircle(Offset(center.dx - radius * 0.7, center.dy + 4), radius * 0.7, paint);
    canvas.drawCircle(Offset(center.dx + radius * 0.7, center.dy + 4), radius * 0.7, paint);
    canvas.drawCircle(Offset(center.dx - radius * 0.3, center.dy - radius * 0.3), radius * 0.6, paint);
    canvas.drawCircle(Offset(center.dx + radius * 0.4, center.dy - radius * 0.2), radius * 0.5, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
