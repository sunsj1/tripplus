import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journeyplus/core/theme/app_colors.dart';
import 'package:journeyplus/features/auth/presentation/providers/auth_providers.dart';
import 'package:journeyplus/features/auth/presentation/view/profile_form_screen.dart';
import 'package:journeyplus/features/profile/presentation/view/profile_edit_screen.dart';

enum _ProfileAction { edit, tripPreferences, logout }

class AppTopBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final bool showMenu;
  final bool showBack;
  final bool showProfileMenu;
  final VoidCallback? onBack;

  const AppTopBar({
    super.key,
    this.title = 'JourneyPlus',
    @Deprecated('No drawer is wired — parameter is ignored') this.showMenu = false,
    this.showBack = false,
    this.showProfileMenu = true,
    this.onBack,
  });

  @override
  Size get preferredSize => const Size.fromHeight(52);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentProfileProvider);
    final allowTrailingProfile = showProfileMenu && !showBack;
    final showProfile = allowTrailingProfile && profile != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          if (showBack) ...[
            GestureDetector(
              onTap: onBack ?? () => Navigator.maybePop(context),
              child: const Icon(Icons.arrow_back_ios, size: 20),
            ),
            const SizedBox(width: 12),
          ],
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          if (allowTrailingProfile)
            if (showProfile)
              PopupMenuButton<_ProfileAction>(
                offset: const Offset(0, 44),
                child: _Avatar(photoUrl: profile.photoUrl),
                onSelected: (action) {
                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    if (!context.mounted) return;
                    switch (action) {
                      case _ProfileAction.edit:
                        final user = FirebaseAuth.instance.currentUser;
                        if (user == null) return;
                        await Navigator.of(context).push<void>(
                          MaterialPageRoute<void>(
                            builder: (ctx) => ProfileFormScreen(
                              user: user,
                              existingProfile: profile,
                              isEditMode: true,
                            ),
                          ),
                        );
                      case _ProfileAction.tripPreferences:
                        await Navigator.of(context).push<void>(
                          MaterialPageRoute<void>(
                            builder: (ctx) => const ProfileEditScreen(),
                          ),
                        );
                      case _ProfileAction.logout:
                        await ref.read(authRepositoryProvider).signOut();
                    }
                  });
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: _ProfileAction.edit,
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.edit_outlined, size: 22),
                      title: Text('Edit profile'),
                    ),
                  ),
                  PopupMenuItem(
                    value: _ProfileAction.tripPreferences,
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.tune, size: 22),
                      title: Text('Trip preferences'),
                    ),
                  ),
                  PopupMenuItem(
                    value: _ProfileAction.logout,
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.logout, size: 22),
                      title: Text('Log out'),
                    ),
                  ),
                ],
              )
            else
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primarySurface,
                  border: Border.all(color: AppColors.primary, width: 1.5),
                ),
                child: const Icon(
                  Icons.person,
                  size: 18,
                  color: AppColors.primary,
                ),
              ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({this.photoUrl});

  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primarySurface,
        border: Border.all(color: AppColors.primary, width: 1.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: photoUrl != null && photoUrl!.isNotEmpty
          ? Image.network(
              photoUrl!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.person,
                size: 18,
                color: AppColors.primary,
              ),
            )
          : const Icon(
              Icons.person,
              size: 18,
              color: AppColors.primary,
            ),
    );
  }
}
