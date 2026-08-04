class SubjectModel {
  final String id;
  final String name;
  final String icon;        // emoji
  final String className;
  final int totalQuestions;
  final String? description;
  final int colorHex;

  const SubjectModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.className,
    required this.totalQuestions,
    this.description,
    this.colorHex = 0xFF4F46E5,
  });
}
