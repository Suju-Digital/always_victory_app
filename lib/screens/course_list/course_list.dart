import 'package:always_victory/constants/app_colors.dart';
import 'package:always_victory/screens/course_list/purchased_books_tab.dart';
import 'package:always_victory/screens/course_list/purchased_classes_tab.dart';
import 'package:flutter/material.dart';


class MyPurchasesScreen extends StatelessWidget {
  const MyPurchasesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xffF5F7FA),

    appBar: AppBar(
      title: const Text(
      "My Learning",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: AppColors.primary,
      scrolledUnderElevation: 0,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.appGradient,
        ),
      ),

      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          height: 52,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.18),
            borderRadius: BorderRadius.circular(16),
          ),
          child: TabBar(
            dividerColor: Colors.transparent,
            indicatorSize: TabBarIndicatorSize.tab,

            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.white,

            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),

            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),

            indicator: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),

            tabs: const [
              Tab(
                icon: Icon(Icons.play_circle_fill),
                text: "Classes",
              ),
              Tab(
                icon: Icon(Icons.menu_book_rounded),
                text: "Books",
              ),
            ],
          ),
        ),
      ),
    ),

        body: TabBarView(
          children: [
            PurchasedClassesTab(),
            PurchasedBooksTab(),
          ],
        ),
      ),
    );
  }
}