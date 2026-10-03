import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';
import '../../features/scenarios/presentation/visual_scenario_widget.dart';
import '../../features/scenarios/domain/scenario_models.dart';

/// A question illustration slot. With no artwork it takes no space.
/// [overlay] allows a future native or Rive visual without changing quiz layout.
class VisualScenario extends StatelessWidget {
  const VisualScenario({
    super.key,
    this.assetType,
    this.assetPath,
    this.overlay,
    this.caption,
    this.isRevealed = false,
  });

  final String? assetType;
  final String? assetPath;
  final Widget? overlay;
  final String? caption;
  final bool isRevealed;

  @override
  Widget build(BuildContext context) {
    final type = assetType?.trim();
    final path = assetPath?.trim();

    if ((path == null || path.isEmpty) &&
        overlay == null &&
        type != 'scenario') {
      return const SizedBox.shrink();
    }

    Widget artwork;
    if (overlay != null) {
      artwork = overlay!;
    } else if (type == 'scenario' && path != null) {
      ScenarioType sType;
      try {
        sType = ScenarioType.values.byName(path);
      } catch (_) {
        sType = ScenarioType.fourWayIntersection;
      }
      artwork = VisualScenarioWidget(
        type: sType,
        state: isRevealed ? ScenarioState.highlighted : ScenarioState.initial,
        animate: true,
      );
    } else if (path != null && path.toLowerCase().endsWith('.svg')) {
      artwork = SvgPicture.asset(path, fit: BoxFit.contain);
    } else if (path != null) {
      artwork = Image.asset(path, fit: BoxFit.contain);
    } else {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: type == 'scenario' ? EdgeInsets.zero : const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: type == 'scenario'
            ? Colors.transparent
            : const Color(0xFFE5EBE4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: type == 'scenario' ? 220 : 145,
            width: double.infinity,
            child: Center(child: artwork),
          ),
          if (caption != null) ...[
            const SizedBox(height: 9),
            Text(
              caption!,
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ],
      ),
    );
  }
}
