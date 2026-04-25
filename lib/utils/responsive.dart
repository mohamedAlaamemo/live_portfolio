import 'package:flutter/material.dart';

class ResponsiveUtils {
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 768;
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 768 && 
           MediaQuery.of(context).size.width < 1024;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1024;
  }

  static double getResponsivePadding(BuildContext context) {
    if (isDesktop(context)) return 80;
    if (isTablet(context)) return 40;
    return 24;
  }

  static double getResponsiveFontSize(BuildContext context, {
    required double mobile,
    required double tablet,
    required double desktop,
  }) {
    if (isDesktop(context)) return desktop;
    if (isTablet(context)) return tablet;
    return mobile;
  }

  static int getGridCrossAxisCount(BuildContext context, {
    int? mobile,
    int? tablet,
    int? desktop,
  }) {
    if (isDesktop(context)) return desktop ?? 3;
    if (isTablet(context)) return tablet ?? 2;
    return mobile ?? 1;
  }
}
