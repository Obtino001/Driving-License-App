import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../application/mistakes_controller.dart';
import '../../../core/widgets/app_button.dart';

class MistakesScreen extends ConsumerWidget {
  const MistakesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(mistakesProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: const Text("Mistake Bank")),
      body: SafeArea(
        child: stateAsync.when(
          data: (state) {
            final mistakes = state.mistakes;

            if (mistakes.isEmpty) {
              return _buildEmptyState(context);
            }

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildHero(context, mistakes.length)),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final question = mistakes[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildMistakeCard(context, question),
                      );
                    }, childCount: mistakes.length),
                  ),
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

  Widget _buildHero(BuildContext context, int count) {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                PhosphorIcons.target(PhosphorIconsStyle.fill),
                color: AppColors.danger,
                size: 32,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Your weak spots",
                  style: Theme.of(context).textTheme.headlineMedium
                      ?.copyWith(color: AppColors.textInverse),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            "\$count questions to master",
            style: Theme.of(context).textTheme.bodyLarge
                ?.copyWith(color: AppColors.textTertiary),
          ),
          const SizedBox(height: 24),
          AppButton(
            text: "Review All",
            onPressed: () {
              // Later: launch quiz with only mistake questions
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),
                color: AppColors.success,
                size: 64,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              "No mistakes yet",
              style: Theme.of(context).textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              "Keep practicing! Any questions you get wrong will automatically appear here.",
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMistakeCard(BuildContext context, dynamic question) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              question.category,
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            question.questionText,
            style: Theme.of(context).textTheme.headlineSmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    PhosphorIcons.xCircle(),
                    color: AppColors.danger,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "Needs review",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              Icon(
                PhosphorIcons.caretRight(),
                color: AppColors.textTertiary,
                size: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
