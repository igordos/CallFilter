import 'package:material_ui/material_ui.dart';

abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
  static const double huge = 40;
  static const double giant = 48;

  static const double page = 20;
}

/// Material 3 shape scale. Not every surface uses the same radius: controls
/// are softly rounded, cards are large, sheets are extra large and chips/buttons
/// use full/tonal shapes where their role benefits from it.
abstract final class AppRadius {
  static const double sm = 10;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 28;
  static const double pill = 999;

  static const BorderRadius small = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius medium = BorderRadius.all(Radius.circular(md));
  static const BorderRadius large = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius extraLarge = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius control = large;
  static const BorderRadius card = extraLarge;
  static const BorderRadius dialog = BorderRadius.all(Radius.circular(xxl));
  static const BorderRadius sheet = BorderRadius.vertical(
    top: Radius.circular(xxl),
  );
  static const BorderRadius full = BorderRadius.all(Radius.circular(pill));
}

abstract final class AppMotion {
  static const Duration fast = Duration(milliseconds: 120);
  static const Duration normal = Duration(milliseconds: 220);
  static const Duration slow = Duration(milliseconds: 360);
  static const Duration emphasized = Duration(milliseconds: 480);

  static const Curve enter = Curves.easeOutCubic;
  static const Curve exit = Curves.easeInCubic;
  static const Curve state = Curves.easeInOutCubic;
  static const Curve emphasizedCurve = Curves.easeInOutCubicEmphasized;
}

abstract final class AppSizes {
  static const double minTapTarget = 48;
  static const double controlHeight = 52;
  static const double navBarHeight = 80;
  static const double navBarIconOnlyHeight = 68;
  static const double iconSmall = 18;
  static const double icon = 20;
  static const double iconLarge = 24;
  static const double iconHero = 30;
  static const double pageMaxWidth = 720;
  static const double sheetMaxWidth = 640;
  static const double dialogMaxWidth = 420;
  static const double listAvatar = 40;
}
