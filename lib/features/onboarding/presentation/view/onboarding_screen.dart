import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tripplus/core/theme/app_colors.dart';
import 'package:tripplus/core/theme/app_text_styles.dart';
import 'package:tripplus/features/shell/presentation/view/app_shell.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late final AnimationController _bgController;
  late final AnimationController _contentController;
  late final AnimationController _pulseController;

  late final Animation<double> _bgFade;
  late final Animation<double> _logoFade;
  late final Animation<double> _headlineFade;
  late final Animation<Offset> _headlineSlide;
  late final Animation<double> _bodyFade;
  late final Animation<Offset> _bodySlide;
  late final Animation<double> _pillsFade;
  late final Animation<Offset> _pillsSlide;
  late final Animation<double> _ctaFade;
  late final Animation<Offset> _ctaSlide;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _bgFade = CurvedAnimation(
      parent: _bgController,
      curve: const Interval(0, 0.5, curve: Curves.easeOut),
    );

    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _logoFade = CurvedAnimation(
      parent: _contentController,
      curve: const Interval(0, 0.2, curve: Curves.easeOut),
    );

    _headlineFade = CurvedAnimation(
      parent: _contentController,
      curve: const Interval(0.15, 0.4, curve: Curves.easeOut),
    );
    _headlineSlide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _contentController,
      curve: const Interval(0.15, 0.45, curve: Curves.easeOutCubic),
    ));

    _bodyFade = CurvedAnimation(
      parent: _contentController,
      curve: const Interval(0.3, 0.55, curve: Curves.easeOut),
    );
    _bodySlide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _contentController,
      curve: const Interval(0.3, 0.6, curve: Curves.easeOutCubic),
    ));

    _pillsFade = CurvedAnimation(
      parent: _contentController,
      curve: const Interval(0.45, 0.7, curve: Curves.easeOut),
    );
    _pillsSlide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _contentController,
      curve: const Interval(0.45, 0.75, curve: Curves.easeOutCubic),
    ));

    _ctaFade = CurvedAnimation(
      parent: _contentController,
      curve: const Interval(0.65, 0.9, curve: Curves.easeOut),
    );
    _ctaSlide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _contentController,
      curve: const Interval(0.65, 0.95, curve: Curves.easeOutCubic),
    ));

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _bgController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _contentController.forward();
    });
  }

  @override
  void dispose() {
    _bgController.dispose();
    _contentController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AppShell(),
        transitionsBuilder: (context, anim, secondaryAnim, child) =>
            FadeTransition(
          opacity: CurvedAnimation(parent: anim, curve: Curves.easeIn),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.tealGradient),
        child: SafeArea(
          child: Stack(
            children: [
              // Animated background art
              FadeTransition(
                opacity: _bgFade,
                child: AnimatedBuilder(
                  animation: _pulseAnim,
                  builder: (context, child) => CustomPaint(
                    painter: _TealBackgroundPainter(pulse: _pulseAnim.value),
                    size: Size.infinite,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // Logo
                    FadeTransition(
                      opacity: _logoFade,
                      child: const Center(
                        child: Text(
                          'TripPlus',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textOnDark,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),

                    const Spacer(flex: 2),

                    // Headline
                    FadeTransition(
                      opacity: _headlineFade,
                      child: SlideTransition(
                        position: _headlineSlide,
                        child: Text(
                          'Know what\nlies ahead.',
                          style: AppTextStyles.h1.copyWith(
                            color: AppColors.textOnDark,
                            fontSize: 36,
                            height: 1.1,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Body
                    FadeTransition(
                      opacity: _bodyFade,
                      child: SlideTransition(
                        position: _bodySlide,
                        child: Text(
                          'TripPlus predicts charging gaps\non your route so you can travel\nwithout anxiety.',
                          style: AppTextStyles.bodyLarge.copyWith(
                            color:
                                AppColors.textOnDark.withValues(alpha: 0.85),
                            height: 1.6,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Feature pills
                    FadeTransition(
                      opacity: _pillsFade,
                      child: SlideTransition(
                        position: _pillsSlide,
                        child: Row(
                          children: const [
                            _FeaturePill(
                              icon: Icons.route,
                              label: 'PRECISION\nPATH',
                            ),
                            SizedBox(width: 12),
                            _FeaturePill(
                              icon: Icons.grid_view_rounded,
                              label: 'LIVE\nINSIGHTS',
                            ),
                          ],
                        ),
                      ),
                    ),

                    const Spacer(flex: 3),

                    // CTA
                    FadeTransition(
                      opacity: _ctaFade,
                      child: SlideTransition(
                        position: _ctaSlide,
                        child: Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: _AnimatedCTA(
                                onPressed: _navigateToHome,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Center(
                              child: TextButton(
                                onPressed: _navigateToHome,
                                child: Text(
                                  'Sign In',
                                  style: AppTextStyles.titleSmall.copyWith(
                                    color: AppColors.textOnDark
                                        .withValues(alpha: 0.7),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Animated "Get Started" button with scale feedback
// ---------------------------------------------------------------------------
class _AnimatedCTA extends StatefulWidget {
  final VoidCallback onPressed;
  const _AnimatedCTA({required this.onPressed});

  @override
  State<_AnimatedCTA> createState() => _AnimatedCTAState();
}

class _AnimatedCTAState extends State<_AnimatedCTA>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scaleCtrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _scaleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0,
      upperBound: 1,
    );
    _scale = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _scaleCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _scaleCtrl.forward(),
      onTapUp: (_) {
        _scaleCtrl.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _scaleCtrl.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (context, child) => Transform.scale(
          scale: _scale.value,
          child: child,
        ),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Text(
            'Get Started',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.textOnDark,
            ),
          ),
        ),
      ),
    );
  }
}

class _FeaturePill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeaturePill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.textOnDark, size: 22),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
              color: AppColors.textOnDark,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _TealBackgroundPainter extends CustomPainter {
  final double pulse;
  _TealBackgroundPainter({this.pulse = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    paint.color = Colors.white.withValues(alpha: 0.06 * pulse);
    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.15),
      size.width * 0.5 * pulse,
      paint,
    );

    paint.color = Colors.white.withValues(alpha: 0.04);
    canvas.drawCircle(
      Offset(size.width * 0.1, size.height * 0.55),
      size.width * 0.35,
      paint,
    );

    paint.color = Colors.white.withValues(alpha: 0.08);
    final center = Offset(size.width * 0.5, size.height * 0.22);
    canvas.drawCircle(center, 60 * pulse, paint);

    final boltPath = Path();
    boltPath.moveTo(center.dx - 12, center.dy - 20);
    boltPath.lineTo(center.dx + 4, center.dy - 2);
    boltPath.lineTo(center.dx - 2, center.dy - 2);
    boltPath.lineTo(center.dx + 12, center.dy + 20);
    boltPath.lineTo(center.dx - 4, center.dy + 2);
    boltPath.lineTo(center.dx + 2, center.dy + 2);
    boltPath.close();
    paint.color = Colors.white.withValues(alpha: 0.15);
    canvas.drawPath(boltPath, paint);

    paint.color = Colors.white.withValues(alpha: 0.1);
    final random = Random(42);
    for (int i = 0; i < 20; i++) {
      canvas.drawCircle(
        Offset(
          random.nextDouble() * size.width,
          random.nextDouble() * size.height,
        ),
        random.nextDouble() * 3 + 1,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _TealBackgroundPainter oldDelegate) =>
      oldDelegate.pulse != pulse;
}
