library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../data/models/road_sign.dart';
import '../providers/road_signs_provider.dart';
import 'widgets/road_sign_card.dart';

class RoadSignDetailScreen extends ConsumerWidget {
  const RoadSignDetailScreen({
    super.key,
    required this.sign,
  });

  final RoadSign sign;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = context.appColors;
    
    final isFavorite = ref.watch(favoriteRoadSignsProvider).contains(sign.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(sign.category),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              ref.read(favoriteRoadSignsProvider.notifier).toggleFavorite(sign.id);
            },
            icon: Icon(
              isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: isFavorite ? colors.warning : theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ─── Illustration ───
              Container(
                height: 240,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerLow,
                  borderRadius: AppRadius.borderRadiusXl,
                ),
                child: Center(
                  child: Hero(
                    tag: 'sign_${sign.id}',
                    child: RoadSignIllustration(sign: sign, size: 140),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // ─── Title ───
              Text(
                sign.name,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // ─── Meaning ───
              _DetailSection(
                icon: Icons.info_outline_rounded,
                title: 'Meaning',
                content: sign.meaning,
                iconColor: theme.colorScheme.primary,
              ),
              const SizedBox(height: AppSpacing.lg),

              // ─── Action Required ───
              _DetailSection(
                icon: Icons.front_hand_rounded,
                title: 'What to do',
                content: sign.actionRequired,
                iconColor: colors.warning,
              ),
              const SizedBox(height: AppSpacing.lg),

              // ─── Example Situation ───
              _DetailSection(
                icon: Icons.location_on_outlined,
                title: 'Where you\'ll see it',
                content: sign.exampleSituation,
                iconColor: colors.info,
              ),
              const SizedBox(height: AppSpacing.xxl),
              
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({
    required this.icon,
    required this.title,
    required this.content,
    required this.iconColor,
  });

  final IconData icon;
  final String title;
  final String content;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.borderRadiusLg,
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: iconColor),
              const SizedBox(width: AppSpacing.sm),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            content,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
