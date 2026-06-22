import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journeyplus/core/theme/app_colors.dart';
import 'package:journeyplus/core/theme/app_text_styles.dart';
import 'package:journeyplus/core/widgets/app_top_bar.dart';
import 'package:journeyplus/features/auth/presentation/providers/auth_providers.dart';
import 'package:journeyplus/features/profile/presentation/view/about_journeyplus_screen.dart';
import 'package:journeyplus/features/profile/presentation/view/privacy_policy_screen.dart';
import 'package:journeyplus/features/profile/presentation/view/profile_preferences_screen.dart';
import 'package:journeyplus/features/profile/presentation/view/trip_history_screen.dart';
import 'package:journeyplus/features/settings/presentation/view/settings_screen.dart';
import 'package:journeyplus/features/trip/presentation/controller/trip_providers.dart';

/// Profile hub — menus for preferences, history, and privacy disclosures.
class ProfileTabScreen extends ConsumerWidget {
  const ProfileTabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userAppStateProvider);
    final historyCount = ref.watch(tripHistoryProvider).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: AppTopBar(title: 'Profile', showMenu: false),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: _Header(
                  displayName: user?.displayName,
                  email: user?.email,
                  photoUrl: user?.photoUrl,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
              sliver: SliverList(
                delegate: SliverChildListDelegate.fixed([
                  Text(
                    'ACCOUNT',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textTertiary,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _MenuTile(
                    icon: Icons.tune,
                    title: 'Trip preferences',
                    subtitle: 'Vehicle, food & safety defaults',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const ProfilePreferencesScreen(),
                      ),
                    ),
                  ),
                  _MenuTile(
                    icon: Icons.history,
                    title: 'Trip history',
                    subtitle: historyCount == 0
                        ? 'On this device only'
                        : '$historyCount completed trip${historyCount == 1 ? '' : 's'}',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const TripHistoryScreen(),
                      ),
                    ),
                  ),
                  // P2-053 — App-level settings (units, alert mutes).
                  _MenuTile(
                    icon: Icons.settings_outlined,
                    title: 'Settings',
                    subtitle: 'Units, alerts, notifications',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const SettingsScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'TRUST & LEGAL',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textTertiary,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _MenuTile(
                    icon: Icons.shield_outlined,
                    title: 'Privacy & location',
                    subtitle: 'How we use GPS — and what we never store',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const PrivacyPolicyScreen(),
                      ),
                    ),
                  ),
                  _MenuTile(
                    icon: Icons.info_outline,
                    title: 'About JourneyPlus',
                    subtitle: 'Product overview & data practices',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const AboutJourneyPlusScreen(),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({this.displayName, this.email, this.photoUrl});

  final String? displayName;
  final String? email;
  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.primarySurface,
            backgroundImage: photoUrl != null && photoUrl!.isNotEmpty
                ? NetworkImage(photoUrl!)
                : null,
            child: photoUrl == null || photoUrl!.isEmpty
                ? const Icon(Icons.person, size: 28, color: AppColors.primary)
                : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(displayName ?? 'Driver', style: AppTextStyles.titleMedium),
                if (email != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    email!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: AppColors.primary, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTextStyles.titleSmall),
                      Text(
                        subtitle,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.textTertiary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
