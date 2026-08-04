class ReviewModel {
  final int id;
  final String studentName;
  final int rating;
  final String comment;
  final String tags;
  final String createdAt;

  ReviewModel({
    required this.id,
    required this.studentName,
    required this.rating,
    required this.comment,
    required this.tags,
    required this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      studentName: json['student_name'] ?? 'Parent',
      rating: int.tryParse(json['rating'].toString()) ?? 0,
      comment: json['comment'] ?? '',
      tags: json['tags'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_name': studentName,
      'rating': rating,
      'comment': comment,
      'tags': tags,
      'created_at': createdAt,
    };
  }
}
