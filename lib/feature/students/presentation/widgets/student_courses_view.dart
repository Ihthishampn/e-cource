
import 'package:flutter/material.dart';

class StudentCoursesView extends StatelessWidget {
  final VoidCallback? onAllocateNewCourse;

  const StudentCoursesView({super.key, this.onAllocateNewCourse});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tab Headers Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color:  Colors.green, 
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Courses',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),

            // Right button: Allocate New Course
            OutlinedButton(
              onPressed: onAllocateNewCourse,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.black87, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              child: const Text(
                'Allocate New Course',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 120),

        // Empty state placeholder
        const Center(
          child: Text(
            'No Course Available.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black38,
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
