import 'package:flutter/material.dart';

class AppBorderRadius {
  // Prevent instantiation
  AppBorderRadius._();

  // Radius values
  static const double xs = 8.0;
  static const double sm = 12.0;
  static const double md = 16.0;
  static const double lg = 20.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;

  // BorderRadius objects
  static BorderRadius get xsRadius => BorderRadius.circular(xs);
  static BorderRadius get smRadius => BorderRadius.circular(sm);
  static BorderRadius get mdRadius => BorderRadius.circular(md);
  static BorderRadius get lgRadius => BorderRadius.circular(lg);
  static BorderRadius get xlRadius => BorderRadius.circular(xl);
  static BorderRadius get xxlRadius => BorderRadius.circular(xxl);

  // Common use cases
  static BorderRadius get card => lgRadius;
  static BorderRadius get button => mdRadius;
  static BorderRadius get chip => smRadius;
  static BorderRadius get modal => xxlRadius;
}
