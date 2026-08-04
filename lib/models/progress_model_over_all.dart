class StudentProgressModel {
  final bool status;
  final int studentId;
  final int totalQuestions;
  final int correctAnswers;
  final double overallAccuracy;

  StudentProgressModel({
    required this.status,
    required this.studentId,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.overallAccuracy,
  });

  factory StudentProgressModel.fromJson(Map<String, dynamic> json) {
    return StudentProgressModel(
      status: json["status"] ?? false,
      studentId: int.tryParse(json["student_id"].toString()) ?? 0,
      totalQuestions: int.tryParse(json["total_questions"].toString()) ?? 0,
      correctAnswers: int.tryParse(json["correct_answers"].toString()) ?? 0,
      overallAccuracy: double.tryParse(
        json["overall_accuracy"]
            .toString()
            .replaceAll("%", ""),
      ) ??
          0.0,
    );
  }
}