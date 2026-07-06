import 'package:flutter/material.dart';

class AppRadius {
  AppRadius._();

  // Base Radii
  static const Radius none = Radius.zero;
  static const Radius sm = Radius.circular(4.0);
  static const Radius md = Radius.circular(8.0);
  static const Radius lg = Radius.circular(12.0);
  static const Radius xl = Radius.circular(16.0);
  static const Radius pill = Radius.circular(999.0);

  // BorderRadius helpers
  static const BorderRadius borderNone = BorderRadius.zero;
  static const BorderRadius borderSm = BorderRadius.all(sm);
  static const BorderRadius borderMd = BorderRadius.all(md);
  static const BorderRadius borderLg = BorderRadius.all(lg);
  static const BorderRadius borderXl = BorderRadius.all(xl);
  static const BorderRadius borderPill = BorderRadius.all(pill);

  // ShapeBorder helpers
  static const ShapeBorder shapeNone = RoundedRectangleBorder();
  static const ShapeBorder shapeSm = RoundedRectangleBorder(borderRadius: borderSm);
  static const ShapeBorder shapeMd = RoundedRectangleBorder(borderRadius: borderMd);
  static const ShapeBorder shapeLg = RoundedRectangleBorder(borderRadius: borderLg);
  static const ShapeBorder shapeXl = RoundedRectangleBorder(borderRadius: borderXl);
  static const ShapeBorder shapePill = RoundedRectangleBorder(borderRadius: borderPill);
  static const ShapeBorder circular = CircleBorder();
}
