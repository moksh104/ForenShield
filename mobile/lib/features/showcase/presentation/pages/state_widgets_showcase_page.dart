import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_loading_state.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_success_state.dart';
import '../../../../core/widgets/app_button.dart';

class StateWidgetsShowcasePage extends StatefulWidget {
  const StateWidgetsShowcasePage({super.key});

  @override
  State<StateWidgetsShowcasePage> createState() => _StateWidgetsShowcasePageState();
}

class _StateWidgetsShowcasePageState extends State<StateWidgetsShowcasePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('State Widgets Showcase'),
        backgroundColor: AppColors.surface,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              alignment: WrapAlignment.center,
              children: [
                _buildTab('Loading', 0),
                _buildTab('Empty', 1),
                _buildTab('Error', 2),
                _buildTab('Success', 3),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: AppColors.surfaceVariant.withValues(alpha: 0.3),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _buildCurrentState(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    final isSelected = _currentIndex == index;
    return AppButton(
      text: title,
      type: isSelected ? AppButtonType.primary : AppButtonType.secondary,
      fullWidth: false,
      onPressed: () {
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }

  Widget _buildCurrentState() {
    switch (_currentIndex) {
      case 0:
        return SingleChildScrollView(
          child: Column(
            key: const ValueKey('loading'),
            children: [
              const AppLoadingState(
                title: 'Authenticating',
                description: 'Verifying your credentials...',
                size: AppLoadingSize.large,
              ),
              const Divider(),
              const AppLoadingState(
                title: 'Downloading Case Files',
                description: 'Please wait while we retrieve the evidence.',
                progress: 0.65,
                size: AppLoadingSize.medium,
              ),
              const Divider(),
              const AppLoadingState(size: AppLoadingSize.small),
            ],
          ),
        );
      case 1:
        return AppEmptyState(
          key: const ValueKey('empty'),
          title: 'No Evidence Found',
          description: 'There are no items matching your current filters. Try adjusting your search criteria.',
          actionButton: AppButton(
            text: 'Clear Filters',
            type: AppButtonType.secondary,
            fullWidth: false,
            onPressed: () {},
          ),
        );
      case 2:
        return AppErrorState(
          key: const ValueKey('error'),
          description: 'Failed to connect to the secure server. Please check your connection and try again.',
          onRetry: () {},
          secondaryAction: AppButton(
            text: 'Go Back',
            type: AppButtonType.tertiary,
            fullWidth: true,
            onPressed: () {},
          ),
        );
      case 3:
        return AppSuccessState(
          key: const ValueKey('success'),
          title: 'Case Submitted',
          description: 'Your investigation report has been securely uploaded to the central database.',
          continueText: 'View Dashboard',
          onContinue: () {},
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
