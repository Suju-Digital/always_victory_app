class AboutModel {
  final int id;
  final String companyName;
  final String companyDetail;
  final String appName;
  final String appInfo;
  final String appVersion;
  final String appUrl;
  final String contact;
  final String email;
  final String address;
  final String website;
  final String logo;
  final String aboutImage;
  final String aboutVideo;
  final String createdAt;

  AboutModel({
    required this.id,
    required this.companyName,
    required this.companyDetail,
    required this.appName,
    required this.appInfo,
    required this.appVersion,
    required this.appUrl,
    required this.contact,
    required this.email,
    required this.address,
    required this.website,
    required this.logo,
    required this.aboutImage,
    required this.aboutVideo,
    required this.createdAt,
  });

  factory AboutModel.fromJson(Map<String, dynamic> json) {
    return AboutModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      companyName: json['company_name'] ?? '',
      companyDetail: json['company_detail'] ?? '',
      appName: json['app_name'] ?? '',
      appInfo: json['app_info'] ?? '',
      appVersion: json['app_version'] ?? '',
      appUrl: json['app_url'] ?? '',
      contact: json['contact'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      website: json['website'] ?? '',
      logo: json['logo'] ?? '',
      aboutImage: json['about_image'] ?? '',
      aboutVideo: json['about_video'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}