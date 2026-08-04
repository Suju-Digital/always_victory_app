class ClassItem {
  final int classId;
  final String className;
  final String title;
  final String description;
  final String posterImage;
  final String originalPrice;
  final String discountPercent;
  final String finalPrice;

  ClassItem({
    required this.classId,
    required this.className,
    required this.title,
    required this.description,
    required this.posterImage,
    required this.originalPrice,
    required this.discountPercent,
    required this.finalPrice,
  });

  factory ClassItem.fromJson(Map<String, dynamic> json) {
    return ClassItem(
      classId: int.tryParse(json['class_id'].toString()) ?? 0,
      className: json['class_name'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      posterImage: json['poster_image'] ?? '',
      originalPrice: json['original_price'].toString(),
      discountPercent: json['discount_percent'].toString(),
      finalPrice: json['final_price'].toString(),
    );
  }
}
