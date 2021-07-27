// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// ELLIPTIC TEXT
//
// By Robert Mollentze AKA @robmllze (2021)
//
// Please see LICENSE file.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

library elliptic_text;

import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'src/draw.dart';
import 'src/ellipse.dart';
import 'src/vec2.dart';
import 'src/wiskunde.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class EllipticText extends StatelessWidget {
  //
  //
  //

  final String text;

  /// Style to be applied to the text. Note that a few properties aren't
  /// supported such as `decoration` and `wordSpacing`.
  final TextStyle style;

  /// Align text to the left, right or centre.
  final EllipticText_TextAlignment textAlignment;

  /// Draw text top-side away  or bottom-side away from centre.
  final EllipticText_CentreAlignment? centreAlignment;

  /// Where to draw text along perimiter.
  final EllipticText_PerimiterAlignment perimiterAlignment;

  /// Where to draw text along perimiter relative to `perimiterAlignment`.
  final double offset;

  /// Stretches the text by [stretchFactor], e.g. 0.7 will squeeze the text to
  /// 70% its original width.
  final double stretchFactor;

  /// How the text should be fitted along the perimiter.
  ///
  /// The options are:
  ///
  /// * noFit: The text won't be fitted.
  /// * scaleFit: The text will be fitted by altering the font size.
  /// * stretchFit: The text will be fitted by altering the letter spacing.
  /// * comboFit: The text will be fitted by altering both the font size and
  /// letter spacing.
  final EllipticText_FitType fitType;

  /// A [fitFactor] of 1/2 would fit the text to half the perimiter of the
  /// ellipse, 1/4 to a quarter and 1 would completely wrap the text around
  /// the ellipse.
  ///
  /// Note: Only has an affect if [fitType] is not equal to noFit.
  final double fitFactor;

  /// Set to 1.0 to see an outline of the ellipse the text is drawn around.
  final double debugStrokeWidth;

  //
  //
  //

  const EllipticText({
    required this.text,
    final Key? key,
    this.style = const TextStyle(color: Colors.red),
    this.textAlignment = EllipticText_TextAlignment.centre,
    this.centreAlignment,
    this.perimiterAlignment = EllipticText_PerimiterAlignment.top,
    this.offset = 0.0,
    this.stretchFactor = 1.0,
    this.fitType = EllipticText_FitType.noFit,
    this.fitFactor = 0.5,
    this.debugStrokeWidth = 0.0,
  }) : super(key: key);

  //
  //
  //

  @override
  Widget build(final BuildContext context) => LayoutBuilder(
        builder: (_, __constraints) => CustomPaint(
          painter: _EllipticTextPainter(
            this,
            Size(
              __constraints.maxWidth,
              __constraints.maxHeight,
            ),
          ),
        ),
      );
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class _EllipticTextPainter extends CustomPainter {
  //
  //
  //

  final EllipticText widget;
  final Size constraints;

  late final TextStyle style1;
  late final EllipticText_CentreAlignment centreAlignment1;
  late final EllipticText_TextAlignment textAlignment1;

  /// To hold height of the tallest letter in text.
  double _heightLetterMax = 0.0;

  /// To hold average letter width.
  double _widthLetterAvg = 0.0;

  /// To hold sum of all the letter widths.
  double _widthText = 0.0;

  //
  //
  //

  _EllipticTextPainter(this.widget, this.constraints) {
    assert(this.widget.stretchFactor >= 0.0);
    assert(this.widget.fitFactor >= 0.0);

    // TODO: Are there any more properties not supported?
    // Properties not supported.
    const _NOT_SUPPORTED = "EllipticText doesn't support the property: '";
    assert(
      this.widget.style.wordSpacing == null,
      "${_NOT_SUPPORTED}wordSpacing'.",
    );
    assert(
      this.widget.style.decoration == null,
      "${_NOT_SUPPORTED}decoration'.",
    );
    assert(
      this.widget.style.decorationColor == null,
      "${_NOT_SUPPORTED}decorationColor'.",
    );
    assert(
      this.widget.style.decorationStyle == null,
      "${_NOT_SUPPORTED}decorationStyle'.",
    );
    assert(
      this.widget.style.decorationThickness == null,
      "${_NOT_SUPPORTED}decorationThickness'.",
    );

    // Ensure text style has a font size.
    this.style1 = (this.widget.style.fontSize == null
            ? this.widget.style.copyWith(
                  fontSize: 12.0,
                )
            : this.widget.style)
        // Nullify unsupported features.
        .copyWith(
      wordSpacing: null,
      decoration: null,
      decorationColor: null,
      decorationStyle: null,
      decorationThickness: null,
    );

    // Adjust centre alignment if not explicitly specified.
    this.centreAlignment1 = this.widget.centreAlignment == null
        ? this.widget.perimiterAlignment.index <= 4
            ? EllipticText_CentreAlignment.bottomSideAway
            : EllipticText_CentreAlignment.topSideAway
        : this.widget.centreAlignment!;

    // Adjust text alignment based on centre alignment.
    this.textAlignment1 =
        this.centreAlignment1 == EllipticText_CentreAlignment.topSideAway
            ? this.widget.textAlignment
            : this.widget.textAlignment == EllipticText_TextAlignment.left
                ? EllipticText_TextAlignment.right
                : this.widget.textAlignment == EllipticText_TextAlignment.right
                    ? EllipticText_TextAlignment.left
                    : EllipticText_TextAlignment.centre;
  }

  //
  //
  //

  /// Size of letter at [n] with font size scaled by [scale].
  Size _sizeLetter(final int n, final double scale) {
    return (TextPainter(textDirection: TextDirection.ltr)
          ..text = TextSpan(
            text: this.widget.text[n],
            style: this.style1.copyWith(
                  fontSize: this.style1.fontSize! * scale,
                ),
          )
          ..layout())
        .size;
  }

  //
  //
  //

  /// Computes `this._heightLetterMax`, `this._widthLetterAvg` and
  /// `this._widthText`.
  void _computeSizeText([final double scale = 1.0]) {
    this._widthText = 0.0;
    for (int n = 0; n < this.widget.text.length; n++) {
      final _size = _sizeLetter(n, scale);
      if (_size.height > _heightLetterMax) _heightLetterMax = _size.height;
      this._widthText += _size.width;
    }
    this._widthLetterAvg = this._widthText / this.widget.text.length;
  }

  //
  //
  //

  /// Unit vector with slope equal to slope of the ellipse at x = [x].
  /// Note: [x] gets circulated between [-a] and [a] so
  /// -infinity < [x] < infinity.
  Vec2 _vUStep(
    final double x,
    // Half-width of ellipse.
    final double a,
    // Hald-height of ellipse.
    final double b,
    final bool isPositiveX,
    final bool isPositiveY,
  ) {
    final _slope = ellipseDyDx(x, a, b);
    return _slope.isFinite
        ? Vec2(1.0, -_slope).unit * (isPositiveY ? -1.0 : 1.0)
        : Vec2(0.0, isPositiveX ? 1.0 : -1.0);
  }

  //
  //
  //

  @override
  void paint(final Canvas canvas, final Size size) {
    // Set origin of ellipse in centre of widget's bounding box.
    final _vOrigin = Vec2.fromSize(this.constraints * 0.5);

    // Set half-width _a and half-height _b of ellipse. Subtract
    // this._heightLetterMax so that text is rendered on the inside
    // and not on the outside of the perimiter.
    final double _a = _vOrigin.x - this._heightLetterMax;
    final double _b = _vOrigin.y - this._heightLetterMax;

    // Draw actual ellipse for debugging if requested.
    if (this.widget.debugStrokeWidth > 0.0) {
      drawEllipseOutline(
        canvas: canvas,
        position: _vOrigin,
        size: Size(_a, _b) * 2.0,
        color: this.widget.style.color ?? Colors.red,
        strokeWidth: this.widget.debugStrokeWidth,
      );
    }

    this._computeSizeText();
    double _scale = 1.0;

    // Re-compute text size and _scale if text needs to be fitted.
    if (this.widget.fitType == EllipticText_FitType.scaleFit ||
        this.widget.fitType == EllipticText_FitType.comboFit) {
      final double _circum = ellipseCircumRamanujan1(_a, _b);
      _scale = this.widget.fitFactor * _circum / _widthText;
      if (this.widget.fitType == EllipticText_FitType.comboFit)
        _scale = 0.5 * (1.0 + _scale);
      this._computeSizeText(_scale);
    }

    final int _lengthText = this.widget.text.length;

    // The smaller _step is, the smoother text is rendered on perimiter but
    // slower the computation. The larger _step is, the chunkier text is
    // rendered on perimiter but faster the computation. By experiment, _step
    // is set to half the average letter width but no smaller than 8 pixels
    // because less than 8 is unnecessary.
    final double _step =
        this._widthLetterAvg < 16.0 ? 8.0 : 0.5 * this._widthLetterAvg;

    // Points on perimiter of ellipse.
    final List<Vec2> _intercepts = [];

    // Unit vectors with slopes equal to slopes of ellipse at intercepts.
    final List<Vec2> _tangents = [];

    // Calculate the intercepts and tangents (defined above) for a range of
    // x-intercepts that will be used to determine the position and rotation of
    // each letter.
    for (double x = -_a; x <= 3.0 * _a;) {
      final _vIntercept = ellipseFxV(x, _a, _b);
      final _vUS = _vUStep(
        x,
        _a,
        _b,
        _vIntercept.x >= 0,
        _vIntercept.y >= 0.0,
      );
      final double _dx =
          (_vUS.x == 0.0 ? _a - ellipseFxV(_step, _b, _a).y : _step * _vUS.x)
              .abs();
      _intercepts.add(_vIntercept);
      _tangents.add(_vUS);

      // Add an extra intercept and tangent at (_a, 0.0) so that text is
      // rendered smoothly near (_a, 0.0) even if _step is large. Note: This
      // is probably unnecessary since _step is always small, but added anyway
      // just in case.
      if (x < _a && x + _dx > _a) {
        _intercepts.add(Vec2(_a, 0.0));
        _tangents.add(Vec2(0.0, 1.0));
      }

      x += _dx;
    }

    // Calculate perimiter length of ellipse poligon.
    // Note: Not after true of Ramanujan approximation of circumference here.
    double _circum = 0.0;
    for (int n = 0; n < _intercepts.length; n++) {
      _circum +=
          (_intercepts[n] - _intercepts[n.cycledNext(_intercepts.length)]).mag;
    }

    // Calculate stretch if text needs to be fitted or leave it at 1.0.
    final double _stretchFactor0 = this.widget.stretchFactor *
        (this.widget.fitType != EllipticText_FitType.noFit
            ? this.widget.fitFactor * _circum / _widthText
            : 1.0);

    // Calculate initial letter distance along perimiter based on chosen
    // text alignment.
    double _letterDist =
        this.widget.perimiterAlignment.position(_circum) + this.widget.offset;
    if (this.textAlignment1 == EllipticText_TextAlignment.right) {
      _letterDist -= _widthText * _stretchFactor0;
    } else if (this.textAlignment1 == EllipticText_TextAlignment.centre) {
      _letterDist -= 0.5 * _widthText * _stretchFactor0;
    }
    _letterDist = _letterDist.cycled(_circum);

    // Draw letter by letter.
    for (int m = 0, n = 0; m < _lengthText; m++, n = 0) {
      // Calculate letter position.
      double _minor;
      int _next = 0;
      Vec2 _vDelta;
      for (double l = 0.0;; n = n.cycledNext(_intercepts.length)) {
        _next = n.cycledNext(_intercepts.length);
        _vDelta = _intercepts[_next] - _intercepts[n];
        l += _vDelta.mag;
        if (l > _letterDist) {
          _minor = l - _letterDist;
          break;
        }
      }
      final Vec2 _vLetter = _intercepts[_next] - _vDelta.len(_minor);

      // Compute weighted average rotation.
      // Note: This is unnecessary since _step is small but added anyway just in
      // case. Alternatively, "final double _rot = _tangents[n].rot;" can be
      // used but this can cause the rotation to be chunky  if _step is large.
      final double _rot = () {
        final double _weight = _minor / _vDelta.mag;
        final double _rot0 = _tangents[n].rot;
        double _rot1 = _tangents[_next].rot;
        if (_rot1 - _rot0 > pi) _rot1 = 2 * pi - _rot1;
        return (_weight) * _rot0 + (1.0 - _weight) * _rot1;
      }.call();

      // Draw letter appropriately based on the chosen centre alignment and
      // collect its width.
      final _widthLetter =
          this.centreAlignment1 == EllipticText_CentreAlignment.bottomSideAway
              ? drawString(
                  this.widget.text[m],
                  canvas: canvas,
                  position: _vOrigin + _vLetter,
                  style: this.style1.copyWith(
                        fontSize: this.style1.fontSize! * _scale,
                      ),
                  rotation: pi + _rot,
                  flipped: false,
                )
              : drawString(
                  this.widget.text[_lengthText - 1 - m],
                  canvas: canvas,
                  position: _vOrigin + _vLetter,
                  style: this.style1.copyWith(
                        fontSize: this.style1.fontSize! * _scale,
                      ),
                  rotation: _rot,
                  flipped: true,
                );

      // Increase _letterDist to know where to draw next letter.
      _letterDist += _widthLetter * _stretchFactor0;

      // Cycle back _letterDist if it exceeds the circumference of ellipse.
      _letterDist = _letterDist.cycled(_circum);
    }
  }

  //
  //
  //

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

enum EllipticText_TextAlignment {
  left,
  right,
  centre,
}

enum EllipticText_CentreAlignment {
  /// Top of text should face away from ellipse centre.
  topSideAway,

  /// Bottom of text shoud face away ellipse centre.
  bottomSideAway,
}

enum EllipticText_PerimiterAlignment {
  left,
  bottomLeft,
  bottom,
  bottomRight,
  right,
  topRight,
  top,
  topLeft,
}

extension EllipticText_PerimiterAlignment_offset
    on EllipticText_PerimiterAlignment {
  double position(final double circum) => this.index / 8.0 * circum;
}

enum EllipticText_FitType {
  noFit,

  /// Fit by altering font size.
  scaleFit,

  /// Fit by altering letter spacing.
  stretchFit,

  /// Fit by altering both font size and letter spacing.
  comboFit,
}
