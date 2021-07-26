// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// DRAW
//
// Coded by Robert Mollentze
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

library elliptic_text;

import 'dart:math' show pi;

import 'package:flutter/material.dart';

import 'vec2.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

void drawLine({
  required final Canvas canvas,
  required final Vec2 a,
  required final Vec2 b,
  final Color color = Colors.red,
  final double strokeWidth = 2.0,
}) {
  final _paint = Paint()
    ..color = color
    ..strokeWidth = strokeWidth;
  final Vec2 _ab = a + b;
  canvas.drawLine(a.toOffset(), _ab.toOffset(), _paint);
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

void drawArrow({
  required final Canvas canvas,
  required final Vec2 a,
  required final Vec2 b,
  final Color color = Colors.red,
  final double strokeWidth = 1.0,
  final double lengthTip = 5.0,
}) {
  final _paint = Paint()
    ..color = Color.fromRGBO(
      color.red,
      color.green,
      color.blue,
      1.0,
    )
    ..strokeWidth = strokeWidth;
  final double _alpha = pi / 6.0;
  final double _radius = 0.5 * strokeWidth;
  final Vec2 _b10 = b.unit * lengthTip;
  final Vec2 _ab = a + b;
  final Vec2 _c0 = _ab - _b10.rotated(_alpha);
  final Vec2 _c1 = _ab - _b10.rotated(-_alpha);
  canvas.drawLine(a.toOffset(), _ab.toOffset(), _paint);
  canvas.drawLine(_ab.toOffset(), _c0.toOffset(), _paint);
  canvas.drawLine(_ab.toOffset(), _c1.toOffset(), _paint);
  drawCircle(canvas: canvas, position: _ab, color: color, radius: _radius);
  drawCircle(canvas: canvas, position: a, color: color, radius: _radius);
  drawCircle(canvas: canvas, position: _c0, color: color, radius: _radius);
  drawCircle(canvas: canvas, position: _c1, color: color, radius: _radius);
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

void drawAxes({
  required final Canvas canvas,
  required final Vec2 position,
  required final Size size,
  final Color color = Colors.red,
  final double thickness = 2.0,
}) {
  final _paint = Paint()
    ..color = color
    ..strokeWidth = thickness;
  canvas.drawLine(
      Offset(0.0, position.y), Offset(size.width, position.y), _paint);
  canvas.drawLine(
      Offset(position.x, 0.0), Offset(position.x, size.height), _paint);
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

void drawCircle({
  required final Canvas canvas,
  required final Vec2 position,
  final Color color = Colors.red,
  final double radius = 2.0,
}) {
  canvas.drawCircle(position.toOffset(), radius, Paint()..color = color);
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

double drawString(
  final String string, {
  required final Canvas canvas,
  required final Vec2 position,
  final TextStyle style = const TextStyle(),
  final double rotation = 0.0,
  final bool flipped = false,
  final TextPainter? painter,
  final Color colorBg = Colors.transparent,
}) {
  final _painter = (painter == null
      ? TextPainter(textDirection: TextDirection.ltr)
      : painter)
    ..text = TextSpan(
      text: string,
      style: style,
    )
    ..layout();
  final _w = _painter.width;
  final _h = _painter.height;
  final _x = position.x;
  final _y = position.y;
  canvas.translate(_x, _y);
  canvas.rotate(rotation);
  if (flipped) canvas.translate(-_w, -_h);
  _painter.paint(canvas, const Offset(0.0, 0.0));
  canvas.drawRect(
    Rect.fromCenter(center: Offset(_w, _h) * 0.5, width: _w, height: _h),
    Paint()..color = colorBg,
  );
  if (flipped) canvas.translate(_w, _h);
  canvas.rotate(-rotation);
  canvas.translate(-_x, -_y);
  return _w;
}
