import 'package:e_cource/feature/students/presentation/widgets/student_courses_view.dart';
import 'package:e_cource/feature/students/presentation/widgets/student_profile_info.dart';
import 'package:e_cource/general/core/theme/app_colors.dart';
import 'package:e_cource/general/core/theme/app_text_styles.dart';
import 'package:e_cource/general/widgets/custom_main_header.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class StudentDetailsScreen extends StatelessWidget {
  final Map<String, String> studentData;

  const StudentDetailsScreen({super.key, required this.studentData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          const CustomMainHeader(),

          // Title & Back Button Row
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Users",
                    style: AppTextStyles.heading2,
                  ),
                  ElevatedButton(
                    onPressed: () => context.pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                    ),
                    child: const Text(
                      "Back",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Student Profile Section
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverToBoxAdapter(
              child: StudentProfileInfo(studentData: studentData),
            ),
          ),

          const SliverGap(40),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverToBoxAdapter(
              child: Divider(
                color: Colors.grey.shade200,
                thickness: 1,
              ),
            ),
          ),

          const SliverGap(30),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverToBoxAdapter(
              child: StudentCoursesView(
                onAllocateNewCourse: () {
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
