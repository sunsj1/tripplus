import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journeyplus/core/theme/app_colors.dart';
import 'package:journeyplus/core/theme/app_text_styles.dart';
import 'package:journeyplus/core/widgets/fuel_brand_picker.dart';
import 'package:journeyplus/features/profile/presentation/controller/profile_providers.dart';
import 'package:journeyplus/features/profile/presentation/controller/profile_ui_state.dart';
import 'package:journeyplus/features/profile/presentation/widget/preferences_chips.dart';
import 'package:journeyplus/features/profile/presentation/widget/vehicle_picker.dart';

/// First-time setup. Shown by [VehicleSetupGate] when a signed-in user has no
/// vehicle yet. On save, the gate flips to render the AppShell.
class ProfileSetupScreen extends ConsumerWidget {
  const ProfileSetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileControllerProvider);
    final controller = ref.read(profileControllerProvider.notifier);
    final data = state.data;
    final saving = state is ProfileSaving;
    final canSave = data.vehicle != null && !saving;

    ref.listen(profileControllerProvider, (prev, next) {
      if (next is ProfileErrored) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not save: ${next.failure.message}')),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Set up your trip profile', style: AppTextStyles.h2),
              const SizedBox(height: 8),
              Text(
                'JourneyPlus uses this to plan smarter routes, surface the right stops, and warn you ahead.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),
              VehiclePicker(
                selected: data.vehicle,
                onChanged: controller.updateDraftVehicle,
              ),
              FuelBrandSection(
                vehicleType: data.vehicle?.type,
                preferences: data.preferences,
                onChanged: controller.updateDraftPreferences,
              ),
              PreferencesChips(
                value: data.preferences,
                vehicleType: data.vehicle?.type,
                onChanged: controller.updateDraftPreferences,
              ),
              const SizedBox(height: 36),
              SizedBox(
                height: 56,
                child: FilledButton(
                  onPressed: canSave ? () => controller.save() : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: AppColors.border,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: saving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.textOnDark,
                          ),
                        )
                      : Text(
                          'Save and continue',
                          style: AppTextStyles.button.copyWith(
                            color: AppColors.textOnDark,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 8),
              if (data.vehicle == null)
                Text(
                  'Pick a vehicle to continue.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
