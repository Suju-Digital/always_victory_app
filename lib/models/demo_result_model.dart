class DemoResultModel {
  final int? id;
  final int studentId;
  final int classId;
  final int totalQuestions;
  final int correctAnswers;
  final int wrongAnswers;
  final int score;
  final String createdAt;

  DemoResultModel({
     this.id,
    required this.studentId,
    required this.classId,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.score,
    required this.createdAt,
  });

  factory DemoResultModel.fromJson(Map<String, dynamic> json) {
    return DemoResultModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      studentId: int.tryParse(json['student_id'].toString()) ?? 0,
      classId: int.tryParse(json['class_id'].toString()) ?? 0,
      totalQuestions: int.tryParse(json['total_questions'].toString()) ?? 0,
      correctAnswers: int.tryParse(json['correct_answers'].toString()) ?? 0,
      wrongAnswers: int.tryParse(json['wrong_answers'].toString()) ?? 0,
      score: int.tryParse(json['score'].toString()) ?? 0,
      createdAt: json['created_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'class_id': classId,
      'total_questions': totalQuestions,
      'correct_answers': correctAnswers,
      'wrong_answers': wrongAnswers,
      'score': score,
      'created_at': createdAt,
    };
  }
}