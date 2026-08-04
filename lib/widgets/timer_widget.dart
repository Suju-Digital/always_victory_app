import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../helpers/app_helpers.dart';

class TimerWidget extends StatelessWidget {
  final int secondsLeft;

  const TimerWidget({super.key, required this.secondsLeft});

  @override
  Widget build(BuildContext context) {
    final isWarning = AppHelpers.isTimerWarning(secondsLeft);
    final color     = isWarning ? AppColors.wrong : AppColors.primary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer_outlined, size: 18, color: color),
          const SizedBox(width: 6),
          Text(
            AppHelpers.formatTime(secondsLeft),
            style: AppTextStyles.timerText.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
