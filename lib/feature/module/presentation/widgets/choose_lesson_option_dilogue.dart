import 'package:e_cource/feature/module/presentation/widgets/add_lesson_dilogue.dart';
import 'package:flutter/material.dart';

class ChooseLessonOptionDialog extends StatelessWidget {
  final String courseId;
  final String moduleId;
  const ChooseLessonOptionDialog({super.key, required this.courseId, required this.moduleId});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        width: 550,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Spacer(),

                  const Text(
                    "Choose Option",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),

                  const Spacer(),

                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.cancel_outlined),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ChooseOptionCard(
                    icon: Icons.add,
                    title: "Create New",
                    onTap: () {
                      Navigator.pop(context);

                      showDialog(
                        context: context,
                        builder: (_) =>  AddLessonDialog(
                          moduleId: moduleId,
                          courseId: courseId,
                        ),
                      );
                    },
                  ),

                  const SizedBox(width: 30),

                  ChooseOptionCard(
                    icon: Icons.download,
                    title: "Import From Another",
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class ChooseOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const ChooseOptionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Column(
        children: [
          Container(
            width: 110,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Icon(icon, size: 45, color: Colors.blue),
          ),

          const SizedBox(height: 10),

          Text(title),
        ],
      ),
    );
  }
}
