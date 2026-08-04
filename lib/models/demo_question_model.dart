class DemoQuestionModel {
  final int id;
  final int classId;
  final int subjectId;
  final String question;
  final String option1;
  final String option2;
  final String option3;
  final String option4;
  final String correctAnswer;

  DemoQuestionModel({
    required this.id,
    required this.classId,
    required this.subjectId,
    required this.question,
    required this.option1,
    required this.option2,
    required this.option3,
    required this.option4,
    required this.correctAnswer,
  });

  factory DemoQuestionModel.fromJson(Map<String, dynamic> json) {
    return DemoQuestionModel(
      id: int.parse(json['id'].toString()),
      classId: int.parse(json['class_id'].toString()),
      subjectId: int.parse(json['subject_id'].toString()),
      question: json['question'] ?? '',
      option1: json['option1'] ?? '',
      option2: json['option2'] ?? '',
      option3: json['option3'] ?? '',
      option4: json['option4'] ?? '',
      correctAnswer: json['correct_answer']??''
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'class_id': classId,
      'subject_id': subjectId,
      'question': question,
      'option1': option1,
      'option2': option2,
      'option3': option3,
      'option4': option4,
      'correct_answer':correctAnswer,
    };
  }
}