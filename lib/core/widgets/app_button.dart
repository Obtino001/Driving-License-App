import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../motion/app_motion.dart';

enum AppButtonType { primary, secondary, outline }

class AppButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final AppButtonType type;
  final bool isLoading;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = AppButtonType.primary,
    this.isLoading = false,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: AppMotion.quick);
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: AppMotion.standardEasing),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.isLoading) _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.isLoading) {
      _controller.reverse();
      widget.onPressed();
    }
  }

  void _handleTapCancel() {
    if (!widget.isLoading) _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    BorderSide border = BorderSide.none;

    switch (widget.type) {
      case AppButtonType.primary:
        bg = AppColors.primaryAccent;
        fg = AppColors.primaryDark;
        break;
      case AppButtonType.secondary:
        bg = AppColors.surfaceDark;
        fg = AppColors.surface;
        break;
      case AppButtonType.outline:
        bg = Colors.transparent;
        fg = AppColors.primaryDark;
        border = const BorderSide(color: AppColors.primaryDark, width: 2);
        break;
    }

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) =>
            Transform.scale(scale: _scaleAnimation.value, child: child),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(999),
            border: Border.fromBorderSide(border),
          ),
          child: Center(
            child: widget.isLoading
                ? SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(color: fg, strokeWidth: 2),
                  )
                : Text(
                    widget.text,
                    style: Theme.of(context).textTheme.labelLarge
                        ?.copyWith(color: fg),
                  ),
          ),
        ),
      ),
    );
  }
}
