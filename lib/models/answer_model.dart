class AnswerModel {
  int? studentId;
  int? questionId;
  int? courseId;
  String? givenAnswer;
  int? isCorrect;
  int? timeTaken;
  int? dayId;
  int? classId;
  String? studentAnswer;
  String? correctAnswer;
  String? status;
  String? answer;

  Map<String, dynamic> toJson() {
    return {
      "student_id": studentId,
      "question_id": questionId,
      "course_id": courseId,
      "given_answer": givenAnswer,
      "is_correct": isCorrect,
      "time_taken": timeTaken,
      "day_id": dayId,
      "class_id": classId,
      "student_answer": studentAnswer,
      "correct_answer": correctAnswer,
      "status": status,
      "answer": answer,
    };
  }
}