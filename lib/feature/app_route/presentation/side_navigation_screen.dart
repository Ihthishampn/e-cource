import 'package:e_cource/general/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SideNavigationScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const SideNavigationScreen({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // side bar
          Material(
            color: AppColors.white,
            elevation: 0,
            child: Container(
              width: 250,
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  const Column(
                    children: [
                      Image(
                        image: AssetImage(
                          "assets/image/ecource_logo-removebg-preview.png",
                        ),
                        height: 130,
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SideNavigationMenuItem(
                            title: "Dashboard",
                            icon: Icons.home_outlined,
                            index: 0,
                            navigationShell: navigationShell,
                          ),
                          _SideNavigationMenuItem(
                            title: "Students",
                            icon: Icons.people_outline,
                            index: 1,
                            navigationShell: navigationShell,
                          ),
                          _SideNavigationMenuItem(
                            title: "Courses",
                            icon: Icons.menu_book_rounded,
                            index: 2,
                            navigationShell: navigationShell,
                          ),
                          _SideNavigationMenuItem(
                            title: "Settings",
                            icon: Icons.settings_outlined,
                            index: 3,
                            navigationShell: navigationShell,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Main content area
          Expanded(
            child: Container(
              color: AppColors.white,
              child: navigationShell,
            ),
          ),
        ],
      ),
    );
  }
}

class _SideNavigationMenuItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final int index;
  final StatefulNavigationShell navigationShell;

  const _SideNavigationMenuItem({
    required this.title,
    required this.icon,
    required this.index,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = navigationShell.currentIndex == index;
    final selectedColor = AppColors.primaryColor;
    final unselectedColor = AppColors.textColor;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? selectedColor : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isSelected ? AppColors.white : unselectedColor,
                  size: 22,
                ),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? AppColors.white : unselectedColor,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
