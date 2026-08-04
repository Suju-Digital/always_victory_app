class QuizResultModel {
  final String subject;
  final String className;
  final int totalQuestions;
  final int correctAnswers;
  final int wrongAnswers;
  final int skippedAnswers;
  final int score;
  final int maxScore;
  final int timeTakenSeconds;
  final DateTime completedAt;
  final List<int?> selectedAnswers; // null = skipped

  const QuizResultModel({
    required this.subject,
    required this.className,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.skippedAnswers,
    required this.score,
    required this.maxScore,
    required this.timeTakenSeconds,
    required this.completedAt,
    required this.selectedAnswers,
  });

  double get percentage =>
      maxScore == 0 ? 0 : (score / maxScore) * 100;

  double get accuracy =>
      totalQuestions == 0 ? 0 : (correctAnswers / totalQuestions) * 100;

  Map<String, dynamic> toJson() => {
    'subject': subject,
    'className': className,
    'totalQuestions': totalQuestions,
    'correctAnswers': correctAnswers,
    'wrongAnswers': wrongAnswers,
    'skippedAnswers': skippedAnswers,
    'score': score,
    'maxScore': maxScore,
    'timeTakenSeconds': timeTakenSeconds,
    'completedAt': completedAt.toIso8601String(),
    'selectedAnswers': selectedAnswers,
  };

  factory QuizResultModel.fromJson(Map<String, dynamic> json) =>
      QuizResultModel(
    subject: json['subject'] as String,
    className: json['className'] as String,
    totalQuestions: json['totalQuestions'] as int,
    correctAnswers: json['correctAnswers'] as int,
    wrongAnswers: json['wrongAnswers'] as int,
    skippedAnswers: json['skippedAnswers'] as int,
    score: json['score'] as int,
    maxScore: json['maxScore'] as int,
    timeTakenSeconds: json['timeTakenSeconds'] as int,
    completedAt: DateTime.parse(json['completedAt'] as String),
    selectedAnswers: List<int?>.from(json['selectedAnswers'] as List),
  );
}
