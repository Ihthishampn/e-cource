import 'package:e_cource/feature/cource/data/model/course_model.dart';
import 'package:e_cource/feature/cource/presentation/widgets/inner_screen_course/cource_exam_widget.dart';
import 'package:e_cource/feature/lesson/presentation/provider/lesson_provider.dart';
import 'package:e_cource/feature/module/presentation/provider/module_provider.dart';
import 'package:e_cource/feature/module/presentation/view/course_contents_widget.dart';
import 'package:e_cource/feature/cource/presentation/widgets/inner_screen_course/course_live_widget.dart';
import 'package:e_cource/general/core/theme/app_colors.dart';
import 'package:e_cource/general/widgets/custom_main_header.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:e_cource/feature/cource/presentation/provider/course_provider.dart';

class CourseDetailsScreen extends StatelessWidget {
  final CourseModel course;

  const CourseDetailsScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CourseProvider(),
      child: _CourseDetailsView(course: course),
    );
  }
}

class _CourseDetailsView extends StatelessWidget {
  final CourseModel course;

  const _CourseDetailsView({required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      body: CustomScrollView(
        slivers: [
          const CustomMainHeader(),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Course Details',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ModuleProvider>().clear();
                      context.read<LessonProvider>().clear();
                      context.pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                    ),
                    child: const Text(
                      'Back',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: Divider(height: 1)),
          SliverFillRemaining(
            child: Row(
              children: [
                _buildLeftColumn(),
                const VerticalDivider(width: 1),
                _buildRightColumn(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeftColumn() {
    return Container(
      width: 350,
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  course.image,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    height: 200,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.image),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            course.duration,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text('Category : ${course.categoryName}'),
                      const SizedBox(height: 8),
                      Text('Tutor : ${course.tutor}'),
                      const SizedBox(height: 8),
                      Text('Tax : ₹${course.tax}'),
                      const SizedBox(height: 8),
                      Text('Apple Price : ₹${course.applePrice}'),
                      const SizedBox(height: 8),
                      Text('Apple Offer Price : ₹${course.appleOfferPrice}'),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '₹${course.price}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (course.offerPrice > 0)
                              Text(
                                'Offer ₹${course.offerPrice}',
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.buttonBlue,
                          ),
                          child: const Text(
                            'Update And Edit',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Features', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _feature('Live Classes', course.hasLiveClasses),
          _feature('Study Materials', course.hasStudyMaterials),
          _feature('Available On PC', course.availableOnPC),
          _feature('Popular', course.isPopular),
          _feature('List On IOS', course.listOnIOS),
          _feature('Life Long Access', course.isLifeLong),
          const SizedBox(height: 24),
          const Text('Tags', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: course.tags.map((e) => Chip(label: Text(e))).toList(),
          ),
          const SizedBox(height: 24),
          const Text('Keywords', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: course.keywords.map((e) => Chip(label: Text(e))).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRightColumn(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _buildTab(context, 'Contents', 0),
                    const SizedBox(width: 8),
                    _buildTab(context, 'Live', 1),
                    const SizedBox(width: 8),
                    _buildTab(context, 'Exam', 2),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: _buildSelectedScreen(
                context: context,
                courseId: course.id,
                moduleId: '',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(BuildContext context, String title, int index) {
    final selected = context.watch<CourseProvider>().selectedTabIndex == index;

    return GestureDetector(
      onTap: () {
        context.read<CourseProvider>().setTabIndex(index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primaryColor
              : AppColors.primaryColor.withValues(alpha: .5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _feature(String title, bool value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            value ? Icons.check_circle : Icons.cancel,
            color: value ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 8),
          Text(title),
        ],
      ),
    );
  }

  Widget _buildSelectedScreen({
    required BuildContext context,
    required String courseId,
    required String moduleId,
  }) {
    final tab = context.watch<CourseProvider>().selectedTabIndex;

    switch (tab) {
      case 0:
        return CourseContentsWidget(courseId: courseId);

      case 1:
        return CourseLiveWidget(course: course);

      case 2:
        return CourseExamWidget(courseId: courseId,moduleId: moduleId,);

      default:
        return const SizedBox();
    }
  }
}
