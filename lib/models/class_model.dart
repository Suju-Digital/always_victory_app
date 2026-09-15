class ClassModel {
  int id;
  String className;
  String title;
  String description;
  String posterImage;
  String createdAt;
  String? expiryDate;
  int? offerHours;

  double price;
  double originalPrice;
  int discountPercent;
  double finalPrice;
  String enrollStudent;

  ClassModel({
    required this.id,
    required this.className,
    required this.title,
    required this.description,
    required this.posterImage,
    required this.createdAt,
    this.expiryDate,
    this.offerHours,
    required this.price,
    required this.originalPrice,
    required this.discountPercent,
    required this.finalPrice,
    required this.enrollStudent,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      className: json['class_name']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      posterImage: json['poster_image']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      expiryDate: json['offer_ends_at']?.toString() ??
          json['expiry_date']?.toString() ??
          json['end_date']?.toString() ??
          json['offer_end_date']?.toString(),
      offerHours: int.tryParse(json['offer_hours']?.toString() ?? ''),
      enrollStudent: json['enrollStudent']?.toString() ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0,
      originalPrice:
          double.tryParse(json['original_price']?.toString() ?? '0') ?? 0,
      discountPercent:
          int.tryParse(json['discount_percent']?.toString() ?? '0') ?? 0,
      finalPrice:
          double.tryParse(json['final_price']?.toString() ?? '0') ?? 0,
    );
  }
}
