import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';

/// A question illustration slot. With no artwork it takes no space.
/// [overlay] allows a future native or Rive visual without changing quiz layout.
class VisualScenario extends StatelessWidget {
  const VisualScenario({super.key, this.assetPath, this.overlay, this.caption});
  final String? assetPath;
  final Widget? overlay;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    final path = assetPath?.trim();
    if ((path == null || path.isEmpty) && overlay == null) {
      return const SizedBox.shrink();
    }
    Widget artwork;
    if (overlay != null) {
      artwork = overlay!;
    } else if (path!.toLowerCase().endsWith('.svg')) {
      artwork = SvgPicture.asset(path, fit: BoxFit.contain);
    } else {
      artwork = Image.asset(path, fit: BoxFit.contain);
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFE5EBE4),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 145,
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
