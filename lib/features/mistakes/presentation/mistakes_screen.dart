import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/editorial_header.dart';
import '../../../core/widgets/app_button.dart';
import '../../learn/presentation/module_motif.dart';
import '../application/mistakes_controller.dart';
import '../../../core/utils/haptics.dart';

class MistakesScreen extends ConsumerWidget {
  const MistakesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(mistakesProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // refresh logic
          },
          color: AppColors.primaryDark,
          child: stateAsync.when(
            data: (state) {
              final mistakes = state.mistakes;

              if (mistakes.isEmpty) {
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                  children: [
                    const EditorialHeader(
                      title: 'MISTAKES',
                      subtitle: 'Turn weak spots into confidence.',
                    ),
                    const SizedBox(height: 60),
                    _buildEmptyState(context),
                  ],
                );
              }

              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                children: [
                  const EditorialHeader(
                    title: 'MISTAKES',
                    subtitle: 'Turn weak spots into confidence.',
                  ),
                  const SizedBox(height: 24),
                  _buildHero(context, mistakes.length),
                  const SizedBox(height: 32),
                  ...mistakes.map((q) => _buildMistakeCard(context, q)),
                ],
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.primaryAccent),
            ),
            error: (e, _) => Center(child: Text("Error: $e")),
          ),
        ),
      ),
    );
  }

  Widget _buildHero(BuildContext context, int count) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.textTertiary.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: AppColors.primaryDark,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Row(
              children: [
                const ModuleMotif(category: 'Traffic Signs'),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    "$count Questions\nNeed Review",
                    style: Theme.of(context).textTheme.displaySmall
                        ?.copyWith(color: AppColors.textInverse, fontSize: 24),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: AppButton(
              text: "Practice Mistakes",
              onPressed: () {
                AppHaptics.buttonPress();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.textTertiary.withValues(alpha: 0.1),
              ),
            ),
            child: Icon(
              PhosphorIcons.roadHorizon(PhosphorIconsStyle.fill),
              color: AppColors.primaryAccent,
              size: 64,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            "Clear road ahead.",
            style: Theme.of(context).textTheme.displaySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              "You have no mistakes to review right now. Keep practicing to build confidence.",
              style: Theme.of(context).textTheme.bodyLarge
                  ?.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMistakeCard(BuildContext context, dynamic question) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.textTertiary.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                question.category,
                style: Theme.of(context).textTheme.labelMedium
                    ?.copyWith(color: AppColors.textTertiary),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  "Needs review",
                  style: Theme.of(context).textTheme.labelMedium
                      ?.copyWith(color: AppColors.warning, fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            question.questionText,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ],
      ),
    );
  }
}
