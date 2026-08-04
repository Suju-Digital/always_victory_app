class OnboardModel {
  final String? id;
  final String? title;
  final String? description;
  final String? image;
  final String? status;

  OnboardModel({
    this.id,
    this.title,
    this.description,
    this.image,
    this.status,
  });

  factory OnboardModel.fromJson(Map<String, dynamic> json) {
    return OnboardModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      status: json['status']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
      'status': status,
    };
  }
}