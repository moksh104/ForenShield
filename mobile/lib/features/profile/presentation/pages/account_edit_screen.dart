import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../../../core/validators/form_validators.dart';
import '../providers/profile_provider.dart';

/// Account Management Screen: Edit Profile, Avatar Picker, Change Password, Active Session Info & Logout.
class AccountEditScreen extends ConsumerStatefulWidget {
  const AccountEditScreen({super.key});

  @override
  ConsumerState<AccountEditScreen> createState() => _AccountEditScreenState();
}

class _AccountEditScreenState extends ConsumerState<AccountEditScreen> {
  final _profileFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _bioController = TextEditingController();
  final _phoneController = TextEditingController();

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  bool _isSavingProfile = false;
  bool _isSavingPassword = false;
  bool _isLoggingOut = false;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(profileProvider).profile;
    if (profile != null) {
      _nameController.text = profile.fullName;
      _emailController.text = profile.email;
      _bioController.text = profile.bio;
      _phoneController.text = profile.phone;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    _phoneController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  void _showAvatarOptionsBottomSheet(String currentAvatarUrl) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final primaryColor = theme.colorScheme.primary;
    final criticalColor = foren.critical.t500;
    final hasAvatar = currentAvatarUrl.isNotEmpty;

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: foren.borderSubtle,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Profile Picture Options',
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: Icon(Icons.camera_alt_outlined, color: primaryColor),
                title: Text(
                  'Camera',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 14,
                  ),
                ),
                onTap: () async {
                  Navigator.pop(ctx);
                  await _pickImageSource(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.photo_library_outlined,
                  color: primaryColor,
                ),
                title: Text(
                  'Gallery',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 14,
                  ),
                ),
                onTap: () async {
                  Navigator.pop(ctx);
                  await _pickImageSource(ImageSource.gallery);
                },
              ),
              if (hasAvatar)
                ListTile(
                  leading: Icon(Icons.delete_outline, color: criticalColor),
                  title: Text(
                    'Remove Photo',
                    style: TextStyle(
                      color: criticalColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(ctx);
                    await ref.read(profileProvider.notifier).removeAvatar();
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Profile picture removed'),
                        backgroundColor: foren.info.t500,
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImageSource(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      if (image == null) return;

      await ref.read(profileProvider.notifier).updateAvatar(image.path);
      if (!mounted) return;

      final foren = Theme.of(context).extension<ForenColors>()!;
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Profile picture updated'),
          backgroundColor: foren.success.t500,
        ),
      );
    } catch (_) {}
  }

  Future<void> _handleSaveProfile() async {
    if (!_profileFormKey.currentState!.validate()) return;
    setState(() => _isSavingProfile = true);

    final useCase = ref.read(updateProfileUseCaseProvider);
    final result = await useCase(
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      bio: _bioController.text.trim(),
      phone: _phoneController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isSavingProfile = false);

    final foren = Theme.of(context).extension<ForenColors>()!;

    result.when(
      success: (updated) {
        ref.read(profileProvider.notifier).loadProfile();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Profile details updated & persisted!'),
            backgroundColor: foren.success.t500,
          ),
        );
      },
      failure: (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: foren.critical.t500,
          ),
        );
      },
    );
  }

  Future<void> _handleChangePassword() async {
    if (!_passwordFormKey.currentState!.validate()) return;
    setState(() => _isSavingPassword = true);

    final repo = ref.read(profileRepositoryProvider);
    final result = await repo.changePassword(
      currentPassword: _currentPasswordController.text,
      newPassword: _newPasswordController.text,
    );

    if (!mounted) return;
    setState(() => _isSavingPassword = false);

    final foren = Theme.of(context).extension<ForenColors>()!;

    result.when(
      success: (_) {
        _currentPasswordController.clear();
        _newPasswordController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Password changed successfully!'),
            backgroundColor: foren.success.t500,
          ),
        );
      },
      failure: (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: foren.critical.t500,
          ),
        );
      },
    );
  }

  Future<void> _handleLogout() async {
    setState(() => _isLoggingOut = true);
    final logoutUseCase = ref.read(logoutUseCaseProvider);
    await logoutUseCase();
    // AuthGuard will automatically redirect to Login Screen
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final primaryColor = theme.colorScheme.primary;
    final criticalColor = foren.critical.t500;

    final profile = ref.watch(profileProvider).profile;
    final avatarUrl = profile?.avatarUrl ?? '';
    final initials = (profile?.fullName ?? 'Agent').isNotEmpty
        ? profile!.fullName
              .trim()
              .split(' ')
              .map((e) => e[0])
              .take(2)
              .join()
              .toUpperCase()
        : 'A';

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          color: theme.colorScheme.onSurface,
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Account & Session Management',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar Picker Header
              Center(
                child: GestureDetector(
                  onTap: () => _showAvatarOptionsBottomSheet(avatarUrl),
                  child: Stack(
                    children: [
                      Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: primaryColor, width: 2),
                        ),
                        child: ClipOval(
                          child: _buildAvatarWidget(
                            avatarUrl,
                            initials,
                            primaryColor,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.camera_alt_outlined,
                            size: 16,
                            color: theme.scaffoldBackgroundColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Edit Profile Section
              Text(
                'Edit Profile Details',
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Form(
                key: _profileFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      validator: FormValidators.username,
                      style: TextStyle(color: theme.colorScheme.onSurface),
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        filled: true,
                        fillColor: foren.surfaceRaised1,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextFormField(
                      controller: _emailController,
                      validator: FormValidators.email,
                      style: TextStyle(color: theme.colorScheme.onSurface),
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        filled: true,
                        fillColor: foren.surfaceRaised1,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextFormField(
                      controller: _bioController,
                      style: TextStyle(color: theme.colorScheme.onSurface),
                      decoration: InputDecoration(
                        labelText: 'Bio / Title',
                        filled: true,
                        fillColor: foren.surfaceRaised1,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextFormField(
                      controller: _phoneController,
                      style: TextStyle(color: theme.colorScheme.onSurface),
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        filled: true,
                        fillColor: foren.surfaceRaised1,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: _isSavingProfile ? null : _handleSaveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: theme.scaffoldBackgroundColor,
                        ),
                        child: _isSavingProfile
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Save Details'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Change Password Section
              Text(
                'Security: Change Password',
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Form(
                key: _passwordFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _currentPasswordController,
                      obscureText: true,
                      validator: FormValidators.password,
                      style: TextStyle(color: theme.colorScheme.onSurface),
                      decoration: InputDecoration(
                        labelText: 'Current Password',
                        filled: true,
                        fillColor: foren.surfaceRaised1,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextFormField(
                      controller: _newPasswordController,
                      obscureText: true,
                      validator: FormValidators.password,
                      style: TextStyle(color: theme.colorScheme.onSurface),
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        filled: true,
                        fillColor: foren.surfaceRaised1,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: _isSavingPassword
                            ? null
                            : _handleChangePassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: foren.simulation.t500,
                          foregroundColor: theme.colorScheme.onSurface,
                        ),
                        child: _isSavingPassword
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Update Password'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Active Session Information
              Text(
                'Active Session Information',
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: AppRadius.borderRadiusMd,
                  border: Border.all(
                    color: foren.borderSubtle.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Session Type: JWT Authenticated',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Device: Mobile / Web Client · Token Valid',
                      style: TextStyle(color: foren.textDisabled, fontSize: 11),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Working Logout Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: _isLoggingOut ? null : _handleLogout,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: criticalColor,
                    side: BorderSide(color: criticalColor, width: 1),
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppRadius.borderRadiusMd,
                    ),
                  ),
                  icon: const Icon(Icons.logout, size: 18),
                  label: _isLoggingOut
                      ? SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            color: criticalColor,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Logout Session',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarWidget(
    String avatarUrl,
    String initials,
    Color primaryColor,
  ) {
    if (avatarUrl.isNotEmpty) {
      if (kIsWeb || avatarUrl.startsWith('http')) {
        return Image.network(
          avatarUrl,
          fit: BoxFit.cover,
          errorBuilder: (ctx, err, stack) =>
              _buildInitials(initials, primaryColor),
        );
      } else {
        final file = File(avatarUrl);
        if (file.existsSync()) {
          return Image.file(
            file,
            fit: BoxFit.cover,
            errorBuilder: (ctx, err, stack) =>
                _buildInitials(initials, primaryColor),
          );
        }
      }
    }
    return _buildInitials(initials, primaryColor);
  }

  Widget _buildInitials(String initials, Color primaryColor) {
    return Container(
      color: primaryColor,
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
