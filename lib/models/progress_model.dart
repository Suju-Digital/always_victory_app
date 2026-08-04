class ProgressModel {
  final bool status;
  final int studentId;
  final int classId;
  final int totalQuestions;
  final int solvedQuestions;
  final double percentage;

  const ProgressModel({
    required this.status,
    required this.studentId,
    required this.classId,
    required this.totalQuestions,
    required this.solvedQuestions,
    required this.percentage,
  });

  factory ProgressModel.fromJson(Map<String, dynamic> json) {
    return ProgressModel(
      status: json['status'] ?? false,
      studentId: int.tryParse(
        json['student_id']?.toString() ?? '',
      ) ??
          0,
      classId: int.tryParse(
        json['class_id']?.toString() ?? '',
      ) ??
          0,
      totalQuestions: int.tryParse(
        json['total_questions']?.toString() ?? '',
      ) ??
          0,
      solvedQuestions: int.tryParse(
        json['solved_questions']?.toString() ?? '',
      ) ??
          0,
      percentage: double.tryParse(
        json['percentage']?.toString() ?? '',
      ) ??
          0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'student_id': studentId,
      'class_id': classId,
      'total_questions': totalQuestions,
      'solved_questions': solvedQuestions,
      'percentage': percentage,
    };
  }


}