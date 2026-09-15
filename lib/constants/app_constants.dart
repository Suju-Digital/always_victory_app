class AppConstants {
  // Quiz Settings
  static const int defaultTimePerQuestion = 30;   // seconds
  static const int defaultQuestionCount   = 10;
  static const int maxQuestionCount       = 50;
  static const int minQuestionCount       = 5;
  static const int optionsPerQuestion     = 4;

  // Scoring
  static const int marksPerCorrect        = 4;
  static const int marksPerWrong          = -1;   // negative marking
  static const int marksPerSkipped        = 0;

  // Performance Thresholds (%)
  static const double excellentThreshold  = 90.0;
  static const double greatThreshold      = 75.0;
  static const double goodThreshold       = 60.0;
  static const double averageThreshold    = 40.0;

  // Animation Durations (ms)
  static const int splashDuration         = 2500;
  static const int pageTransitionDuration = 300;
  static const int optionAnimDuration     = 200;
  static const int timerWarningAt         = 10;   // seconds remaining

  // UI Standard Paddings
  static const double paddingXS   = 4.0;
  static const double paddingSM   = 8.0;
  static const double paddingMD   = 16.0;
  static const double paddingLG   = 20.0;
  static const double paddingXL   = 24.0;
  static const double paddingXXL  = 32.0;

  // Standard Border Radiuses (for bubbly kid-friendly UI)
  static const double radiusSM    = 8.0;
  static const double radiusMD    = 16.0;
  static const double radiusLG    = 24.0;
  static const double radiusXL    = 32.0;
  static const double radiusRound = 100.0;

  // Standard Icon Sizes
  static const double iconSM      = 16.0;
  static const double iconMD      = 24.0;
  static const double iconLG      = 32.0;
  static const double iconXL      = 48.0;

  // Standard Shadows (Offset and Blur)
  static const double shadowBlurNormal = 12.0;
  static const double shadowBlurHeavy  = 20.0;

  // SharedPreferences Keys
  static const String keyDarkMode      = 'dark_mode';
  static const String keySound         = 'sound_enabled';
  static const String keyVibration     = 'vibration_enabled';
  static const String keySelectedClass = 'selected_class';
  static const String keyHighScore     = 'high_score';
  static const String keyTotalQuizzes  = 'total_quizzes';
  static const String keyQuizHistory   = 'quiz_history';

  // Asset Paths
  static const String lottieCorrect   = 'assets/animations/correct.json';
  static const String lottieWrong     = 'assets/animations/wrong.json';
  static const String lottieCelebrate = 'assets/animations/celebrate.json';
  static const String lottieLoading   = 'assets/animations/loading.json';
  static const String logoPath        = 'assets/images/logo.png';

  // Option Labels
  static const List<String> optionLabels = ['A', 'B', 'C', 'D'];
}
