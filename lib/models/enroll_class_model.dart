class EnrollmentModel {
  final bool status;
  final int classId;
  final int totalStudents;

  EnrollmentModel({
    required this.status,
    required this.classId,
    required this.totalStudents,
  });

  factory EnrollmentModel.fromJson(Map<String, dynamic> json) {
    return EnrollmentModel(
      status: json['status'] ?? false,
      classId: int.tryParse(json['class_id'].toString()) ?? 0,
      totalStudents:
      int.tryParse(json['total_students'].toString()) ?? 0,
    );
  }
}