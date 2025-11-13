/// Consistent spacing values throughout the app
class AppSpacing {
  // Base spacing unit (4px)
  static const double unit = 4.0;

  // Spacing scale
  static const double xs = unit; // 4
  static const double sm = unit * 2; // 8
  static const double md = unit * 4; // 16
  static const double lg = unit * 6; // 24
  static const double xl = unit * 8; // 32
  static const double xxl = unit * 12; // 48
  static const double xxxl = unit * 16; // 64

  // Edge insets
  static const double screenPadding = md;
  static const double cardPadding = md;
  static const double buttonPadding = md;
  static const double inputPadding = md;

  // Border radius
  static const double radiusSm = unit; // 4
  static const double radiusMd = unit * 2; // 8
  static const double radiusLg = unit * 3; // 12
  static const double radiusXl = unit * 4; // 16
  static const double radiusFull = 999; // Fully rounded
}
