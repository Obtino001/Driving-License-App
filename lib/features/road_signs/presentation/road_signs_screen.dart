library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../practice/data/mock_questions.dart';
import '../../practice/presentation/quiz_session_screen.dart';
import '../data/mock_road_signs.dart';
import '../providers/road_signs_provider.dart';
import 'road_sign_detail_screen.dart';
import 'widgets/road_sign_card.dart';

class RoadSignsScreen extends ConsumerStatefulWidget {
  const RoadSignsScreen({super.key});

  @override
  ConsumerState<RoadSignsScreen> createState() => _RoadSignsScreenState();
}

class _RoadSignsScreenState extends ConsumerState<RoadSignsScreen> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final favorites = ref.watch(favoriteRoadSignsProvider);

    final filteredSigns = mockRoadSigns.where((sign) {
      if (_selectedCategory == 'Favorites') {
        return favorites.contains(sign.id);
      }
      if (_selectedCategory == 'All') return true;
      return sign.category == _selectedCategory;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Road Signs'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ─── Categories ───
            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                children: [
                  _CategoryChip(
                    label: 'All',
                    isSelected: _selectedCategory == 'All',
                    onTap: () => setState(() => _selectedCategory = 'All'),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _CategoryChip(
                    label: 'Favorites',
                    isSelected: _selectedCategory == 'Favorites',
                    icon: Icons.favorite_rounded,
                    onTap: () => setState(() => _selectedCategory = 'Favorites'),
                  ),
                  ...roadSignCategories.where((c) => c != 'All').map((cat) {
                    return Padding(
                      padding: const EdgeInsets.only(left: AppSpacing.sm),
                      child: _CategoryChip(
                        label: cat,
                        isSelected: _selectedCategory == cat,
                        onTap: () => setState(() => _selectedCategory = cat),
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // ─── Grid ───
            Expanded(
              child: filteredSigns.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.traffic_rounded,
                            size: 64,
                            color: theme.colorScheme.surfaceContainerHighest,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            _selectedCategory == 'Favorites'
                                ? 'No favorite signs yet'
                                : 'No signs found in this category',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xxl,
                      ),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: AppSpacing.md,
                        mainAxisSpacing: AppSpacing.md,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: filteredSigns.length,
                      itemBuilder: (context, index) {
                        final sign = filteredSigns[index];
                        return Hero(
                          tag: 'sign_${sign.id}',
                          child: RoadSignCard(
                            sign: sign,
                            isFavorite: favorites.contains(sign.id),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => RoadSignDetailScreen(sign: sign),
                                ),
                              );
                            },
                            onFavoriteToggle: () {
                              ref.read(favoriteRoadSignsProvider.notifier).toggleFavorite(sign.id);
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => QuizSessionScreen(
                title: 'Signs Quiz',
                questions: getQuestionsByCategory('Road Signs & Signals'),
              ),
            ),
          );
        },
        icon: const Icon(Icons.quiz_rounded),
        label: const Text('Sign Quiz'),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;

    return Material(
      color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surfaceContainerHighest,
      borderRadius: AppRadius.borderRadiusFull,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.borderRadiusFull,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 16,
                  color: isSelected ? colors.warning : theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: AppSpacing.xs),
              ],
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurfaceVariant,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
