// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// WISKUNDE
//
// Coded by Robert Mollentze
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

library elliptic_text;

import 'dart:math';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

double log10(num x) => log(x) / ln10;

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
//
// ROUNDING AND TRUNCATING
//
// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

double rountToFigure(final double x, final int figures) {
  if (x == 0) return 0;
  final double a = log10(x).truncateToDouble();
  final num y = pow(10, a + 1 - figures);
  return y * (x / y).roundToDouble();
}

double truncToFigure(final double x, final int figures) {
  if (x == 0) return 0;
  final double a = log10(x).truncateToDouble();
  final num y = pow(10, a + 1 - figures);
  return y * (x / y).truncateToDouble();
}

double roundAt(final double x, final int figures) {
  if (x == 0) return 0;
  final double y = pow(10, figures).toDouble();
  return (x * y).roundToDouble() / y;
}

double truncateAt(final double x, final int figures) {
  if (x == 0) return 0;
  final double y = pow(10, figures).toDouble();
  return (x * y).truncateToDouble() / y;
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
//
// PYTHAGORAS'S THEOREM.
//
// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Pythagoras's theorem.
///
/// Returns x where `r`^2 = x^2 + `y`^2.
double pythX(final double y, final double r) => sqrt(r * r - y * y);

/// Pythagoras's theorem.
///
/// Returns y where `r`^2 = x^2 + `x`^2.
double pythY(final double x, final double r) => sqrt(r * r - x * x);

/// Pythagoras's theorem.
///
/// Returns r where r^2 = `x`^2 + `y`^2.
double pythR(final double x, final double y) => sqrt(x * x + y * y);

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

extension cycled_num on num {
  T cycled<T>(final num upper) => this - (this / upper).floor() * upper as T;
  T cycledRange<T>(final num lower, final num upper) =>
      lower + (this - lower).cycled(upper - lower) as T;
  T cycledDelta<T>(final num upper, final num delta) =>
      (this + delta) - ((this + delta) / upper).floor() * upper as T;
  T cycledNext<T>(final num upper) => cycledDelta(upper, 1);
  T cycledPrev<T>(final num upper) => cycledDelta(upper, -1);
  T cycledRangeDelta<T>(final num lower, final num upper, final num delta) =>
      (this + delta).cycledRange(lower, upper);
  T cycledRangeNext<T>(final num lower, final num upper) =>
      cycledRangeDelta(lower, upper, 1);
  T cycledRangePrev<T>(final num lower, final num upper) =>
      cycledRangeDelta(lower, upper, -1);
}
