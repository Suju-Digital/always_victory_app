import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../constants/app_text_styles.dart';

enum OptionState { idle, selected, correct, wrong }

class OptionTile extends StatelessWidget {
  final String label;
  final String text;
  final OptionState state;
  final VoidCallback? onTap;

  const OptionTile({
    super.key,
    required this.label,
    required this.text,
    this.state = OptionState.idle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final (bg, border, labelBg, textColor) = _stateStyle(isDark);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: AppConstants.optionAnimDuration),
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingMD,
          vertical: AppConstants.paddingMD,
        ),
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: border, width: 2),
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: labelBg, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Text(
                label,
                style: AppTextStyles.optionLabel.copyWith(color: Colors.white),
              ),
            ),
            const SizedBox(width: AppConstants.paddingMD),
            Expanded(
              child: Text(
                text,
                style: AppTextStyles.optionText.copyWith(color: textColor),
              ),
            ),
            if (state == OptionState.correct)
              const Icon(Icons.check_circle_rounded, color: AppColors.correct),
            if (state == OptionState.wrong)
              const Icon(Icons.cancel_rounded, color: AppColors.wrong),
          ],
        ),
      ),
    );
  }

  (Color, Color, Color, Color) _stateStyle(bool isDark) {
    final defaultText = isDark ? AppColors.textLight : AppColors.textDark;
    final defaultBg   = isDark ? AppColors.cardDark  : AppColors.cardLight;

    switch (state) {
      case OptionState.correct:
        return (
          AppColors.correct.withOpacity(0.12),
          AppColors.correct,
          AppColors.correct,
          AppColors.correct,
        );
      case OptionState.wrong:
        return (
          AppColors.wrong.withOpacity(0.12),
          AppColors.wrong,
          AppColors.wrong,
          AppColors.wrong,
        );
      case OptionState.selected:
        return (
          AppColors.primary.withOpacity(0.1),
          AppColors.primary,
          AppColors.primary,
          AppColors.primary,
        );
      case OptionState.idle:
        return (defaultBg, AppColors.border, AppColors.textGrey, defaultText);
    }
  }
}
