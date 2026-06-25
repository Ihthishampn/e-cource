import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import '../widgets/add_course_card.dart';
import '../widgets/course_action_bar.dart';
import '../widgets/course_card.dart';
import '../widgets/course_header.dart';

class CourceScreen extends StatelessWidget {
  const CourceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: CourseHeader(),
          ),
          const SliverToBoxAdapter(
            child: CourseActionBar(),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
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
                  
                  return const CourseCard(
                    title: 'Course Consulting',
                    duration: '0h 0m',
                    lessons: 0,
                    category: 'Consulting',
                    priceType: 'Paid',
                    price: '₹62,000/-',
                    imageUrl: 'https://images.unsplash.com/photo-1552664730-d307ca884978?q=80&w=2940&auto=format&fit=crop',
                  );
                },
                childCount: 6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
