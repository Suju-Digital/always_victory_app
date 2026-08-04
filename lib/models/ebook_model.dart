class EbookModel {
  final int id;
  final String title;
  final String description;
  final String thumbnail;
  final String pdfFile;
  final double price;
  final String status;
  final String createdAt;

  EbookModel({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnail,
    required this.pdfFile,
    required this.price,
    required this.status,
    required this.createdAt,
  });

  factory EbookModel.fromJson(Map<String, dynamic> json) {
    return EbookModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      pdfFile: json['pdf_file'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'thumbnail': thumbnail,
      'pdf_file': pdfFile,
      'price': price,
      'status': status,
      'created_at': createdAt,
    };
  }
}