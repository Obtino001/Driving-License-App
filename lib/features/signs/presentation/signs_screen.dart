import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/haptics.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/editorial_header.dart';
import '../../../core/database/app_database.dart';
import '../application/signs_controller.dart';
import 'widgets/sign_artwork.dart';

class SignsScreen extends ConsumerStatefulWidget {
  const SignsScreen({super.key});
  @override
  ConsumerState<SignsScreen> createState() => _SignsScreenState();
}

class _SignsScreenState extends ConsumerState<SignsScreen> {
  String _category = 'All';
  static const categories = [
    'All',
    'Regulatory',
    'Warning',
    'Guide',
    'Construction',
    'Railroad',
  ];

  @override
  Widget build(BuildContext context) {
    final signsAsync = ref.watch(signsProvider);
    final studySigns = signsAsync.value ?? [];

    final visible = _category == 'All'
        ? studySigns
        : studySigns.where((sign) => sign.category == _category).toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                tooltip: 'Back',
                onPressed: () => context.pop(),
                icon: Icon(PhosphorIcons.arrowLeft()),
              ),
            ),
            const SizedBox(height: 15),
            const EditorialHeader(
              eyebrow: 'ROAD SIGNS',
              title: 'Read the road\nbefore it speaks.',
              subtitle:
                  'Learn each shape, then test what it means on the move.',
            ),
            const SizedBox(height: 26),
            _FeaturedStudy(
              firstSign: studySigns.isNotEmpty ? studySigns.first : null,
              onTap: () {
                AppHaptics.selection();
                context.push('/signs/flashcards');
              },
            ),
            const SizedBox(height: 10),
            Material(
              color: const Color(0xFFE5EBE4),
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  AppHaptics.selection();
                  context.push('/practice', extra: 'Traffic Signs');
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 17,
                  ),
                  child: Row(
                    children: [
                      Icon(PhosphorIcons.arrowsLeftRight(), size: 25),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          'Test your sign knowledge',
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      Icon(PhosphorIcons.arrowUpRight(), size: 20),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'The sign library',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ),
                Text(
                  '${visible.length} signs',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 13),
            SizedBox(
              height: 39,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, _) => const SizedBox(width: 7),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final selected = category == _category;
                  return Semantics(
                    button: true,
                    selected: selected,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(22),
                      onTap: () {
                        AppHaptics.selection();
                        setState(() => _category = category);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.primaryDark
                              : AppColors.surface,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Text(
                          category,
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                color: selected
                                    ? AppColors.primaryAccent
                                    : AppColors.textPrimary,
                                fontWeight: selected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 15),
            ...visible.map(
              (sign) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: SignStudyCard(
                  sign: sign,
                  onTap: () {
                    AppHaptics.selection();
                    _showSignDetail(context, sign);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSignDetail(BuildContext context, RoadSign sign) {
    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: AppColors.backgroundLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheet) => SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            22,
            12,
            22,
            22 + MediaQuery.paddingOf(sheet).bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFC5CEC3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Container(
                  width: 210,
                  height: 210,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5EBE4),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(child: SignArtwork(sign: sign, size: 165)),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                sign.category.toUpperCase(),
                style: Theme.of(sheet).textTheme.labelMedium?.copyWith(
                  fontSize: 11,
                  letterSpacing: 1.5,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                sign.name,
                style: Theme.of(sheet).textTheme.displayLarge
                    ?.copyWith(fontSize: 38, letterSpacing: -1.2),
              ),
              const SizedBox(height: 12),
              Text(
                sign.detailedMeaning,
                style: Theme.of(sheet).textTheme.bodyLarge,
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE9D0),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'EASY TO MISS',
                      style: Theme.of(sheet).textTheme.labelMedium?.copyWith(
                        fontSize: 11,
                        letterSpacing: 1.3,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      sign.commonMistake ?? 'No common mistake listed.',
                      style: Theme.of(sheet).textTheme.bodyMedium
                          ?.copyWith(color: AppColors.primaryDark),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 21),
              AppButton(
                text: 'Back to signs',
                onPressed: () => Navigator.pop(sheet),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeaturedStudy extends StatelessWidget {
  const _FeaturedStudy({required this.onTap, required this.firstSign});
  final VoidCallback onTap;
  final RoadSign? firstSign;
  @override
  Widget build(BuildContext context) => Material(
    color: AppColors.primaryDark,
    borderRadius: BorderRadius.circular(20),
    child: InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'STUDY MODE',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.primaryAccent,
                      fontSize: 11,
                      letterSpacing: 1.4,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 11),
                  Text(
                    'Sign\nflashcards',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: AppColors.surface,
                      fontSize: 29,
                      height: 1.04,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Look. Recall. Reveal. Repeat.',
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(color: const Color(0xFFD3DDD2)),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Start studying  →',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.primaryAccent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (firstSign != null)
              Transform.rotate(
                angle: -.08,
                child: SignArtwork(sign: firstSign!, size: 112),
              ),
          ],
        ),
      ),
    ),
  );
}

class SignStudyCard extends StatelessWidget {
  const SignStudyCard({super.key, required this.sign, required this.onTap});
  final RoadSign sign;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(17),
    child: InkWell(
      borderRadius: BorderRadius.circular(17),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 91,
              height: 91,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F2ED),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(child: SignArtwork(sign: sign, size: 76)),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sign.category.toUpperCase(),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    sign.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    sign.shortMeaning,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 5),
            Icon(PhosphorIcons.arrowUpRight(), size: 18),
          ],
        ),
      ),
    ),
  );
}
