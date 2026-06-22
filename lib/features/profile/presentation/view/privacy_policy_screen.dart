import 'package:flutter/material.dart';
import 'package:journeyplus/core/theme/app_colors.dart';
import 'package:journeyplus/core/theme/app_text_styles.dart';

/// In-app privacy & location intelligence disclosure (App Store / Play checklist).
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        title: Text('Privacy & location', style: AppTextStyles.titleMedium),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: const [
            _Section(
              title: 'Our promise',
              body:
                  'JourneyPlus is a highway companion — not a location tracker. '
                  'We help you plan routes and surface predictive stops using '
                  'intelligence for your current drive. We do not build or sell '
                  'a history of where you have been.',
            ),
            _Section(
              title: 'Location on your device',
              body:
                  'When you start a trip, the app may read GPS on your phone to '
                  'power predictive alerts (fuel gaps, food windows, chargers). '
                  'That position is used in real time for calculations and Google '
                  'Maps / Places requests during the session.\n\n'
                  'We do not upload GPS coordinates or location trails to JourneyPlus '
                  'servers. Firebase stores your profile, preferences, and '
                  'community reports — not your movement history.',
            ),
            _Section(
              title: 'Google APIs',
              body:
                  'Routing, places, and corridor search use Google Maps Platform '
                  'APIs. When you plan or drive, route queries and nearby-place '
                  'lookups may send origin/destination or current position to Google '
                  'under their terms. JourneyPlus does not store those coordinates in '
                  'our database.',
            ),
            _Section(
              title: 'Trip history (on device)',
              body:
                  'When you end a trip, a summary is saved locally on your phone: '
                  'city names (e.g. Mumbai → Pune), distance, duration, vehicle '
                  'type, and alert counts. No GPS path is kept. Clearing app data '
                  'removes this history.',
            ),
            _Section(
              title: 'Community reports',
              body:
                  'If you submit a community pulse at a stop, we store the report '
                  'on Firebase linked to that place’s stable key — not a log of '
                  'your location over time. Reports are immutable and public-read.',
            ),
            _Section(
              title: 'Your controls',
              body:
                  '• Deny location permission — planning still works; live alerts '
                  'and foreground tracking are limited.\n'
                  '• End trip anytime — stops live location use for that session.\n'
                  '• Sign out — clears your session; profile data remains in Firebase '
                  'until you delete your account through support.\n'
                  '• Uninstall — removes on-device trip history and caches.',
            ),
            _Section(
              title: 'Contact',
              body:
                  'Questions before publishing or while driving? Reach the JourneyPlus '
                  'team through the support channel listed on the store listing.',
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.titleSmall),
          const SizedBox(height: 8),
          Text(
            body,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}
