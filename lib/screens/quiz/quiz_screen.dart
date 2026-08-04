import 'package:always_victory/data/app_config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../controller/question_controller.dart';
import '../../models/question_model.dart';
import '../../routes/app_routes.dart';
import '../../widgets/timer_widget.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final QuestionController controller = Get.find<QuestionController>();
  final TextEditingController textController = TextEditingController();
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  bool _isScrolling = false;
  int _lastScrolledIndex = -1;
  int _lastScrollTarget = -1;

  @override
  void initState() {
    super.initState();
    // Listen to position changes
    itemPositionsListener.itemPositions.addListener(() {
      final positions = itemPositionsListener.itemPositions.value;
      if (positions.isNotEmpty) {
        final firstVisible = positions.first.index;
        if (firstVisible != _lastScrolledIndex) {
          _lastScrolledIndex = firstVisible;
        }
      }
    });
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  // Safe scroll method - scrolls ONLY if the index is NOT comfortably visible
  void _scrollToIndex(int index) {
    if (_isScrolling) return;

    try {
      final totalItems = controller.questions.length;
      if (totalItems == 0) return;

      if (itemScrollController.isAttached) {
        final positions = itemPositionsListener.itemPositions.value;
        if (positions.isNotEmpty) {
          // Find the position of the specific target index
          final targetPos = positions.where((p) => p.index == index).toList();

          if (targetPos.isNotEmpty) {
            final p = targetPos.first;
            // If the item is comfortably within the viewport (between 5% and 95%), don't scroll
            if (p.itemLeadingEdge >= 0.05 && p.itemTrailingEdge <= 0.95) {
              return;
            }
          } else {
            // If targetPos is empty, it means the item is completely off-screen
            // We proceed to scroll
          }
        }

        _isScrolling = true;
        _lastScrollTarget = index;

        itemScrollController.scrollTo(
          index: index,
          alignment: 0.2, // Align to 20% from the left
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    } catch (e) {
      debugPrint('Scroll error: $e');
    } finally {
      Future.delayed(const Duration(milliseconds: 500), () {
        _isScrolling = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f7fb),
      appBar: AppBar(
        title: const Text("Quiz Time 🎯"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        actions: [
          IconButton(
            onPressed: () {
              controller.index.value = 0;
              controller.score.value = 0;
              controller.answersList.clear();
              controller.answerPerQuestion.clear();
              controller.skippedQuestions.clear();
              controller.startTimer();
              Get.offNamed(AppRoutes.quiz);
            },
            icon: const Icon(Icons.refresh, color: AppColors.primary),
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          controller.stopTimer();
          Navigator.of(context).pop();
          return false;
        },
        child: Obx(() {
          if (controller.questions.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.quiz_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "No Question Available",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          final question = controller.questions[controller.index.value];
          final currentIndex = controller.index.value;

          // Auto-scroll to current index after build
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!_isScrolling) {
              _scrollToIndex(currentIndex);
            }
          });

          // Restore text for short/long answers
          if (question.questionTypeId != 1) {
            final stored = controller.answerPerQuestion.length > currentIndex
                ? controller.answerPerQuestion[currentIndex]
                : '';
            if (textController.text != stored) {
              textController.text = stored;
            }
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // 🔥 Progress Row with visibility-aware scroll
                SizedBox(
                  height: 45,
                  child: ScrollablePositionedList.builder(
                    key: ValueKey('progress_list_${controller.questions.length}_${controller.quizSessionId.value}'), // Reset on new session
                    itemScrollController: itemScrollController,
                    itemPositionsListener: itemPositionsListener,
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.questions.length,
                    initialScrollIndex: currentIndex,
                    itemBuilder: (context, i) {
                      // Status checks
                      final isCurrent = i == controller.index.value;
                      final isSkipped = controller.skippedQuestions.length > i &&
                          controller.skippedQuestions[i];
                      final hasAnswer = controller.answerPerQuestion.length > i &&
                          controller.answerPerQuestion[i].isNotEmpty;
                      final isPast = i < controller.index.value;

                      // Determine color and style
                      Color bgColor;
                      Color textColor = Colors.white;
                      BoxBorder? border;

                      if (isCurrent) {
                        bgColor = AppColors.primary;
                        border = Border.all(color: AppColors.primaryDark, width: 2.5);
                      } else if (isPast) {
                        // Past questions - Show status (Answered or Skipped)
                        if (hasAnswer) {
                          bgColor = AppColors.correct;
                          textColor = Colors.white;
                        } else if (isSkipped) {
                          bgColor = AppColors.skipped;
                          textColor = Colors.white;
                        } else {
                          // Past but neither (safety fallback)
                          bgColor = AppColors.unanswered;
                        }
                      } else {
                        // Future questions (Always grey)
                        bgColor = AppColors.border.withOpacity(0.5);
                        textColor = AppColors.textGrey;
                      }

                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: bgColor,
                          border: border,
                          boxShadow: isCurrent
                              ? [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.3),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  )
                                ]
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            '${i + 1}',
                            style: TextStyle(
                              color: textColor,
                              fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12),

                // ⏱ Timer (only for MCQ) and Question Counter
                Row(
                  children: [
                    if (question.questionTypeId == 1)
                      Obx(
                            () => TimerWidget(
                          secondsLeft: controller.secondsLeft.value,
                        ),
                      )
                    else
                      const SizedBox(width: 40),
                    
                    // 🔥 Smooth Progress Bar
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: (currentIndex + 1) / controller.questions.length,
                            backgroundColor: AppColors.primary.withOpacity(0.12),
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                            minHeight: 12,
                          ),
                        ),
                      ),
                    ),

                    // Question counter with progress
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                      ),
                      child: Text(
                        "Q${currentIndex + 1}/${controller.questions.length}",
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // 🧠 Question Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    question.question ?? "",
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // 🔽 Answers
                Expanded(
                  flex: 2,
                  child: _buildAnswerUI(question),
                ),

                // 📷 Image below options
                if (question.questionImage != null &&
                    question.questionImage!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      print("Image :${AppConfig.studentImageBaseUrl}${question.questionImage}");
                      _showFullScreenImage(context, "${AppConfig.studentImageBaseUrl}${question.questionImage}");
                    },
                    child: Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(8), // Inner framing
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Hero(
                              tag: 'quiz_image_$currentIndex',
                              child: Image.network(
                                "${AppConfig.studentImageBaseUrl}${question.questionImage}",
                                height: 160,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 160,
                                    color: Colors.grey.shade50,
                                    child: const Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.broken_image_outlined,
                                              size: 48, color: Colors.grey),
                                          SizedBox(height: 8),
                                          Text("Failed to load image",
                                              style: TextStyle(
                                                  color: Colors.grey, fontSize: 13)),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    height: 160,
                                    color: Colors.grey.shade50,
                                    child: const Center(
                                      child: CircularProgressIndicator(strokeWidth: 3),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          // Expand Icon Overlay
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.zoom_out_map,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                // 👉 Previous, Skip, Next Buttons
                Row(
                  children: [
                    // Previous
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade200,
                          foregroundColor: Colors.black87,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: currentIndex > 0
                            ? () {
                          controller.goBack();
                          _lastScrollTarget = -1; // Reset scroll target
                          _scrollToIndex(currentIndex - 1);
                        }
                            : null,
                        child: const Text("⬅️ Prev"),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Skip
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.unanswered.withOpacity(0.1),
                          foregroundColor: AppColors.unanswered,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          Get.dialog(
                            Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24)),
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: AppColors.unanswered.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.help_outline_rounded,
                                        color: AppColors.unanswered,
                                        size: 40,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    const Text(
                                      "Skip Question?",
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    const Text(
                                      "No problem! You can skip this question for now. You can always use the 'Prev' button to come back and answer it later.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: AppColors.textGrey,
                                        fontSize: 15,
                                        height: 1.4,
                                      ),
                                    ),
                                    const SizedBox(height: 28),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: OutlinedButton(
                                            onPressed: () => Get.back(),
                                            style: OutlinedButton.styleFrom(
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 14),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              side: BorderSide(
                                                  color: Colors.grey.shade300),
                                            ),
                                            child: const Text(
                                              "Cancel",
                                              style: TextStyle(color: Colors.black87),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Get.back();
                                              _lastScrollTarget = -1;
                                              controller.skipQuestion();
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: AppColors.primary,
                                              foregroundColor: Colors.white,
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 14),
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: const Text("Skip"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        child: const Text("⏭️ Skip"),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Next / Submit
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          // Validate based on question type
                          if (question.questionTypeId == 1) {
                            if (controller.selected.value.isEmpty) {
                              Get.snackbar(
                                "Oops 😅",
                                "Select an answer",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red.shade100,
                                colorText: Colors.red.shade900,
                              );
                              return;
                            }
                          } else {
                            // text answer
                            controller.selectAnswer(textController.text);
                            if (textController.text.isEmpty) {
                              Get.snackbar(
                                "Oops 😅",
                                "Write your answer",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red.shade100,
                                colorText: Colors.red.shade900,
                              );
                              return;
                            }
                          }

                          // Save answer to local tracking
                          if (controller.answerPerQuestion.length > currentIndex) {
                            controller.answerPerQuestion[currentIndex] =
                                question.questionTypeId == 1
                                    ? controller.selected.value
                                    : textController.text;
                          }

                          // Proceed to next or submit (controller handles both)
                          _lastScrollTarget = -1; // Reset scroll target
                          controller.next();
                          
                          // Clear text controller for next question if not MCQ
                          if (question.questionTypeId != 1 && currentIndex < controller.questions.length - 1) {
                            textController.clear();
                          }
                        },
                        child: Text(
                          currentIndex == controller.questions.length - 1
                              ? "Submit ✓"
                              : "Next ➡️",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  /// 📱 Full Screen Image Viewer with Timer Pause
  void _showFullScreenImage(BuildContext context, String imageUrl) {
    controller.pauseTimer();

    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, animation, secondaryAnimation) => Scaffold(
          backgroundColor: Colors.black.withOpacity(0.95),
          body: Stack(
            children: [
              Center(
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: Hero(
                    tag: 'quiz_image_${controller.index.value}',
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.broken_image,
                                  size: 80,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Image not available",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 40,
                right: 20,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    controller.resumeTimer();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Pinch to zoom • Tap to close",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    ).then((_) {
      // Resume timer when coming back
      controller.resumeTimer();
    });
  }

  /// 🔥 Answer UI
  Widget _buildAnswerUI(QuestionModel question) {
    if (question.questionTypeId == 1) {
      return ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _optionTile(question.option1, AppColors.optionA),
          const SizedBox(height: 6),
          _optionTile(question.option2, AppColors.optionB),
          const SizedBox(height: 6),
          _optionTile(question.option3, AppColors.optionC),
          const SizedBox(height: 6),
          _optionTile(question.option4, AppColors.optionD),
        ],
      );
    } else if (question.questionTypeId == 2) {
      return _inputField("Enter short answer", 2);
    } else {
      return _inputField("Write detailed answer...", 5);
    }
  }

  /// ✍️ Input Field
  Widget _inputField(String hint, int lines) {
    return TextField(
      controller: textController,
      maxLines: lines,
      onChanged: (value) {
        // Save text as user types
        final currentIndex = controller.index.value;
        if (controller.answerPerQuestion.length > currentIndex) {
          controller.answerPerQuestion[currentIndex] = value;
        }
        if (controller.skippedQuestions.length > currentIndex) {
          controller.skippedQuestions[currentIndex] = false;
        }
      },
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }

  /// 🎯 Animated Option Tile
  Widget _optionTile(String? text, Color color) {
    final controller = Get.find<QuestionController>();

    return Obx(() {
      final isSelected = controller.selected.value == text;

      return GestureDetector(
        onTap: () => controller.selectAnswer(text ?? ""),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.12) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? color : Colors.grey.shade300,
              width: isSelected ? 2.5 : 1.5,
            ),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
            ],
          ),
          child: Row(
            children: [
              // Radio-like circle indicator
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? color : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? color : Colors.grey.shade400,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  text ?? "",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? color : Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}