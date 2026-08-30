library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/data/local_database.dart';
import '../../../app/app.dart';
import '../../progress/providers/progress_provider.dart';
import '../../practice/providers/mistakes_provider.dart';
import '../providers/settings_provider.dart';
import '../../../core/widgets/state_switcher_sheet.dart';
import '../../../core/providers/state_selection_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final progressAsync = ref.watch(progressProvider);
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
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
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
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
                        radius: 32,
                        backgroundColor: theme.colorScheme.primaryContainer,
                        child: Text(
                          'Y',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w700,
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
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              'Preparing for Driving Test',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            if (settings.streakRecoveryAvailable) ...[
                              const SizedBox(height: AppSpacing.sm),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.tertiaryContainer,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.ac_unit_rounded, 
                                      size: 12, 
                                      color: theme.colorScheme.onTertiaryContainer
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Streak Freeze Active',
                                      style: theme.textTheme.labelSmall?.copyWith(
                                        color: theme.colorScheme.onTertiaryContainer,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Profile Stats Grid
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              sliver: SliverToBoxAdapter(
                child: progressAsync.when(
                  data: (progress) {
                    final stats = progress.userStats;
                    final accuracy = (stats.overallAccuracy * 100).round();

                    return GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: AppSpacing.md,
                      crossAxisSpacing: AppSpacing.md,
                      childAspectRatio: 2.5,
                      children: [
                        _StatBadge(
                          title: 'Level ${stats.level}',
                          subtitle: '${stats.xp} XP',
                          icon: Icons.military_tech_rounded,
                          color: context.appColors.warning,
                        ),
                        _StatBadge(
                          title: '${stats.currentStreak} Days',
                          subtitle: 'Current Streak',
                          icon: Icons.local_fire_department_rounded,
                          color: theme.colorScheme.error,
                        ),
                        _StatBadge(
                          title: '${stats.totalQuestionsAnswered}',
                          subtitle: 'Questions Done',
                          icon: Icons.done_all_rounded,
                          color: theme.colorScheme.primary,
                        ),
                        _StatBadge(
                          title: '$accuracy%',
                          subtitle: 'Accuracy',
                          icon: Icons.analytics_rounded,
                          color: context.appColors.success,
                        ),
                      ],
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ),
            ),
            
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),

            // Settings - Preferences
            _SettingsSection(
              title: 'Preferences',
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
                    selected: {ref.watch(themeModeProvider)},
                    onSelectionChanged: (values) {
                      ref.read(themeModeProvider.notifier).state = values.first;
                    },
                    style: SegmentedButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ),
                const Divider(indent: 56, height: 1),
                _SettingsTile(
                  icon: Icons.language_rounded,
                  title: 'Language',
                  subtitle: settings.language,
                  onTap: () => _showLanguageDialog(context, ref, settings.language),
                ),
                const Divider(indent: 56, height: 1),
                Consumer(
                  builder: (context, ref, _) {
                    final activeStateId = ref.watch(activeStateIdProvider);
                    final statesAsync = ref.watch(allStatesProvider);
                    
                    final activeStateName = statesAsync.maybeWhen(
                      data: (states) {
                        final state = states.firstWhere((s) => s.stateId == activeStateId, orElse: () => states.first);
                        return state.stateName;
                      },
                      orElse: () => 'Loading...',
                    );

                    return _SettingsTile(
                      icon: Icons.location_on_rounded,
                      title: 'State/Region',
                      subtitle: activeStateName,
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => const StateSwitcherSheet(),
                        );
                      },
                    );
                  },
                ),
                const Divider(indent: 56, height: 1),
                _SettingsTile(
                  icon: Icons.flag_rounded,
                  title: 'Daily Goal',
                  subtitle: '${settings.dailyGoal} questions',
                  onTap: () => _showGoalDialog(context, ref, settings.dailyGoal),
                ),
              ],
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),

            // Settings - Experience
            _SettingsSection(
              title: 'Experience',
              children: [
                _SettingsTile(
                  icon: Icons.notifications_rounded,
                  title: 'Notifications',
                  trailing: Switch.adaptive(
                    value: settings.notificationsEnabled,
                    onChanged: (val) => ref.read(settingsProvider.notifier).toggleNotifications(val),
                  ),
                ),
                if (settings.notificationsEnabled) ...[
                  const Divider(indent: 56, height: 1),
                  _SettingsTile(
                    icon: Icons.access_time_rounded,
                    title: 'Reminder Time',
                    subtitle: settings.reminderTime,
                    onTap: () => _showTimePicker(context, ref, settings.reminderTime),
                  ),
                ],
                const Divider(indent: 56, height: 1),
                _SettingsTile(
                  icon: Icons.volume_up_rounded,
                  title: 'Sound Effects',
                  trailing: Switch.adaptive(
                    value: settings.soundEnabled,
                    onChanged: (val) => ref.read(settingsProvider.notifier).toggleSound(val),
                  ),
                ),
                const Divider(indent: 56, height: 1),
                _SettingsTile(
                  icon: Icons.vibration_rounded,
                  title: 'Haptic Feedback',
                  trailing: Switch.adaptive(
                    value: settings.hapticEnabled,
                    onChanged: (val) => ref.read(settingsProvider.notifier).toggleHaptic(val),
                  ),
                ),
              ],
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),

            // Settings - About
            _SettingsSection(
              title: 'About',
              children: [
                _SettingsTile(
                  icon: Icons.privacy_tip_rounded,
                  title: 'Privacy Policy',
                  onTap: () {},
                ),
                const Divider(indent: 56, height: 1),
                _SettingsTile(
                  icon: Icons.description_rounded,
                  title: 'Terms of Service',
                  onTap: () {},
                ),
                const Divider(indent: 56, height: 1),
                _SettingsTile(
                  icon: Icons.info_outline_rounded,
                  title: 'App Version',
                  subtitle: '1.0.0',
                ),
              ],
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),

            // Settings - Danger Zone
            _SettingsSection(
              title: 'Danger Zone',
              children: [
                _SettingsTile(
                  icon: Icons.delete_forever_rounded,
                  title: 'Reset Progress',
                  subtitle: 'Erase all stats and mastery',
                  iconColor: theme.colorScheme.error,
                  titleColor: theme.colorScheme.error,
                  onTap: () => _showResetDialog(context, ref),
                ),
              ],
            ),

            const SliverPadding(
              padding: EdgeInsets.only(bottom: AppSpacing.xxl * 2),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showLanguageDialog(BuildContext context, WidgetRef ref, String current) async {
    final langs = ['English', 'Spanish', 'French'];
    await showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Select Language'),
        children: langs.map((l) => RadioListTile(
          title: Text(l),
          value: l,
          groupValue: current,
          onChanged: (val) {
            if (val != null) {
              ref.read(settingsProvider.notifier).setLanguage(val as String);
              Navigator.pop(context);
            }
          },
        )).toList(),
      ),
    );
  }

  Future<void> _showGoalDialog(BuildContext context, WidgetRef ref, int current) async {
    final goals = [5, 10, 20, 30];
    await showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Daily Question Goal'),
        children: goals.map((g) => RadioListTile(
          title: Text('$g questions'),
          value: g,
          groupValue: current,
          onChanged: (val) {
            if (val != null) {
              ref.read(settingsProvider.notifier).setDailyGoal(val as int);
              Navigator.pop(context);
            }
          },
        )).toList(),
      ),
    );
  }

  Future<void> _showTimePicker(BuildContext context, WidgetRef ref, String current) async {
    final parts = current.split(':');
    final initialTime = TimeOfDay(
      hour: int.tryParse(parts[0]) ?? 9, 
      minute: int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0
    );
    
    final time = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    
    if (time != null && context.mounted) {
      final formatted = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      ref.read(settingsProvider.notifier).setReminderTime(formatted);
    }
  }

  Future<void> _showResetDialog(BuildContext context, WidgetRef ref) async {
    final theme = Theme.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(Icons.warning_rounded, color: theme.colorScheme.error, size: 48),
        title: const Text('Reset All Progress?'),
        content: const Text(
          'This will permanently delete all your quiz history, mastery levels, and mock test scores. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
              foregroundColor: theme.colorScheme.onError,
            ),
            child: const Text('Delete Permanently'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final db = ref.read(localDatabaseProvider);
      await db.clearUserData();
      
      // Invalidate providers so UI updates immediately
      ref.invalidate(progressProvider);
      ref.invalidate(mistakesProvider);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All progress has been reset.')),
        );
      }
    }
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: AppSpacing.sm, bottom: AppSpacing.sm),
              child: Text(
                title.toUpperCase(),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLow,
                borderRadius: AppRadius.borderRadiusLg,
              ),
              child: Column(children: children),
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
    this.iconColor,
    this.titleColor,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.borderRadiusLg,
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
              color: iconColor ?? theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title, 
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: titleColor ?? theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    )
                  ),
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
                size: 14,
                color: theme.colorScheme.onSurfaceVariant,
              ),
          ],
        ),
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  const _StatBadge({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: AppRadius.borderRadiusLg,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  subtitle,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
