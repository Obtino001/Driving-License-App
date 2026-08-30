library;

import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../widgets/selectable_option_card.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  String? _selectedRegion;

  final _regions = [
    'California',
    'Texas',
    'New York',
    'Florida',
    'Other / Default',
  ];

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
            'Where are you taking your test?',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Rules vary by state. We will tailor the questions to your location.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Expanded(
            flex: 3,
            child: ListView.separated(
              itemCount: _regions.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                final region = _regions[index];
                return SelectableOptionCard(
                  title: region,
                  isSelected: _selectedRegion == region,
                  onTap: () {
                    setState(() {
                      _selectedRegion = region;
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
