class QuestionModel {
  int id;
  int? classId;
  int? subjectId;
  String? subjectName;
  String? question;
  String? option1;
  String? option2;
  String? option3;
  String? option4;
  String? correctAnswer;
  String? questionImage;
  String? answerImage;
  int? questionTypeId;
  int? dayId;
  String? createdAt;

  QuestionModel({
    required this.id,
    this.classId,
    this.subjectId,
    this.subjectName,
    this.question,
    this.option1,
    this.option2,
    this.option3,
    this.option4,
    this.correctAnswer,
    this.questionImage,
    this.answerImage,
    this.questionTypeId,
    this.dayId,
    this.createdAt,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    // Read subject_id as integer if numeric, or as subjectName string if subject_name was aliased
    final rawSubject = json['subject_id']?.toString() ?? json['subject_name']?.toString();
    final parsedSubjectId = int.tryParse(rawSubject ?? '');

    return QuestionModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      classId: int.tryParse(json['class_id'].toString()),
      subjectId: parsedSubjectId,
      subjectName: rawSubject,
      question: json['question']?.toString(),
      option1: json['option1']?.toString(),
      option2: json['option2']?.toString(),
      option3: json['option3']?.toString(),
      option4: json['option4']?.toString(),
      correctAnswer: json['correct_answer']?.toString(),
      questionImage: json['question_image']?.toString(),
      answerImage: json['answer_image']?.toString(),
      questionTypeId: int.tryParse(json['question_type_id'].toString()),
      dayId: int.tryParse(json['day_id'].toString()),
      createdAt: json['created_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'class_id': classId,
      'subject_id': subjectId ?? subjectName,
      'subject_name': subjectName,
      'question': question,
      'option1': option1,
      'option2': option2,
      'option3': option3,
      'option4': option4,
      'correct_answer': correctAnswer,
      'question_image': questionImage,
      'answer_image': answerImage,
      'question_type_id': questionTypeId,
      'day_id': dayId,
      'created_at': createdAt,
    };
  }
}
