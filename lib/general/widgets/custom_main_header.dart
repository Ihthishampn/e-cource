import 'package:e_cource/general/core/services/admin_greeting_message.dart';
import 'package:e_cource/general/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CustomMainHeader extends StatelessWidget {
  final List<Widget>? actions;
  final String? titleText;
  final Widget? leading;
  final TextStyle? titleStyle;
  final double? titleSpacing;
  final Color? backgroundColor;
  final bool? pinned;
  final VoidCallback? leadingOnTap;

  final Widget? titleWidget;
  final double? leadingWidth;
  final bool? isLeadingAvailable;
  final bool? centerTitle;
  const CustomMainHeader({
    super.key,
    this.actions,
    this.titleText,
    this.leadingOnTap,
    this.titleStyle,
    this.titleSpacing,
    this.backgroundColor,
    this.pinned,
    this.leading,
    this.titleWidget,
    this.leadingWidth,
    this.isLeadingAvailable,
    this.centerTitle,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        color: AppColors.backgroudColor,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Hello user name,',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const Gap(2),
                Text(
                  getGreetingMessage(),
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    getCurrentTime(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const Gap(2),
                  Text(
                    getCurrentDate(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
