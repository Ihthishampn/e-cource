import 'package:e_cource/general/widgets/button_with_icon.dart';
import 'package:flutter/material.dart';

class CourseExamWidget extends StatelessWidget {
  const CourseExamWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(
                "Exams",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: .bold,
                  fontSize: 18,
                ),
              ),

              ButtonWithIcon(
                name: "Add a final exam",
                ontap: () {},
                icon: Icons.add,
              ),
            ],
          ),
        ],
      ),
    );
  }
}