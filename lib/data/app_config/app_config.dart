class AppConfig {
  AppConfig._();

  // ================= APP =================

  static const String appName = "Always Victory";
  static const String appVersion = "1.0.0";
  static const String playStoreUrl = "https://play.google.com/store/apps/details?id=com.sujudigitalmatketing.always_victory";

  // ================= API =================

  static const String baseUrl = "https://ycombinator.sujudigital.com/api/";
  static const String imageBaseUrl = "https://ycombinator.sujudigital.com/admin/";
  static const String studentImageBaseUrl = "https://ycombinator.sujudigital.com/uploads/";
  static const String studentProfileImageBaseUrl = "https://ycombinator.sujudigital.com/uploads/students/";
  static const String carsouleImageBaseUrl = "https://ycombinator.sujudigital.com/admin/";
  static const String dayImageBaseUrl = "https://ycombinator.sujudigital.com/";
  static const String pdfBaseUrl = "https://ycombinator.sujudigital.com/uploads/ebooks/pdf/";
  static const String pdfThumbnailBaseUrl = "https://ycombinator.sujudigital.com/uploads/ebooks/thumbnail/";

  static const Duration apiTimeout = Duration(seconds: 30);

  // ================= ENDPOINTS =================
  static const String onBoard = "onboard.php";

  static const String login = "login-api.php";
  static const String register = "registration-api.php";
  static const String getClass = "classes.php";
  static const String purchaseCLassCourse = "purchased_classes.php";
  static const String progress = "student_progress.php";
  static const String carousel = "crousel.php";
  static const String enrollStudent = "enroll_student.php";
  static const String getDays = "get_days.php";
  static const String getQuestion = "get_questions.php";
  static const String submitAnswer = "submit_answer.php";

  // Helper for safe URL encoding (handles filenames with spaces/special characters)
  static String getImageUrl(String baseUrl, String? imagePath) {
    if (imagePath == null || imagePath.trim().isEmpty) return '';
    final String cleanPath = imagePath.trim();
    if (cleanPath.startsWith('http://') || cleanPath.startsWith('https://')) {
      return Uri.encodeFull(cleanPath);
    }
    return Uri.encodeFull('$baseUrl$cleanPath');
  }

  // Safe Class Poster URL Resolution
  static String getClassPosterUrl(String? path) {
    if (path == null || path.trim().isEmpty) return '';
    final String clean = path.trim();
    if (clean.startsWith('http://') || clean.startsWith('https://')) {
      return Uri.encodeFull(clean);
    }
    if (clean.startsWith('uploads/')) {
      return Uri.encodeFull("https://ycombinator.sujudigital.com/$clean");
    }
    if (clean.startsWith('admin/')) {
      return Uri.encodeFull("https://ycombinator.sujudigital.com/$clean");
    }
    return Uri.encodeFull("https://ycombinator.sujudigital.com/uploads/$clean");
  }

  // Safe Ebook Thumbnail URL Resolution
  static String getEbookThumbnailUrl(String? path) {
    if (path == null || path.trim().isEmpty) return '';
    final String clean = path.trim();
    if (clean.startsWith('http://') || clean.startsWith('https://')) {
      return Uri.encodeFull(clean);
    }
    if (clean.startsWith('uploads/')) {
      return Uri.encodeFull("https://ycombinator.sujudigital.com/$clean");
    }
    if (clean.startsWith('admin/')) {
      return Uri.encodeFull("https://ycombinator.sujudigital.com/$clean");
    }
    if (clean.contains('ebooks/thumbnail/')) {
      return Uri.encodeFull("https://ycombinator.sujudigital.com/uploads/$clean");
    }
    return Uri.encodeFull("https://ycombinator.sujudigital.com/uploads/ebooks/thumbnail/$clean");
  }
}