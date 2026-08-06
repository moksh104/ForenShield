import re

def fix_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    # 1. build backgroundColor
    content = re.sub(
        r'backgroundColor:\s*theme\.brightness == Brightness\.dark\s*\?\s*theme\.scaffoldBackgroundColor\s*:\s*const Color\(0xFFFAFAFC\),',
        r'backgroundColor: theme.scaffoldBackgroundColor,',
        content
    )

    # 2. _buildDashboardContent vars
    content = re.sub(
        r'final isDark = theme\.brightness == Brightness\.dark;\s*final textPrimary = isDark\s*\?\s*AppColors\.textPrimary\s*:\s*const Color\(0xFF0F172A\);\s*final textSecondary = isDark\s*\?\s*AppColors\.textSecondary\s*:\s*const Color\(0xFF64748B\);\s*final primaryColor = AppColors\.primary;',
        r'final foren = theme.extension<ForenColors>() ?? ForenColors.dark;\n    final colorScheme = theme.colorScheme;',
        content
    )

    # 3. AppColors.surface : Colors.white -> colorScheme.surface
    content = re.sub(
        r'color:\s*isDark\s*\?\s*AppColors\.surface\s*:\s*Colors\.white,',
        r'color: colorScheme.surface,',
        content
    )
    
    # 4. AppColors.borderSubtle : const Color(...) -> colorScheme.outlineVariant
    content = re.sub(
        r'color:\s*isDark\s*\?\s*AppColors\.borderSubtle\s*:\s*const Color\(0xFFE2E8F0\),',
        r'color: colorScheme.outlineVariant,',
        content
    )
    
    # 5. BoxShadows
    content = re.sub(
        r'boxShadow:\s*isDark\s*\?\s*\[\]\s*:\s*\[\s*BoxShadow\(\s*color:\s*Colors\.black\.withValues\(alpha:\s*0\.0[23]\),\s*blurRadius:\s*\d+,\s*offset:\s*const Offset\(0,\s*2\),\s*\),\s*\],',
        r'boxShadow: theme.brightness == Brightness.dark\n                  ? []\n                  : [\n                      BoxShadow(\n                        color: colorScheme.shadow.withValues(alpha: 0.05),\n                        blurRadius: 8,\n                        offset: const Offset(0, 2),\n                      ),\n                    ],',
        content
    )

    # 6. Colors.white for texts/icons
    content = re.sub(r'foregroundColor:\s*Colors\.white,', r'foregroundColor: colorScheme.onPrimary,', content)
    content = re.sub(r'color:\s*Colors\.white\.withValues\(alpha:\s*0\.7\),', r'color: colorScheme.onPrimary.withValues(alpha: 0.7),', content)
    content = re.sub(r'color:\s*Colors\.white,', r'color: colorScheme.onPrimary,', content)

    # 7. TextStyle colors
    content = re.sub(r'color:\s*textPrimary,', r'color: colorScheme.onSurface,', content)
    content = re.sub(r'color:\s*textSecondary,', r'color: foren.textSecondary,', content)
    content = re.sub(r'color:\s*primaryColor,', r'color: colorScheme.primary,', content)
    content = re.sub(r'backgroundColor:\s*primaryColor,', r'backgroundColor: colorScheme.primary,', content)

    # 8. specific primaryColor calls
    content = content.replace('primaryColor', 'colorScheme.primary')

    # 9. AppColors.surfaceRaised1 : const Color(0xFFE2E8F0)
    content = re.sub(
        r'backgroundColor:\s*isDark\s*\?\s*AppColors\.surfaceRaised1\s*:\s*const Color\(0xFFE2E8F0\),',
        r'backgroundColor: foren.surfaceRaised1,',
        content
    )
    
    # 10. _buildQuickAccessCard args
    content = re.sub(
        r'final isDark = theme\.brightness == Brightness\.dark;\s*final textPrimary = isDark\s*\?\s*AppColors\.textPrimary\s*:\s*const Color\(0xFF0F172A\);\s*final textSecondary = isDark\s*\?\s*AppColors\.textSecondary\s*:\s*const Color\(0xFF64748B\);',
        r'final foren = theme.extension<ForenColors>() ?? ForenColors.dark;\n    final colorScheme = theme.colorScheme;',
        content
    )

    # 11. _buildActivityRow args
    content = re.sub(
        r'final isDark = theme\.brightness == Brightness\.dark;\s*final textPrimary = isDark\s*\?\s*AppColors\.textPrimary\s*:\s*const Color\(0xFF0F172A\);\s*final textSecondary = isDark\s*\?\s*AppColors\.textSecondary\s*:\s*const Color\(0xFF64748B\);\s*final effectiveIconBg = isDark \? iconColor\.withValues\(alpha: 0\.15\) : iconBg;',
        r'final foren = theme.extension<ForenColors>() ?? ForenColors.dark;\n    final colorScheme = theme.colorScheme;\n    final effectiveIconBg = colorScheme.primary.withValues(alpha: 0.15);',
        content
    )
    
    # 12. _WelcomeIllustrationPainter
    content = re.sub(
        r'final bool isDark;',
        r'',
        content
    )
    content = re.sub(
        r'required this\.isDark,',
        r'',
        content
    )
    content = re.sub(
        r'final paintBackground = Paint\(\)\s*\.\.color = isDark \? const Color\(0xFF1E293B\) : const Color\(0xFFF1F5F9\);',
        r'final paintBackground = Paint()..color = colorScheme.outlineVariant.withValues(alpha: 0.5);',
        content
    )
    content = re.sub(
        r'final paintSecondary = Paint\(\)\s*\.\.color = isDark \? const Color\(0xFF334155\) : const Color\(0xFFCBD5E1\);',
        r'final paintSecondary = Paint()..color = colorScheme.outline;',
        content
    )
    
    # fix missing colorScheme in painter
    content = re.sub(
        r'class _WelcomeIllustrationPainter extends CustomPainter {',
        r'class _WelcomeIllustrationPainter extends CustomPainter {\n  final ColorScheme colorScheme;',
        content
    )
    content = re.sub(
        r'const _WelcomeIllustrationPainter\({',
        r'const _WelcomeIllustrationPainter({\n    required this.colorScheme,',
        content
    )
    content = re.sub(
        r'painter: _WelcomeIllustrationPainter\(\s*colorScheme\.primary: colorScheme\.primary,\s*isDark: isDark,\s*\),',
        r'painter: _WelcomeIllustrationPainter(\n                      colorScheme.primary: colorScheme.primary,\n                      colorScheme: colorScheme,\n                    ),',
        content
    )

    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)
    
    print("Done")

fix_file(r'c:\Projects\ForenShield\mobile\lib\features\mission_control\presentation\pages\mission_control_screen.dart')
