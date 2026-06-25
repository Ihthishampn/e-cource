import 'package:e_cource/feature/dashboard/data/dashboarditemslist/dashboard_item.dart';
import 'package:e_cource/feature/dashboard/presentation/widgets/course_purchase_card.dart';
import 'package:e_cource/feature/dashboard/presentation/widgets/dashboard_stat_card.dart';
import 'package:e_cource/feature/dashboard/presentation/widgets/main_category_card.dart';
import 'package:e_cource/feature/dashboard/presentation/widgets/weekly_graph_card.dart';
import 'package:e_cource/general/widgets/custom_main_header.dart';
import 'package:e_cource/general/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const CustomMainHeader(),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 20.0,
            ),
            sliver: SliverToBoxAdapter(
              child: Text('Dashboard', style: AppTextStyles.heading2),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: List.generate(
                  dummyData.length,
                  (index) => DashboardStatCard(
                    title: dummyData[index]["title"]!,
                    value: dummyData[index]["value"]!,
                    index: index,
                  ),
                ),
              ),
            ),
          ),
          const SliverGap(24),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Expanded(flex: 4, child: WeeklyGraphCard()),
                  Expanded(flex: 2, child: CoursePurchaseCard()),
                  Expanded(flex: 2, child: MainCategoryCard()),
                ],
              ),
            ),
          ),
          const SliverGap(40),
        ],
      ),
    );
  }
}
