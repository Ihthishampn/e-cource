import 'package:e_cource/feature/cource/presentation/provider/course_firebase_provider.dart';
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

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 247, 247),
      body: CustomScrollView(
        slivers: [
          const CustomMainHeader(),
          const SliverToBoxAdapter(child: CourseActionBar()),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                childAspectRatio: 0.85,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                if (index == 0) {
                  return const AddCourseCard();
                }

                final course = provider.courseList[index - 1];

                return CourseCard(course: course);
              }, childCount: provider.courseList.length + 1),
            ),
          ),
        ],
      ),
    );
  }
}
