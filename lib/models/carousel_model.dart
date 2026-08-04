class CarouselModel {
  final int id;
  final String title;
  final String description;
  final String imageUrl;
  final int status;

  CarouselModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.status,
  });

  factory CarouselModel.fromJson(Map<String, dynamic> json) {
    return CarouselModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      imageUrl: json['image']?.toString() ?? '',
      status: int.tryParse(json['status'].toString()) ?? 0,
    );
  }
}