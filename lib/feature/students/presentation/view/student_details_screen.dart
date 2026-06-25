import 'package:e_cource/feature/students/presentation/widgets/student_courses_view.dart';
import 'package:e_cource/feature/students/presentation/widgets/student_profile_info.dart';
import 'package:e_cource/general/core/theme/app_colors.dart';
import 'package:e_cource/general/core/theme/app_text_styles.dart';
import 'package:e_cource/general/widgets/custom_main_header.dart';
import 'package:e_cource/general/core/services/go_route/route_names.dart';
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
          // Header with greeting, date & time
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
                    onPressed: () => context.go(RouteNames.students),
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

          // Divider Line
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

          // Courses & Course Allocation Section
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverToBoxAdapter(
              child: StudentCoursesView(
                onAllocateNewCourse: () {
                  // Allocation function placeholder
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
