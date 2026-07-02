import 'package:e_cource/feature/cource/data/model/course_model.dart';
import 'package:e_cource/feature/cource/presentation/provider/course_firebase_provider.dart';
import 'package:e_cource/general/enums/app_state.dart';
import 'package:e_cource/general/widgets/custom_main_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/add_course_card.dart';
import '../widgets/course_action_bar.dart';
import '../widgets/course_card.dart';

class CourceScreen extends StatefulWidget {
  const CourceScreen({super.key});

  @override
  State<CourceScreen> createState() => _CourceScreenState();
}

class _CourceScreenState extends State<CourceScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CourseFirebaseProvider>().handleFetchCourse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseFirebaseProvider>();

    final List<CourseModel> courses =
        provider.searchQuery.isEmpty
            ? provider.courseList
            : provider.searchCourseList;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 247, 247),
      body: CustomScrollView(
        slivers: [
          const CustomMainHeader(),
          const SliverToBoxAdapter(
            child: CourseActionBar(),
          ),

          // Search loading
          if (provider.searchCourseState == AppState.loading)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )

          // Search result empty
          else if (provider.searchQuery.isNotEmpty && courses.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text(
                  "No courses found",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )

          // Initial course loading
          else if (provider.fetchCourseState == AppState.loading &&
              provider.courseList.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )

          // Course grid
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index == 0) {
                      return const AddCourseCard();
                    }

                    final course = courses[index - 1];

                    return CourseCard(course: course);
                  },
                  childCount: courses.length + 1,
                ),
              ),
            ),
        ],
      ),
    );
  }
}