/// Profile / Settings screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../app/app.dart';

/// The Profile tab with settings.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0,
              ),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profile',
                      style: theme.textTheme.displaySmall,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Settings & preferences',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // User info card
            SliverPadding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              sliver: SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerLow,
                    borderRadius: AppRadius.borderRadiusLg,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: theme.colorScheme.primaryContainer,
                        child: Text(
                          'Y',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Yasir',
                              style: theme.textTheme.titleMedium,
                            ),
                            Text(
                              'Preparing for Driving Test',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Settings tiles
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              sliver: SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerLow,
                    borderRadius: AppRadius.borderRadiusLg,
                  ),
                  child: Column(
                    children: [
                      _SettingsTile(
                        icon: Icons.palette_rounded,
                        title: 'Theme',
                        trailing: SegmentedButton<ThemeMode>(
                          segments: const [
                            ButtonSegment(
                              value: ThemeMode.system,
                              icon: Icon(Icons.settings_suggest_rounded, size: 18),
                            ),
                            ButtonSegment(
                              value: ThemeMode.light,
                              icon: Icon(Icons.light_mode_rounded, size: 18),
                            ),
                            ButtonSegment(
                              value: ThemeMode.dark,
                              icon: Icon(Icons.dark_mode_rounded, size: 18),
                            ),
                          ],
                          selected: {themeMode},
                          onSelectionChanged: (values) {
                            ref
                                .read(themeModeProvider.notifier)
                                .state = values.first;
                          },
                          style: SegmentedButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                      ),
                      const Divider(indent: 56),
                      _SettingsTile(
                        icon: Icons.location_on_rounded,
                        title: 'Region',
                        subtitle: 'United States',
                        onTap: () {},
                      ),
                      const Divider(indent: 56),
                      _SettingsTile(
                        icon: Icons.flag_rounded,
                        title: 'Daily Goal',
                        subtitle: '10 questions per day',
                        onTap: () {},
                      ),
                      const Divider(indent: 56),
                      _SettingsTile(
                        icon: Icons.notifications_rounded,
                        title: 'Notifications',
                        subtitle: 'Daily reminder at 9:00 AM',
                        onTap: () {},
                      ),
                      const Divider(indent: 56),
                      _SettingsTile(
                        icon: Icons.info_outline_rounded,
                        title: 'About',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SliverPadding(
              padding: EdgeInsets.only(bottom: AppSpacing.xxl),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.ms,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleSmall),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null)
              trailing!
            else if (onTap != null)
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
          ],
        ),
      ),
    );
  }
}
