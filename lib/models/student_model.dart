class StudentModel {

   String? id;
  final String? name;
  final String? email;
  final String? mobile;
  final String? className;
  final String? photo;
  final String? status;
  final String? classId;
  final String? createdAt;
  final String? demoStatus;
  final String? courseBuy;

  StudentModel({
    this.id,
    this.name,
    this.email,
    this.mobile,
    this.className,
    this.photo,
    this.status,
    this.classId,
    this.createdAt,
    this.demoStatus,
    this.courseBuy,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id']?.toString(),
      name: json['name']?.toString(),
      email: json['email']?.toString(),
      mobile: json['mobile']?.toString(),
      className: json['class_name']?.toString(),
      photo: json['photo']?.toString(),
      status: json['status']?.toString(),
      classId: json['class_id']?.toString(),
      createdAt: json['created_at']?.toString(),
      demoStatus: json['demo_status']?.toString(),
      courseBuy: json['course_buy']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'mobile': mobile,
      'class_name': className,
      'photo': photo,
      'status': status,
      'class_id': classId,
      'created_at': createdAt,
      'demo_status': demoStatus,
      'course_buy': courseBuy,
    };
  }
}