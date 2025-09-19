// lib/theme/app_text_styles.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static TextStyle heading({double size = 18}) =>
      GoogleFonts.inter(fontSize: size, fontWeight: FontWeight.w600);

  static TextStyle body({double size = 14}) =>
      GoogleFonts.inter(fontSize: size, fontWeight: FontWeight.w400);

  static TextStyle button({double size = 14}) =>
      GoogleFonts.inter(fontSize: size, fontWeight: FontWeight.w600);
}
