// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// ELLIPTIC TEXT
//
// Coded by Robert Mollentze
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

library elliptic_text;

import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'draw.dart';
import 'ellipse.dart';
import 'vec2.dart';
import 'wiskunde.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class EllipticText extends StatelessWidget {
  //
  //
  //

  final String text;
  final TextStyle style;
  final EllipticText_TextAlignment textAlignment;
  final EllipticText_CentreAlignment? centreAlignment;
  final EllipticText_PerimiterAlignment perimiterAlignment;
  final double offsetPosition;
  final double textStretch;
  final EllipticText_FitType fitType;
  final double fitFactor;

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
    this.offsetPosition = 0.0,
    this.textStretch = 1.0,
    this.fitType = EllipticText_FitType.noFit,
    this.fitFactor = 0.5,
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
  double _heightLetterMax = 0.0;
  double _widthLetterAvg = 0.0;
  double _widthText = 0.0;

  //
  //
  //

  _EllipticTextPainter(this.widget, this.constraints) {
    // Ensure text style has a font size.
    this.style1 = this.widget.style.fontSize == null
        ? this.widget.style.copyWith(fontSize: 12.0)
        : this.widget.style;

    // Adjust centre alignment if not explicitly specified.
    this.centreAlignment1 = this.widget.centreAlignment == null
        ? this.widget.perimiterAlignment.index <= 4
            ? EllipticText_CentreAlignment.bottom
            : EllipticText_CentreAlignment.top
        : this.widget.centreAlignment!;

    // Adjust text alignment based on centre alignment.
    this.textAlignment1 =
        this.centreAlignment1 == EllipticText_CentreAlignment.top
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

  void _computeSizeText([final double scale = 1.0]) {
    final _lengthText = this.widget.text.length;
    this._widthText = 0.0;
    for (int n = 0; n < _lengthText; n++) {
      final _size = _sizeLetter(n, scale);
      if (_size.height > _heightLetterMax) _heightLetterMax = _size.height;
      this._widthText += _size.width;
    }
    this._widthLetterAvg = this._widthText / _lengthText;
  }

  //
  //
  //

  Vec2 _vUStep(
    final double x,
    final double a,
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
    final _vOrigin = Vec2.fromSize(this.constraints * 0.5);
    final double _a = _vOrigin.x - this._heightLetterMax;
    final double _b = _vOrigin.y - this._heightLetterMax;
    this._computeSizeText();
    double _scale = 1.0;
    if (this.widget.fitType == EllipticText_FitType.scaleFit ||
        this.widget.fitType == EllipticText_FitType.comboFit) {
      final double _circum = ellipseCircumRamanujan1(_a, _b);
      _scale = this.widget.fitFactor * _circum / _widthText;
      if (this.widget.fitType == EllipticText_FitType.comboFit)
        _scale = 0.5 * (1.0 + _scale);
      this._computeSizeText(_scale);
    }
    final int _lengthText = this.widget.text.length;
    final double _step =
        this._widthLetterAvg < 16.0 ? 8.0 : 0.5 * this._widthLetterAvg;
    final List<Vec2> _intercepts = [];
    final List<Vec2> _tangents = [];
    for (double x = -_a; x <= 3.0 * _a;) {
      final Vec2 _vIntercept = ellipseFxV(x, _a, _b);
      final Vec2 _vUS = _vUStep(
        x,
        _a,
        _b,
        _vIntercept.x >= 0,
        _vIntercept.y >= 0.0,
      );
      final double _xStep =
          (_vUS.x == 0.0 ? _a - ellipseFxV(_step, _b, _a).y : _step * _vUS.x)
              .abs();
      _intercepts.add(_vIntercept);
      _tangents.add(_vUS);
      // NB: Unnecessary if _step is small.
      // Adds an extra intercept and tangent at (_a, 0.0) so that text is
      // rendered smoothly near (_a, 0.0) even if _step is large.
      if (x < _a && x + _xStep > _a) {
        _intercepts.add(Vec2(_a, 0.0));
        _tangents.add(Vec2(0.0, 1.0));
      }
      x += _xStep;
    }

    double _circum = 0.0;
    for (int n = 0; n < _intercepts.length; n++) {
      _circum +=
          (_intercepts[n] - _intercepts[n.cycledNext(_intercepts.length)]).mag;
    }
    final double _textStretch0 = this.widget.textStretch *
        (this.widget.fitType != EllipticText_FitType.noFit
            ? this.widget.fitFactor * _circum / _widthText
            : 1.0);
    double _letterDist = this.widget.perimiterAlignment.position(_circum) +
        this.widget.offsetPosition;
    if (this.textAlignment1 == EllipticText_TextAlignment.right) {
      _letterDist -= _widthText * _textStretch0;
    } else if (this.textAlignment1 == EllipticText_TextAlignment.centre) {
      _letterDist -= 0.5 * _widthText * _textStretch0;
    }
    _letterDist = _letterDist.cycled(_circum);
    for (int m = 0, n = 0; m < _lengthText; m++, n = 0) {
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
      // Option 1: Harsh rotation.
      //final double _rot = _tangents[n].rot;
      // NB: Unnecessary when _step is small.
      // Option 2: Compute weighted average rotation.
      final double _rot = () {
        final double _weight = _minor / _vDelta.mag;
        final double _rot0 = _tangents[n].rot;
        double _rot1 = _tangents[_next].rot;
        if (_rot1 - _rot0 > pi) _rot1 = 2 * pi - _rot1;
        return (_weight) * _rot0 + (1.0 - _weight) * _rot1;
      }.call();
      final _widthLetter =
          this.centreAlignment1 == EllipticText_CentreAlignment.bottom
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
      _letterDist += _widthLetter * _textStretch0;
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
  top,

  /// Bottom of text shoud face away ellipse centre.
  bottom,
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
