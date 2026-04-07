import 'package:flutter/material.dart';
import 'package:tripplus/core/theme/app_colors.dart';
import 'package:tripplus/core/theme/app_text_styles.dart';
import 'package:tripplus/core/widgets/app_top_bar.dart';
import 'package:tripplus/features/charging/domain/models/charging_station.dart';
import 'package:tripplus/features/community/presentation/widgets/community_reports_section.dart';

class StationDetailScreen extends StatefulWidget {
  final ChargingStation station;

  const StationDetailScreen({super.key, required this.station});

  @override
  State<StationDetailScreen> createState() => _StationDetailScreenState();
}

class _StationDetailScreenState extends State<StationDetailScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  ChargingStation get station => widget.station;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  String _formatCost(String? raw) {
    if (raw == null || raw.isEmpty) return 'NA';
    if (raw.contains('₹') || raw.contains('INR')) return raw;
    final numMatch = RegExp(r'[\d.]+').firstMatch(raw);
    if (numMatch != null) {
      final val = double.tryParse(numMatch.group(0) ?? '');
      if (val != null) return '₹${val.toStringAsFixed(2)} / kWh';
    }
    return raw;
  }

  String _na(String? val) =>
      (val != null && val.isNotEmpty) ? val : 'NA';

  @override
  Widget build(BuildContext context) {
    final dist = station.distanceKm ?? 0;
    final connCount = station.connections.length;
    final availCount =
        station.connections.where((c) => c.isOperational == true).length;
    final hasFast = station.connections.any((c) => c.isFastCharge == true);
    final maxPower = station.connections.fold<double>(
      0,
      (m, c) => (c.powerKw ?? 0) > m ? (c.powerKw ?? 0) : m,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                const SizedBox(height: 8),
                AppTopBar(
                    title: 'Station Details',
                    showBack: true,
                    onBack: () => Navigator.pop(context)),
                const SizedBox(height: 12),

                _HeroCard(
                  name: station.name,
                  distance: dist,
                  hasFast: hasFast,
                  isVerified: station.isRecentlyVerified == true,
                ),
                const SizedBox(height: 24),

                // Data source indicator
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Icon(
                        station.dataSource == 'google'
                            ? Icons.map_outlined
                            : Icons.public,
                        size: 14,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Source: ${station.dataSource == 'google' ? 'Google Maps' : 'Open Charge Map'}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textTertiary,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Operator: ${_na(station.operatorName)}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textTertiary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Community Reports
                CommunityReportsSection(station: station),
                const SizedBox(height: 16),

                // User quote
                if (station.generalComments != null &&
                    station.generalComments!.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '"${station.generalComments}"',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontStyle: FontStyle.italic,
                        height: 1.6,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),

                // Navigate card
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.successSurface,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'READY TO GO?',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textTertiary,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Fastest route\nidentified.',
                        style: AppTextStyles.h3.copyWith(height: 1.2),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Estimated arrival in ${(dist / 1.3).round()} mins.',
                        style: AppTextStyles.bodyMedium,
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(color: AppColors.primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          icon: const Icon(Icons.navigation, size: 18),
                          label: const Text(
                            'Start Navigation',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Station Info
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'STATION INFORMATION',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textTertiary,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                _InfoRow(
                  icon: Icons.electrical_services,
                  title: connCount > 0
                      ? '$connCount ${_connectorType()} Connector${connCount > 1 ? 's' : ''}'
                      : 'Connectors: NA',
                  subtitle:
                      maxPower > 0 ? 'Up to ${maxPower.round()} kW' : 'Power: NA',
                  trailing: connCount > 0 ? '$availCount Available' : 'NA',
                ),
                _InfoRow(
                  icon: Icons.location_on_outlined,
                  title: _na(station.address),
                  subtitle: _na(
                    [station.town, station.stateOrProvince]
                        .where((s) => s != null && s.isNotEmpty)
                        .join(', '),
                  ),
                ),
                _InfoRow(
                  icon: Icons.currency_rupee,
                  title: _formatCost(station.usageCost),
                  subtitle: station.usageType ?? 'NA',
                  trailingIcon: Icons.info_outline,
                ),
                _InfoRow(
                  icon: Icons.verified_outlined,
                  title: station.dateLastVerified != null
                      ? 'Last verified: ${station.dateLastVerified}'
                      : 'Verification: NA',
                  subtitle: station.isRecentlyVerified == true
                      ? 'Recently verified'
                      : null,
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _connectorType() {
    if (station.connections.isEmpty) return '';
    final first = station.connections.first;
    return first.connectionType ?? 'CCS';
  }
}

class _HeroCard extends StatelessWidget {
  final String name;
  final double distance;
  final bool hasFast;
  final bool isVerified;

  const _HeroCard({
    required this.name,
    required this.distance,
    required this.hasFast,
    required this.isVerified,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.greenGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              if (hasFast)
                _HeroBadge(
                  label: 'HIGH SPEED',
                  color: Colors.white.withValues(alpha: 0.2),
                ),
              if (isVerified)
                _HeroBadge(
                  icon: Icons.check_circle,
                  label: 'VERIFIED',
                  color: Colors.white.withValues(alpha: 0.2),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: AppTextStyles.h2.copyWith(
              color: AppColors.textOnDark,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            '${distance.toStringAsFixed(1)} km from current location',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroBadge extends StatelessWidget {
  final IconData? icon;
  final String label;
  final Color color;

  const _HeroBadge({
    this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: AppColors.textOnDark),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.textOnDark,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? trailing;
  final IconData? trailingIcon;

  const _InfoRow({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: AppColors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
              ],
            ),
          ),
          if (trailing != null)
            Text(
              trailing!,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          if (trailingIcon != null)
            Icon(trailingIcon, size: 18, color: AppColors.textTertiary),
        ],
      ),
    );
  }
}
