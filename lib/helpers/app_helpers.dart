import '../constants/app_constants.dart';
import '../constants/app_strings.dart';

class AppHelpers {
  /// Format seconds → MM:SS
  static String formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  /// Calculate percentage
  static double calcPercentage(int obtained, int total) {
    if (total == 0) return 0.0;
    return (obtained / total) * 100;
  }

  /// Score with negative marking
  static int calcScore({
    required int correct,
    required int wrong,
    int marksCorrect = AppConstants.marksPerCorrect,
    int marksWrong   = AppConstants.marksPerWrong,
  }) {
    return (correct * marksCorrect) + (wrong * marksWrong);
  }

  /// Max possible score
  static int maxScore(int totalQuestions) =>
      totalQuestions * AppConstants.marksPerCorrect;

  /// Performance message based on %
  static String getPerformanceMessage(double percentage) {
    if (percentage >= AppConstants.excellentThreshold) return AppStrings.excellent;
    if (percentage >= AppConstants.greatThreshold)     return AppStrings.great;
    if (percentage >= AppConstants.goodThreshold)      return AppStrings.good;
    if (percentage >= AppConstants.averageThreshold)   return AppStrings.average;
    return AppStrings.poor;
  }

  /// Grade letter
  static String getGrade(double percentage) {
    if (percentage >= 90) return 'A+';
    if (percentage >= 80) return 'A';
    if (percentage >= 70) return 'B+';
    if (percentage >= 60) return 'B';
    if (percentage >= 50) return 'C';
    if (percentage >= 40) return 'D';
    return 'F';
  }

  /// Truncate long text
  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  /// Capitalize first letter
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return '${text[0].toUpperCase()}${text.substring(1)}';
  }

  /// Check timer warning zone
  static bool isTimerWarning(int secondsLeft) =>
      secondsLeft <= AppConstants.timerWarningAt;

  /// Get option color hex by index (A/B/C/D)
  static int getOptionColorHex(int index) {
    const colors = [0xFF6366F1, 0xFF8B5CF6, 0xFFEC4899, 0xFFF97316];
    return colors[index % colors.length];
  }

  /// Format large numbers (1200 → 1.2K)
  static String formatNumber(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000)    return '${(n / 1000).toStringAsFixed(1)}K';
    return n.toString();
  }
}
