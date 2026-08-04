class StudentAttemptResponse {
  final bool status;
  final int totalAttempts;
  final List<StudentAttempt> data;

  StudentAttemptResponse({
    required this.status,
    required this.totalAttempts,
    required this.data,
  });

  factory StudentAttemptResponse.fromJson(Map<String, dynamic> json) {
    return StudentAttemptResponse(
      status: json['status'],
      totalAttempts: json['total_attempts'],
      data: (json['data'] as List)
          .map((e) => StudentAttempt.fromJson(e))
          .toList(),
    );
  }
}

class StudentAttempt {
  final String createdAt;
  final int totalQuestions;
  final int correctAnswers;
  final int wrongAnswers;
  final double percentage;
  final int attemptNo;

  StudentAttempt({
    required this.createdAt,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.percentage,
    required this.attemptNo,
  });

  factory StudentAttempt.fromJson(Map<String, dynamic> json) {
    return StudentAttempt(
      createdAt: json['created_at'],
      totalQuestions: int.parse(json['total_questions'].toString()),
      correctAnswers: int.parse(json['correct_answers'].toString()),
      wrongAnswers: int.parse(json['wrong_answers'].toString()),
      percentage: double.parse(json['percentage'].toString()),
      attemptNo: int.parse(json['attempt_no'].toString()),
    );
  }
}