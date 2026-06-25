import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:e_cource/general/core/theme/app_colors.dart';

class AppTextStyles {
  // Headings
  static final TextStyle heading1 = GoogleFonts.outfit(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textColor,
  );

  static final TextStyle heading2 = GoogleFonts.outfit(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textColor,
  );

  static final TextStyle heading3 = GoogleFonts.outfit(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textColor,
  );

  // Body Text
  static final TextStyle bodyText1 = GoogleFonts.outfit(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textColor,
  );

  static final TextStyle bodyText2 = GoogleFonts.outfit(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textColor,
  );

  // Subtitles / Labels
  static final TextStyle labelText = GoogleFonts.outfit(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.greyShade,
  );
  
  static final TextStyle buttonText = GoogleFonts.outfit(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );
}
