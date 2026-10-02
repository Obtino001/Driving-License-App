import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/app_colors.dart';

import '../application/learn_controller.dart';
import '../../../core/utils/haptics.dart';

class LearnScreen extends ConsumerWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(learnProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: const Text("Learning Roadmap")),
      body: SafeArea(
        child: stateAsync.when(
          data: (state) {
            final modules = state.modules;
            return Stack(
              children: [
                // Dashed line background
                Positioned(
                  left: 48,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 2,
                    decoration: const BoxDecoration(
                      color: Color(
                        0xFFE0E0E0,
                      ), // Placeholder dashed effect later
                    ),
                  ),
                ),
                ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  itemCount: modules.length,
                  itemBuilder: (context, index) {
                    final module = modules[index];
                    return _buildModuleNode(context, module);
                  },
                ),
              ],
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primaryAccent),
          ),
          error: (e, _) => Center(child: Text("Error: \$e")),
        ),
      ),
    );
  }

  Widget _buildModuleNode(BuildContext context, LearnModule module) {
    bool isStarted = module.progress > 0;

    return GestureDetector(
      onTap: () {
        AppHaptics.selection();
        _showModuleDetails(context, module);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 48),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Node
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: module.isCompleted
                    ? AppColors.success
                    : (isStarted
                          ? AppColors.primaryAccent
                          : AppColors.surfaceElevated),
                shape: BoxShape.circle,
                border: !isStarted && !module.isCompleted
                    ? Border.all(color: const Color(0xFFE0E0E0), width: 2)
                    : null,
              ),
              child: Center(
                child: Icon(
                  module.isCompleted
                      ? PhosphorIcons.check(PhosphorIconsStyle.bold)
                      : (isStarted
                            ? PhosphorIcons.carProfile(PhosphorIconsStyle.fill)
                            : PhosphorIcons.bookOpen(PhosphorIconsStyle.fill)),
                  color: module.isCompleted || isStarted
                      ? AppColors.primaryDark
                      : AppColors.textTertiary,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: 24),
            // Content
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isStarted
                        ? AppColors.primaryDark
                        : const Color(0xFFE0E0E0),
                  ),
                  boxShadow: isStarted
                      ? [
                          BoxShadow(
                            color: AppColors.primaryDark.withValues(
                              alpha: 0.05,
                            ),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      module.title,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: module.isCompleted
                                ? AppColors.success
                                : AppColors.textPrimary,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "\${module.completedQuestions} / \${module.totalQuestions}",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        if (module.totalQuestions > 0)
                          SizedBox(
                            width: 100,
                            child: LinearProgressIndicator(
                              value: module.progress,
                              backgroundColor: AppColors.textTertiary
                                  .withValues(alpha: 0.2),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                module.isCompleted
                                    ? AppColors.success
                                    : AppColors.primaryAccent,
                              ),
                              minHeight: 4,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showModuleDetails(BuildContext context, LearnModule module) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Module",
                    style: Theme.of(context).textTheme.labelMedium
                        ?.copyWith(color: AppColors.textSecondary),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  module.title,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  "Practice questions specifically for \${module.title} to improve your mastery of this topic.",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Progress",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          "\${(module.progress * 100).toInt()}%",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Questions",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          "\${module.totalQuestions}",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryAccent,
                      foregroundColor: AppColors.primaryDark,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      context.push('/practice', extra: module.category);
                    },
                    child: Text(
                      module.isCompleted ? "Practice Again" : "Start Practice",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
