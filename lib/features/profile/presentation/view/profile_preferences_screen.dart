import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripplus/core/theme/app_colors.dart';
import 'package:tripplus/core/theme/app_text_styles.dart';
import 'package:tripplus/core/widgets/fuel_brand_picker.dart';
import 'package:tripplus/features/profile/presentation/controller/profile_providers.dart';
import 'package:tripplus/features/profile/presentation/controller/profile_ui_state.dart';
import 'package:tripplus/features/profile/presentation/widget/preferences_chips.dart';
import 'package:tripplus/features/profile/presentation/widget/vehicle_picker.dart';

/// Vehicle + preference editor (pushed from Profile hub).
class ProfilePreferencesScreen extends ConsumerWidget {
  const ProfilePreferencesScreen({super.key});

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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        title: Text('Trip preferences', style: AppTextStyles.titleMedium),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Defaults for every new trip. You can still override on the Plan screen.',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
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
                  onPressed: canSave
                      ? () async {
                          final ok = await controller.save();
                          if (ok && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Preferences saved'),
                              ),
                            );
                            Navigator.of(context).pop();
                          }
                        }
                      : null,
                  child: saving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.textOnDark,
                          ),
                        )
                      : const Text('Save changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
