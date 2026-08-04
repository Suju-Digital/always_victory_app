class DayModel {
  int id;
  String dayName;
  String createdAt;
  String title;
  String description;
  String thumbnail;

  DayModel({
    required this.id,
    required this.dayName,
    required this.createdAt,
    required this.title,
    required this.description,
    required this.thumbnail,
  });

  factory DayModel.fromJson(Map<String, dynamic> json) {
    return DayModel(
      id: int.parse(json['id'].toString()),
      dayName: json['day_name'] ?? '',
      createdAt: json['created_at'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
    );
  }
}