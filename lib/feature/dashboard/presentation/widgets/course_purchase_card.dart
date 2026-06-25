import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CoursePurchaseCard extends StatelessWidget {
  const CoursePurchaseCard({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> courses = [
      {"name": "Flutter Development", "percentage": 32.5},
      {"name": "Digital Marketing", "percentage": 24.1},
      {"name": "UI/UX Design", "percentage": 18.7},
      {"name": "Web Development", "percentage": 14.2},
      {"name": "Data Science", "percentage": 10.5},
    ];

    return Container(
      height: 500,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0x05000000),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Courses Purchase Price',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Gap(20),
          Expanded(
            child: ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 4,
                        backgroundColor: const Color(0xCC000000),
                      ),
                      const Gap(12),
                      Expanded(
                        child: Text(
                          course["name"] as String,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${(course["percentage"] as double).toStringAsFixed(1)}%',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
