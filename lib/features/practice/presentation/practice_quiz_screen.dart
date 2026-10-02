import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/motion/app_motion.dart';

class PracticeQuizScreen extends StatefulWidget {
  const PracticeQuizScreen({super.key});

  @override
  State<PracticeQuizScreen> createState() => _PracticeQuizScreenState();
}

class _PracticeQuizScreenState extends State<PracticeQuizScreen> with SingleTickerProviderStateMixin {
  // Sample data for Phase 1
  final String _question = "When arriving at an intersection with a flashing red traffic signal, you must:";
  final List<String> _answers = [
    "Slow down and yield to traffic before proceeding.",
    "Stop completely, then proceed when it is safe.",
    "Stop before entering and wait for the green light."
  ];
  final int _correctIndex = 1;
  final String _explanation = "A flashing red traffic light means the same as a STOP sign. You must come to a complete stop, yield to cross traffic or pedestrians, and then proceed when it is safe.";

  int? _selectedIndex;
  bool _isAnswerRevealed = false;

  void _handleSelectAnswer(int index) {
    if (_isAnswerRevealed) return;

    setState(() {
      _selectedIndex = index;
      _isAnswerRevealed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(PhosphorIconsRegular.x),
          onPressed: () => context.pop(),
        ),
        title: const Text("Practice"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Text(
                "1/20",
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.textTertiary,
                    ),
              ),
            ),
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: 1 / 20,
            backgroundColor: AppColors.textTertiary.withValues(alpha: 0.2),
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryAccent),
            minHeight: 4,
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 32, bottom: 200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _question,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: 48),
                  ...List.generate(_answers.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: _buildAnswerCard(index),
                    );
                  }),
                ],
              ),
            ),
            
            // Explanation Panel (Bottom Sheet style)
            AnimatedPositioned(
              duration: AppMotion.standard,
              curve: AppMotion.standardEasing,
              bottom: _isAnswerRevealed ? 0 : -300,
              left: 0,
              right: 0,
              child: _buildExplanationPanel(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerCard(int index) {
    bool isSelected = _selectedIndex == index;
    bool isCorrect = index == _correctIndex;
    
    Color backgroundColor = AppColors.surface;
    Color borderColor = const Color(0xFFE0E0E0);
    Widget? trailingIcon;

    if (_isAnswerRevealed) {
      if (isCorrect) {
        backgroundColor = AppColors.success.withValues(alpha: 0.1);
        borderColor = AppColors.success;
        trailingIcon = Icon(PhosphorIcons.checkCircle(PhosphorIconsStyle.fill), color: AppColors.success);
      } else if (isSelected && !isCorrect) {
        backgroundColor = AppColors.danger.withValues(alpha: 0.1);
        borderColor = AppColors.danger;
        trailingIcon = Icon(PhosphorIcons.xCircle(PhosphorIconsStyle.fill), color: AppColors.danger);
      } else {
        // Dim unselected incorrect answers
        backgroundColor = AppColors.surface.withValues(alpha: 0.5);
      }
    } else if (isSelected) {
      backgroundColor = AppColors.surfaceElevated;
      borderColor = AppColors.primaryDark;
    }

    return GestureDetector(
      onTap: () => _handleSelectAnswer(index),
      child: AnimatedContainer(
        duration: AppMotion.quick,
        curve: AppMotion.springSubtle,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: isSelected || (_isAnswerRevealed && (isCorrect || isSelected)) ? 2 : 1),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _answers[index],
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: _isAnswerRevealed && !isCorrect && !isSelected ? AppColors.textTertiary : AppColors.textPrimary,
                      fontWeight: (isSelected || (_isAnswerRevealed && isCorrect)) ? FontWeight.w500 : FontWeight.w400,
                    ),
              ),
            ),
            if (trailingIcon != null) ...[
              const SizedBox(width: 16),
              trailingIcon,
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildExplanationPanel() {
    bool isUserCorrect = _selectedIndex == _correctIndex;
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isUserCorrect ? PhosphorIcons.checkCircle(PhosphorIconsStyle.fill) : PhosphorIcons.xCircle(PhosphorIconsStyle.fill),
                color: isUserCorrect ? AppColors.success : AppColors.danger,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                isUserCorrect ? "Great job!" : "Not quite.",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _explanation,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 32),
          AppButton(
            text: "Next Question",
            onPressed: () {
              // In MVP, we just pop for demonstration.
              context.pop();
            },
          ),
        ],
      ),
    );
  }
}
