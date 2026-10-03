import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../theme/app_colors.dart';
import '../utils/haptics.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: navigationShell,
      bottomNavigationBar: _BottomNav(navigationShell: navigationShell),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  void _onTap(BuildContext context, int index) {
    AppHaptics.selection();
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = navigationShell.currentIndex;
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 12,
        top: 12,
        left: 24,
        right: 24,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.textTertiary.withOpacity(0.1)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: PhosphorIcons.house(),
            activeIcon: PhosphorIcons.house(PhosphorIconsStyle.fill),
            label: 'Home',
            isActive: currentIndex == 0,
            onTap: () => _onTap(context, 0),
          ),
          _NavItem(
            icon: PhosphorIcons.bookOpen(),
            activeIcon: PhosphorIcons.bookOpen(PhosphorIconsStyle.fill),
            label: 'Learn',
            isActive: currentIndex == 1,
            onTap: () => _onTap(context, 1),
          ),
          _NavItem(
            icon: PhosphorIcons.chartLineUp(),
            activeIcon: PhosphorIcons.chartLineUp(PhosphorIconsStyle.fill),
            label: 'Progress',
            isActive: currentIndex == 2,
            onTap: () => _onTap(context, 2),
          ),
          _NavItem(
            icon: PhosphorIcons.gear(),
            activeIcon: PhosphorIcons.gear(PhosphorIconsStyle.fill),
            label: 'Settings',
            isActive: currentIndex == 3,
            onTap: () => _onTap(context, 3),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.primaryDark : AppColors.textTertiary;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primaryAccent.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isActive ? activeIcon : icon, color: color, size: 24),
            if (isActive) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
