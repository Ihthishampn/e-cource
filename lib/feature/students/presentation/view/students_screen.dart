import 'package:e_cource/feature/students/presentation/widgets/student_header_row_button.dart';
import 'package:e_cource/feature/students/presentation/widgets/student_list_card.dart';
import 'package:e_cource/general/core/theme/app_colors.dart';
import 'package:e_cource/general/widgets/custom_main_header.dart';
import 'package:e_cource/general/core/services/go_route/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';

class StudentsScreen extends StatelessWidget {
  const StudentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        scrollCacheExtent: ScrollCacheExtent.pixels(1000),
        slivers: [
          const CustomMainHeader(),

          SliverPersistentHeader(
            pinned: true,
            delegate: _PinnedHeaderDelegate(
              child: Container(
                color: AppColors.white,
                padding: const EdgeInsets.all(10),
                child: StudentHeaderRowButton(),
              ),
            ),
          ),

          // Student list
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final studentData = {
                'name': index == 1 ? 'ameer musthafa' : index == 2 ? 'Hima K Manoj' : index == 3 ? 'Rahul K P' : 'amal dev',
                'phone': index == 1 ? '+919995576333' : index == 2 ? '+917907087819' : index == 3 ? '+917994408211' : '+918590941583',
                'email': index == 1 ? 'ameerbssplanworld@gmail.com' : index == 2 ? 'himadigital3@gmail.com' : index == 3 ? 'rahul@code7.ai' : '---',
                'joinedAt': index == 1 ? '23-06-2026' : index == 2 ? '23-06-2026' : index == 3 ? '23-06-2026' : '25-06-2026',
                'status': 'Enable',
              };

              return GestureDetector(
                onTap: () {
                  context.go(
                    RouteNames.studentDetails,
                    extra: studentData,
                  );
                },
                child: StudentListCard(
                  name: studentData['name']!,
                  phone: studentData['phone']!,
                  email: studentData['email']!,
                  joinedAt: studentData['joinedAt']!,
                  status: studentData['status']!,
                  onDelete: () {},
                  onEdit: () {},
                ),
              );
            }, childCount: 12),
          ),
        ],
      ),
    );
  }
}

class _PinnedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  const _PinnedHeaderDelegate({required this.child});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => child;

  @override
  double get maxExtent => 70;

  @override
  double get minExtent => 70;

  @override
  bool shouldRebuild(_PinnedHeaderDelegate oldDelegate) =>
      oldDelegate.child != child;
}
