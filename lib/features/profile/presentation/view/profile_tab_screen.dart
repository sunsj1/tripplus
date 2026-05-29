import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripplus/core/theme/app_colors.dart';
import 'package:tripplus/core/theme/app_text_styles.dart';
import 'package:tripplus/core/widgets/app_top_bar.dart';
import 'package:tripplus/features/auth/presentation/providers/auth_providers.dart';
import 'package:tripplus/features/profile/presentation/controller/profile_providers.dart';
import 'package:tripplus/features/profile/presentation/controller/profile_ui_state.dart';
import 'package:tripplus/features/profile/presentation/widget/preferences_chips.dart';
import 'package:tripplus/features/profile/presentation/widget/vehicle_picker.dart';

/// Profile tab in AppShell (`P1-016`). Mirrors [ProfileEditScreen] but doesn't
/// pop on save — the user stays on the tab.
class ProfileTabScreen extends ConsumerWidget {
  const ProfileTabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userAppStateProvider);
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
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
              sliver: SliverList(
                delegate: SliverChildListDelegate.fixed([
                  VehiclePicker(
                    selected: data.vehicle,
                    onChanged: controller.updateDraftVehicle,
                  ),
                  const SizedBox(height: 32),
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
                              }
                            }
                          : null,
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
                              'Save changes',
                              style: AppTextStyles.button.copyWith(
                                color: AppColors.textOnDark,
                              ),
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
                ? const Icon(
                    Icons.person,
                    size: 28,
                    color: AppColors.primary,
                  )
                : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName ?? 'Driver',
                  style: AppTextStyles.titleMedium,
                ),
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
