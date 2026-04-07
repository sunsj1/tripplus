import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart' as intl_phone;
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:tripplus/core/theme/app_colors.dart';
import 'package:tripplus/core/theme/app_text_styles.dart';
import 'package:tripplus/features/auth/domain/user_profile.dart';
import 'package:tripplus/features/auth/presentation/providers/auth_providers.dart';

String inferAuthProvider(User user) {
  for (final p in user.providerData) {
    if (p.providerId == 'phone') return 'phone';
    if (p.providerId == 'google.com') return 'google';
  }
  return 'unknown';
}

class ProfileFormScreen extends ConsumerStatefulWidget {
  const ProfileFormScreen({
    super.key,
    required this.user,
    this.existingProfile,
    required this.isEditMode,
  });

  final User user;
  final UserProfile? existingProfile;
  final bool isEditMode;

  @override
  ConsumerState<ProfileFormScreen> createState() => _ProfileFormScreenState();
}

class _ProfileFormScreenState extends ConsumerState<ProfileFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _vehicle = TextEditingController();
  final _phoneNational = TextEditingController();

  String? _phoneE164;
  bool _saving = false;
  String _phoneInitialCountry = 'IN';

  @override
  void initState() {
    super.initState();
    _hydrateFields();
  }

  void _hydrateFields() {
    final u = widget.user;
    final e = widget.existingProfile;

    if (e != null) {
      _firstName.text = e.firstName;
      _lastName.text = e.lastName;
      _vehicle.text = e.vehicleName;
      _phoneE164 = e.phoneE164 ?? u.phoneNumber;
    } else {
      final name = u.displayName?.trim();
      if (name != null && name.isNotEmpty) {
        final parts = name.split(RegExp(r'\s+'));
        _firstName.text = parts.first;
        if (parts.length > 1) {
          _lastName.text = parts.sublist(1).join(' ');
        }
      }
      _phoneE164 = u.phoneNumber;
    }

    final raw = _phoneE164;
    if (raw != null && raw.isNotEmpty) {
      try {
        final parsed = PhoneNumber.parse(raw);
        _phoneInitialCountry = parsed.isoCode.name;
        _phoneNational.text = parsed.nsn;
      } catch (_) {}
    }
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _vehicle.dispose();
    _phoneNational.dispose();
    super.dispose();
  }

  String _toE164(intl_phone.PhoneNumber p) {
    final c = p.completeNumber;
    return c.startsWith('+') ? c : '+$c';
  }

  Future<void> _signOut() async {
    await ref.read(authRepositoryProvider).signOut();
  }

  /// Photo URL: saved profile, else Google account picture (no custom upload without Storage).
  String? _resolvedPhotoUrl() {
    final e = widget.existingProfile;
    if (e?.photoUrl != null && e!.photoUrl!.isNotEmpty) return e.photoUrl;
    final g = widget.user.photoURL;
    if (g != null && g.isNotEmpty) return g;
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    String? phoneOut = _phoneE164?.trim();
    if (phoneOut != null && phoneOut.isEmpty) phoneOut = null;

    setState(() => _saving = true);
    try {
      final repo = ref.read(userProfileRepositoryProvider);
      await repo.saveProfile(
        user: widget.user,
        firstName: _firstName.text,
        lastName: _lastName.text,
        phoneE164: phoneOut,
        vehicleName: _vehicle.text,
        photoUrl: _resolvedPhotoUrl(),
        authProvider: inferAuthProvider(widget.user),
      );
      if (!mounted) return;
      if (widget.isEditMode) {
        Navigator.of(context).pop();
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.isEditMode ? 'Profile updated' : 'Welcome to TripPlus!',
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not save: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final networkUrl = _resolvedPhotoUrl();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        title: Text(
          widget.isEditMode ? 'Edit profile' : 'Complete your profile',
          style: AppTextStyles.titleMedium,
        ),
        actions: [
          if (!widget.isEditMode)
            TextButton(
              onPressed: _saving ? null : _signOut,
              child: const Text('Sign out'),
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 52,
                    backgroundColor: AppColors.primarySurface,
                    backgroundImage: networkUrl != null && networkUrl.isNotEmpty
                        ? NetworkImage(networkUrl)
                        : null,
                    child: networkUrl == null || networkUrl.isEmpty
                        ? const Icon(Icons.person, size: 48)
                        : null,
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Profile photo from your Google account',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                TextFormField(
                  controller: _firstName,
                  textCapitalization: TextCapitalization.words,
                  decoration: _fieldDecoration('First name *'),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _lastName,
                  textCapitalization: TextCapitalization.words,
                  decoration: _fieldDecoration('Last name *'),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  key: ValueKey('email_${widget.user.uid}'),
                  initialValue:
                      widget.existingProfile?.email ?? widget.user.email ?? '',
                  readOnly: true,
                  decoration: _fieldDecoration('Email (sign-in account)'),
                ),
                const SizedBox(height: 16),
                IntlPhoneField(
                  decoration: _fieldDecoration(
                    'Mobile number (optional)',
                  ),
                  initialCountryCode: _phoneInitialCountry,
                  disableLengthCheck: false,
                  controller: _phoneNational,
                  onChanged: (intl_phone.PhoneNumber phone) {
                    _phoneE164 = _toE164(phone);
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _vehicle,
                  textCapitalization: TextCapitalization.words,
                  decoration: _fieldDecoration('Vehicle name'),
                ),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: _saving ? null : _submit,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _saving
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(widget.isEditMode ? 'Save changes' : 'Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
