import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:journeyplus/core/theme/app_colors.dart';
import 'package:journeyplus/core/theme/app_text_styles.dart';
import 'package:journeyplus/features/auth/data/auth_repository.dart';
import 'package:journeyplus/features/auth/presentation/providers/auth_providers.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
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

  bool _googleBusy = false;

  Future<void> _onGoogleSignIn() async {
    setState(() => _googleBusy = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(authRepositoryProvider).signInWithGoogle();
    } on AuthCanceledException {
      // User closed the sheet — no message.
    } on GoogleSignInException catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(e.description ?? 'Google sign-in failed')),
      );
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('$e')));
    } finally {
      if (mounted) setState(() => _googleBusy = false);
    }
  }

  // Phone / OTP entry (disabled for MVP — Google sign-in only).
  // void _onPhoneSignIn() {
  //   Navigator.of(context).push<void>(
  //     MaterialPageRoute<void>(
  //       builder: (context) => const PhoneSignInScreen(),
  //     ),
  //   );
  // }

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
                          'JourneyPlus',
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
                          'JourneyPlus predicts charging gaps\non your route so you can travel\nwithout anxiety.',
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

                    // Sign-in: Google only (phone OTP UI commented for MVP).
                    FadeTransition(
                      opacity: _ctaFade,
                      child: SlideTransition(
                        position: _ctaSlide,
                        child: Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: FilledButton.icon(
                                onPressed: _googleBusy ? null : _onGoogleSignIn,
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: AppColors.textOnDark,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                icon: _googleBusy
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColors.textOnDark,
                                        ),
                                      )
                                    : const Icon(Icons.login, size: 22),
                                label: const Text('Continue with Google'),
                              ),
                            ),
                            // SizedBox(height: 12),
                            // SizedBox(
                            //   width: double.infinity,
                            //   height: 52,
                            //   child: FilledButton.icon(
                            //     onPressed: _onPhoneSignIn,
                            //     style: FilledButton.styleFrom(
                            //       backgroundColor: AppColors.primary,
                            //       foregroundColor: AppColors.textOnDark,
                            //       shape: RoundedRectangleBorder(
                            //         borderRadius: BorderRadius.circular(14),
                            //       ),
                            //     ),
                            //     icon: const Icon(Icons.sms_outlined, size: 22),
                            //     label: const Text('Continue with phone (OTP)'),
                            //   ),
                            // ),
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
