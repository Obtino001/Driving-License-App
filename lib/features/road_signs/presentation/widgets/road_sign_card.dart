library;

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../data/models/road_sign.dart';

/// A reusable component that procedurally renders a road sign placeholder
/// based on its shape and color.
class RoadSignIllustration extends StatelessWidget {
  const RoadSignIllustration({
    super.key,
    required this.sign,
    this.size = 80,
  });

  final RoadSign sign;
  final double size;

  @override
  Widget build(BuildContext context) {
    Widget shapeWidget;

    switch (sign.shape) {
      case RoadSignShape.circle:
        shapeWidget = Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: sign.color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: size * 0.05),
          ),
          child: _buildIcon(),
        );
        break;
        
      case RoadSignShape.rectangle:
        shapeWidget = Container(
          width: size,
          height: size * 1.2,
          decoration: BoxDecoration(
            color: sign.color,
            borderRadius: BorderRadius.circular(size * 0.1),
            border: Border.all(
              color: sign.color == Colors.white ? Colors.black : Colors.white, 
              width: size * 0.05,
            ),
          ),
          child: _buildIcon(),
        );
        break;
        
      case RoadSignShape.diamond:
        shapeWidget = Transform.rotate(
          angle: math.pi / 4,
          child: Container(
            width: size * 0.8,
            height: size * 0.8,
            decoration: BoxDecoration(
              color: sign.color,
              borderRadius: BorderRadius.circular(size * 0.05),
              border: Border.all(color: Colors.black, width: size * 0.04),
            ),
            child: Transform.rotate(
              angle: -math.pi / 4,
              child: _buildIcon(),
            ),
          ),
        );
        break;
        
      case RoadSignShape.triangle: // specifically yield sign (point down)
        shapeWidget = Transform.rotate(
          angle: math.pi, // Point down
          child: Icon(
            Icons.change_history_rounded,
            size: size * 1.2,
            color: sign.color,
          ),
        );
        // We override the child here because triangle is complex in pure Container
        return Stack(
          alignment: Alignment.center,
          children: [
            shapeWidget,
            Container(
              margin: EdgeInsets.only(bottom: size * 0.1),
              child: _buildIcon(scale: 0.5),
            ),
          ],
        );
        
      case RoadSignShape.octagon:
      case RoadSignShape.pentagon:
      case RoadSignShape.crossbuck:
        // Fallback for complex shapes we can't easily draw with basic Containers.
        // We just use a rounded rect.
        shapeWidget = Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: sign.color,
            borderRadius: BorderRadius.circular(size * 0.2),
            border: Border.all(
              color: sign.color == Colors.white ? Colors.black : Colors.white, 
              width: size * 0.05,
            ),
          ),
          child: _buildIcon(),
        );
    }

    return SizedBox(
      width: size,
      height: size,
      child: Center(child: shapeWidget),
    );
  }

  Widget _buildIcon({double scale = 0.5}) {
    return Center(
      child: Icon(
        sign.iconData,
        color: sign.foregroundColor,
        size: size * scale,
      ),
    );
  }
}

/// A card displaying a road sign in a grid or list.
class RoadSignCard extends StatelessWidget {
  const RoadSignCard({
    super.key,
    required this.sign,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  final RoadSign sign;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;

    return Material(
      color: theme.colorScheme.surfaceContainerLow,
      borderRadius: AppRadius.borderRadiusLg,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.borderRadiusLg,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: onFavoriteToggle,
                    child: Icon(
                      isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      color: isFavorite ? colors.warning : theme.colorScheme.outlineVariant,
                      size: 20,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              RoadSignIllustration(sign: sign, size: 60),
              const Spacer(),
              Text(
                sign.name,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
