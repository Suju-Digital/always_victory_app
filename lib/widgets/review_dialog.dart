import 'package:always_victory/controller/auth_controller.dart';
import 'package:always_victory/data/api_services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_colors.dart';
import '../controller/class_controller.dart';
import '../helpers/utils.dart';

class ReviewDialog extends StatefulWidget {
  const ReviewDialog({super.key});

  static void show(BuildContext context) {
    Get.dialog(
      const ReviewDialog(),
      barrierDismissible: true,
    );
  }

  @override
  State<ReviewDialog> createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<ReviewDialog> {
  int _rating = 0;
  bool _isLoading = false;
  final TextEditingController _commentController = TextEditingController();
  final List<String> _tags = ["Great Content", "Easy to Use", "Helpful", "Kids Love It"];
  final List<String> _selectedTags = [];

  Future<void> _submitFeedback() async {
    final authController = Get.find<AuthController>();
    final studentId = int.tryParse(authController.student.value.id ?? '0') ?? 0;

    if (studentId == 0) {
      Utils.showError("Please login to submit feedback");
      return;
    }

    setState(() => _isLoading = true);

    final success = await ApiServices.submitReview(
      studentId: studentId,
      rating: _rating,
      tags: _selectedTags.join(", "),
      comment: _commentController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (success) {
      // Refresh reviews in the controller
      Get.find<ClassController>().loadReviews();
      
      Get.back();
      _showSuccessPopup();
    } else {
      Utils.showError("Something went wrong while submitting your review.");
    }
  }

  void _showSuccessPopup() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.correct.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.favorite_rounded, color: AppColors.correct, size: 50),
              ),
              const SizedBox(height: 24),
              const Text(
                "Thank You! ❤️",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                "Your feedback makes us smile! We'll keep working hard to make learning fun.",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textGrey, fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text("CLOSE"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with colorful gradient icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary.withOpacity(0.1), AppColors.accentIndigo.withOpacity(0.1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.rate_review_rounded,
                  color: AppColors.primary,
                  size: 36,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Parent Feedback",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textDark,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "How is your child's experience with the app?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textGrey.withOpacity(0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 28),

              // Animated Colorful Stars
              FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    final isSelected = index < _rating;
                    return TweenAnimationBuilder(
                      tween: Tween<double>(begin: 1.0, end: isSelected ? 1.2 : 1.0),
                      duration: const Duration(milliseconds: 200),
                      builder: (context, scale, child) {
                        return Transform.scale(
                          scale: scale,
                          child: IconButton(
                            style: IconButton.styleFrom(padding: EdgeInsets.zero),
                            onPressed: () => setState(() => _rating = index + 1),
                            icon: Icon(
                              isSelected ? Icons.star_rounded : Icons.star_outline_rounded,
                              color: isSelected ? Colors.amber : Colors.grey.shade300,
                              size: 44,
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),
              const SizedBox(height: 24),

              // Colorful Tags
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: List.generate(_tags.length, (index) {
                  final tag = _tags[index];
                  final isSelected = _selectedTags.contains(tag);
                  // Dynamic color based on index
                  final tagColors = [AppColors.optionA, AppColors.optionB, AppColors.optionC, AppColors.optionD];
                  final color = tagColors[index % tagColors.length];

                  return FilterChip(
                    label: Text(tag),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedTags.add(tag);
                        } else {
                          _selectedTags.remove(tag);
                        }
                      });
                    },
                    selectedColor: color.withOpacity(0.2),
                    checkmarkColor: color,
                    labelStyle: TextStyle(
                      color: isSelected ? color : AppColors.textGrey,
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                    ),
                    backgroundColor: Colors.grey.shade100,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                    side: isSelected ? BorderSide(color: color.withOpacity(0.3)) : BorderSide.none,
                  );
                }),
              ),
              const SizedBox(height: 24),

              // Comment Box
              TextField(
                controller: _commentController,
                maxLines: 3,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: "Anything else you'd like to share?",
                  hintStyle: TextStyle(color: AppColors.textHint, fontSize: 13),
                  filled: true,
                  fillColor: AppColors.bgLight,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Gradient Submit Button
              Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  gradient: _rating == 0 ? null : AppColors.appGradient,
                  color: _rating == 0 ? Colors.grey.shade300 : null,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: _rating == 0 ? null : [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: (_rating == 0 || _isLoading) ? null : _submitFeedback,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  ),
                  child: _isLoading 
                    ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                    : const Text(
                        "SUBMIT REVIEW",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1),
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
