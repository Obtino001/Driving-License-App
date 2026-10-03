import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/editorial_header.dart';
import '../../../core/utils/haptics.dart';
import '../application/settings_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
          children: [
            const EditorialHeader(
              title: 'SETTINGS',
              subtitle: 'Preferences and details.',
            ),
            const SizedBox(height: 24),
            _SectionHeader('STUDY'),
            _SettingsRow(
              label: 'Daily goal',
              value: '10 questions',
            ),
            _SettingsRow(
              label: 'Test date',
              value: 'This week',
            ),
            _SettingsRow(
              label: 'License type',
              value: 'California Class C',
            ),
            const SizedBox(height: 32),
            _SectionHeader('EXPERIENCE'),
            _SettingsToggleRow(
              label: 'Haptics',
              value: controller.hapticsEnabled,
              onChanged: (_) {
                AppHaptics.selection();
                controller.toggleHaptics();
              },
            ),
            _SettingsToggleRow(
              label: 'Reduced motion',
              value: controller.reducedMotionEnabled,
              onChanged: (_) {
                AppHaptics.selection();
                controller.toggleReducedMotion();
              },
            ),
            const SizedBox(height: 32),
            _SectionHeader('DATA'),
            _SettingsActionRow(
              label: 'Reset study progress',
              isDestructive: true,
              onTap: () async {
                AppHaptics.buttonPress();
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Reset Progress?'),
                    content: const Text(
                        'This will permanently delete your practice history and mistakes.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text('Reset',
                            style: TextStyle(color: AppColors.danger)),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  await controller.resetProgress();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Progress reset successfully.')),
                    );
                  }
                }
              },
            ),
            const SizedBox(height: 32),
            _SectionHeader('ABOUT'),
            const _SettingsRow(
              label: 'App version',
              value: '1.0.0',
            ),
            _SettingsActionRow(
              label: 'Independent study disclaimer',
              onTap: () {},
            ),
            _SettingsActionRow(
              label: 'Privacy policy',
              onTap: () {},
            ),
            _SettingsActionRow(
              label: 'Terms of service',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.textTertiary,
              letterSpacing: 1.2,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.textTertiary.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }
}

class _SettingsActionRow extends StatelessWidget {
  const _SettingsActionRow({
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.textTertiary.withOpacity(0.1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: isDestructive ? AppColors.danger : AppColors.textPrimary,
                  ),
            ),
            Icon(
              PhosphorIcons.caretRight(),
              size: 18,
              color: isDestructive ? AppColors.danger : AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsToggleRow extends StatelessWidget {
  const _SettingsToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.textTertiary.withOpacity(0.1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodyLarge),
            _CustomSwitch(value: value),
          ],
        ),
      ),
    );
  }
}

class _CustomSwitch extends StatelessWidget {
  const _CustomSwitch({required this.value});
  final bool value;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      width: 48,
      height: 28,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: value ? AppColors.primaryDark : AppColors.textTertiary.withOpacity(0.2),
      ),
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
