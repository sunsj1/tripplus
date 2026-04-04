import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripplus/core/theme/app_colors.dart';
import 'package:tripplus/core/theme/app_text_styles.dart';
import 'package:tripplus/core/widgets/app_top_bar.dart';
import 'package:tripplus/features/plan/presentation/controller/plan_providers.dart';
import 'package:tripplus/features/plan/presentation/controller/plan_state.dart';
import 'package:tripplus/features/plan/presentation/view/calculating_screen.dart';
import 'package:tripplus/features/plan/presentation/view/empty_state_screen.dart';
import 'package:tripplus/features/plan/presentation/view/plan_result_view.dart';
import 'package:tripplus/features/plan/presentation/widget/route_input_card.dart';

class PlanScreen extends ConsumerStatefulWidget {
  const PlanScreen({super.key});

  @override
  ConsumerState<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends ConsumerState<PlanScreen> {
  final _fromController = TextEditingController(text: 'Current Location');
  final _toController = TextEditingController();

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  void _onAnalyze() {
    FocusScope.of(context).unfocus();
    final from = _fromController.text.trim();
    final to = _toController.text.trim();
    if (to.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a destination'),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 80),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }
    ref.read(planControllerProvider.notifier).analyzeRoute(from: from, to: to);
  }

  void _onReset() {
    _toController.clear();
    ref.read(planControllerProvider.notifier).reset();
  }

  void _quickRoute(String from, String to) {
    _fromController.text = from;
    _toController.text = to;
    _onAnalyze();
  }

  @override
  Widget build(BuildContext context) {
    final planState = ref.watch(planControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: switch (planState) {
          PlanIdle() => _buildIdleView(),
          PlanCalculating(:final from, :final to) => CalculatingView(
            from: from,
            to: to,
          ),
          PlanResult(
            :final stations,
            :final from,
            :final to,
            :final totalDistanceKm,
            :final durationMinutes,
            :final gaps,
          ) =>
            PlanResultView(
              from: from,
              to: to,
              stations: stations,
              totalDistanceKm: totalDistanceKm,
              durationMinutes: durationMinutes,
              gaps: gaps,
              onBack: _onReset,
            ),
          PlanEmpty() => EmptyStateScreen(onSearchAgain: _onReset),
          PlanError(:final message) => _buildErrorView(message),
        },
      ),
    );
  }

  Widget _buildIdleView() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const AppTopBar(),
          const SizedBox(height: 24),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Where to next?',
                  style: AppTextStyles.h4.copyWith(color: AppColors.textGreen),
                ),
                const SizedBox(height: 4),
                Text(
                  'Plan your EV journey and find charging\nstations along the route.',
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          RouteInputCard(
            fromController: _fromController,
            toController: _toController,
            placesService: ref.read(placesAutocompleteProvider),
            onAnalyze: _onAnalyze,
          ),
          const SizedBox(height: 28),

          // How it works
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'HOW IT WORKS',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textTertiary,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 14),
          const _HowItWorksRow(),
          const SizedBox(height: 28),

          // Popular routes
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text('Popular Routes', style: AppTextStyles.titleMedium),
                const Spacer(),
                Icon(Icons.trending_up, size: 18, color: AppColors.primary),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _PopularRoutes(onTap: _quickRoute),
          const SizedBox(height: 28),

          // EV tip
          const _EvTipCard(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildErrorView(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 56, color: AppColors.error),
            const SizedBox(height: 20),
            Text(
              'Something went wrong',
              style: AppTextStyles.h4,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: _onReset,
                child: const Text('Try Again'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// How it works - 3 steps
// ---------------------------------------------------------------------------
class _HowItWorksRow extends StatelessWidget {
  const _HowItWorksRow();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: const [
          _StepCard(
            step: '1',
            icon: Icons.edit_location_alt_outlined,
            title: 'Enter\nRoute',
          ),
          SizedBox(width: 10),
          _StepCard(
            step: '2',
            icon: Icons.route_outlined,
            title: 'Analyze\nPath',
          ),
          SizedBox(width: 10),
          _StepCard(
            step: '3',
            icon: Icons.ev_station_outlined,
            title: 'Find\nStations',
          ),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final String step;
  final IconData icon;
  final String title;

  const _StepCard({
    required this.step,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  step,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Icon(icon, size: 24, color: AppColors.primary),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Popular routes
// ---------------------------------------------------------------------------
class _PopularRoutes extends StatelessWidget {
  final void Function(String from, String to) onTap;

  const _PopularRoutes({required this.onTap});

  static const _routes = [
    {'from': 'Mumbai', 'to': 'Pune', 'km': '150'},
    {'from': 'Delhi', 'to': 'Jaipur', 'km': '280'},
    {'from': 'Bangalore', 'to': 'Mysore', 'km': '145'},
    {'from': 'Chennai', 'to': 'Pondicherry', 'km': '150'},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 92,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _routes.length,
        separatorBuilder: (_, index) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final r = _routes[i];
          return GestureDetector(
            onTap: () => onTap(r['from']!, r['to']!),
            child: Container(
              width: 160,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primarySurface,
                    AppColors.primarySurfaceLight,
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.route,
                        size: 14,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '${r['from']} → ${r['to']}',
                          style: AppTextStyles.titleSmall.copyWith(
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        '~${r['km']} km',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
                          size: 12,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// EV tip card
// ---------------------------------------------------------------------------
class _EvTipCard extends StatelessWidget {
  const _EvTipCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.warningSurface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.lightbulb_outline,
              size: 22,
              color: AppColors.warning,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'EV Tip',
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.warning,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Always plan for a 20% battery buffer on long routes to avoid range anxiety.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
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
