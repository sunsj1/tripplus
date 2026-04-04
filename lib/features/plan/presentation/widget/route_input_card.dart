import 'package:flutter/material.dart';
import 'package:tripplus/core/services/places_autocomplete_service.dart';
import 'package:tripplus/core/theme/app_colors.dart';
import 'package:tripplus/core/theme/app_text_styles.dart';
import 'package:tripplus/core/widgets/autocomplete_location_field.dart';

class RouteInputCard extends StatelessWidget {
  final TextEditingController fromController;
  final TextEditingController toController;
  final PlacesAutocompleteService placesService;
  final VoidCallback onAnalyze;
  final bool isLoading;

  const RouteInputCard({
    super.key,
    required this.fromController,
    required this.toController,
    required this.placesService,
    required this.onAnalyze,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 30,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'FROM',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: 8),
          AutocompleteLocationField(
            controller: fromController,
            service: placesService,
            icon: Icons.my_location,
            iconColor: AppColors.primary,
            hint: 'Current Location',
          ),
          _DottedConnector(),
          Text(
            'TO',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: 8),
          AutocompleteLocationField(
            controller: toController,
            service: placesService,
            icon: Icons.location_on,
            iconColor: AppColors.primary,
            hint: 'Search destination...',
          ),
          _DottedConnector(),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton(
              onPressed: isLoading ? null : onAnalyze,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isLoading ? 'Analyzing...' : 'Analyze Route',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textOnDark,
                    ),
                  ),
                  if (!isLoading) ...[
                    const SizedBox(width: 8),
                    const Icon(Icons.bolt,
                        size: 20, color: AppColors.textOnDark),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DottedConnector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18),
      child: Column(
        children: List.generate(
          3,
          (_) => Container(
            width: 2,
            height: 6,
            margin: const EdgeInsets.symmetric(vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ),
      ),
    );
  }
}
