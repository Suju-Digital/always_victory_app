class PurchasedBookModel {
  final int ebookId;
  final String expiryDate;

  PurchasedBookModel({
    required this.ebookId,
    required this.expiryDate,
  });

  factory PurchasedBookModel.fromJson(
      Map<String,dynamic> json){
    return PurchasedBookModel(
      ebookId: json['ebook_id'],
      expiryDate: json['expiry_date'],
    );
  }
}