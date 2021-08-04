import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  bool get isHiRes => MediaQuery.of(this).size.width > 800;

  bool get isDesktop =>
      MediaQuery.of(this).size.width <= 800 &&
      MediaQuery.of(this).size.width > 600;

  bool get isTablet =>
      MediaQuery.of(this).size.width <= 600 &&
      MediaQuery.of(this).size.width > 400;

  bool get isPhone => MediaQuery.of(this).size.width <= 400;
}
