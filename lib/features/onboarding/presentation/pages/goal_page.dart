library;

import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../widgets/selectable_option_card.dart';

class GoalPage extends StatefulWidget {
  const GoalPage({super.key});

  @override
  State<GoalPage> createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
  String? _selectedGoal;

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
            'Set your daily goal',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Consistent practice is the key to passing.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          SelectableOptionCard(
            title: 'Casual',
            subtitle: '5 questions / day',
            isSelected: _selectedGoal == '5',
            onTap: () => setState(() => _selectedGoal = '5'),
          ),
          const SizedBox(height: AppSpacing.md),
          SelectableOptionCard(
            title: 'Regular',
            subtitle: '10 questions / day',
            isSelected: _selectedGoal == '10',
            onTap: () => setState(() => _selectedGoal = '10'),
          ),
          const SizedBox(height: AppSpacing.md),
          SelectableOptionCard(
            title: 'Intense',
            subtitle: '20 questions / day',
            isSelected: _selectedGoal == '20',
            onTap: () => setState(() => _selectedGoal = '20'),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
