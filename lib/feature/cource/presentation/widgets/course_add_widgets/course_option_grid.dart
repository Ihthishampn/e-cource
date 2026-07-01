
import 'package:e_cource/feature/cource/presentation/provider/course_provider.dart';
import 'package:e_cource/feature/cource/presentation/widgets/course_add_widgets/yes_not_widget.dart';
import 'package:flutter/material.dart';

class CourseOptionsGrid extends StatelessWidget {
  const CourseOptionsGrid({super.key, required this.cp});
  final CourseProvider cp;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          Expanded(
            child: YesNoRadioRow(
              label: 'Live Classes?',
              value: cp.hasLiveClasses,
              onChanged: cp.toggleLiveClasses,
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: YesNoRadioRow(
              label: 'Study Materials?',
              value: cp.hasStudyMaterials,
              onChanged: cp.toggleStudyMaterials,
            ),
          ),
        ]),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(
            child: YesNoRadioRow(
              label: 'Available On PC?',
              value: cp.availableOnPC,
              onChanged: cp.toggleAvailableOnPC,
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: YesNoRadioRow(
              label: 'Popular Course?',
              value: cp.isPopular,
              onChanged: cp.togglePopular,
            ),
          ),
        ]),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(
            child: YesNoRadioRow(
              label: 'List on iOS?',
              value: cp.listOnIOS,
              onChanged: cp.toggleListOnIOS,
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: YesNoRadioRow(
              label: 'Is Life Long?',
              value: cp.isLifeLong,
              onChanged: cp.toggleLifeLong,
            ),
          ),
        ]),
      ],
    );
  }
}
