class AppConfig {
  AppConfig._();

  // ================= APP =================

  static const String appName = "Always Victory";
  static const String appVersion = "1.0.0";

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

}