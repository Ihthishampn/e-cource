
import 'package:e_cource/feature/cource/presentation/provider/course_firebase_provider.dart';
import 'package:e_cource/feature/cource/presentation/provider/course_provider.dart';
import 'package:e_cource/general/enums/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryDropdown extends StatelessWidget {
  const CategoryDropdown({super.key, required this.cp});
  final CourseProvider cp;

  @override
  Widget build(BuildContext context) {
    return Consumer<CourseFirebaseProvider>(
      builder: (context, fp, _) {
        if (fp.getCategoryState == AppState.loading) {
          return Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 12),
                Text('Loading categories...',
                    style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }

        final categories = fp.mcList;

        return DropdownButtonFormField<String>(
          initialValue: cp.selectedCategory?.id,
          isExpanded: true,
          hint: Text(
            'Select Category',
            style: TextStyle(
                color: Colors.grey.shade400, fontStyle: FontStyle.italic),
          ),
          decoration: _dropdownDecoration(),
          items: categories
              .map((c) =>
                  DropdownMenuItem<String>(value: c.id, child: Text(c.name)))
              .toList(),
          onChanged: (id) {
            if (id == null) return;
            cp.setSelectedCategory(categories.firstWhere((c) => c.id == id));
          },
        );
      },
    );
  }
}



InputDecoration _dropdownDecoration() {
  return InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  );
}