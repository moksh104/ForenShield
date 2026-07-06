import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/password_field.dart';
import '../../../../core/widgets/search_field.dart';
import '../../../../core/widgets/multiline_field.dart';

class FormsShowcasePage extends StatelessWidget {
  const FormsShowcasePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Forms Showcase'),
        backgroundColor: AppColors.surface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppTextField(
              label: 'Standard Input',
              hint: 'Enter your username',
              helperText: 'Must be unique.',
              showClearButton: true,
            ),
            const SizedBox(height: AppSpacing.xl),
            const AppTextField(
              label: 'Success Input',
              hint: 'Valid input',
              isSuccess: true,
            ),
            const SizedBox(height: AppSpacing.xl),
            const AppTextField(
              label: 'Disabled Input',
              hint: 'You cannot edit this',
              enabled: false,
            ),
            const SizedBox(height: AppSpacing.xl),
            const PasswordField(
              label: 'Password',
              showStrengthIndicator: true,
              strength: 0.7,
              requirements: [
                'At least 8 characters',
                'One uppercase letter',
                'One number or symbol',
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            const SearchField(
              hint: 'Search evidence...',
            ),
            const SizedBox(height: AppSpacing.xl),
            const SearchField(
              hint: 'Searching...',
              isLoading: true,
            ),
            const SizedBox(height: AppSpacing.xl),
            const MultilineField(
              label: 'Case Notes',
              hint: 'Enter detailed observations here...',
              maxLength: 500,
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}
