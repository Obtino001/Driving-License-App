library;

import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../widgets/selectable_option_card.dart';

class ExperiencePage extends StatefulWidget {
  const ExperiencePage({super.key});

  @override
  State<ExperiencePage> createState() => _ExperiencePageState();
}

class _ExperiencePageState extends State<ExperiencePage> {
  String? _selectedExp;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          Text(
            'How much practice have you had?',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'We will adjust the initial difficulty.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          SelectableOptionCard(
            title: 'Beginner',
            subtitle: 'I am just starting to study',
            isSelected: _selectedExp == 'Beginner',
            onTap: () => setState(() => _selectedExp = 'Beginner'),
          ),
          const SizedBox(height: AppSpacing.md),
          SelectableOptionCard(
            title: 'Some practice',
            subtitle: 'I know the basics',
            isSelected: _selectedExp == 'Some',
            onTap: () => setState(() => _selectedExp = 'Some'),
          ),
          const SizedBox(height: AppSpacing.md),
          SelectableOptionCard(
            title: 'Almost ready',
            subtitle: 'I am testing soon',
            isSelected: _selectedExp == 'Ready',
            onTap: () => setState(() => _selectedExp = 'Ready'),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
