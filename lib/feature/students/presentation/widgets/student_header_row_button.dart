import 'package:e_cource/general/core/theme/app_text_styles.dart';
import 'package:e_cource/general/widgets/custom_button.dart';
import 'package:e_cource/general/widgets/custom_search.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class StudentHeaderRowButton extends StatelessWidget {
  const StudentHeaderRowButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text("Users", style: AppTextStyles.heading2),

        Spacer(),
        CustomButton(title: "📗 Download Excel", size: Size(180, 40)),
        Gap(8),
        CustomButton(title: "New ⌄", size: Size(90, 40)),
        Gap(8),

        CustomButton(title: "⇅ filter", size: Size(110, 40)),
        Gap(8),

        CustomSearch(),
      ],
    );
  }
}
