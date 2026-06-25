import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class DashboardStatCard extends StatelessWidget {
  final String title;
  final String value;
  final int index;
  final bool isLoading;

  const DashboardStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.index,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    switch (index % 3) {
      case 0:
        bgColor = const Color(0xFFF3E8FF); // Lavender
        break;
      case 1:
        bgColor = const Color(0xFFE0E7FF); // Blue-Grey/Indigo wash
        break;
      case 2:
        bgColor = const Color(0xFFE0F2FE); // Light Blue
        break;
      default:
        bgColor = Colors.white;
    }

    return Container(
      width: 190,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Gap(12),
          if (isLoading)
            Container(
              height: 30,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(4),
              ),
            )
          else
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 24,
                color: Colors.black87,
              ),
            ),
        ],
      ),
    );
  }
}
