// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// DRAW
//
// By Robert Mollentze AKA @robmllze (2021)
//
// Please see LICENSE file.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

library elliptic_text;

import 'dart:math' show pi;

import 'package:flutter/material.dart';

import 'vec2.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

void drawLine0({
  required final Canvas canvas,
  required final Vec2 position,
  required final Vec2 line,
  final Color color = Colors.red,
  final double strokeWidth = 2.0,
}) {
  assert(strokeWidth >= 0.0);
  final _paint = Paint()
    ..color = color
    ..strokeWidth = strokeWidth;
  canvas.drawLine(
    position.toOffset(),
    (position + line).toOffset(),
    _paint,
  );
}

void drawLine1({
  required final Canvas canvas,
  required final Vec2 position,
  required final double length,
  required final double rotation,
  final Color color = Colors.red,
  final double strokeWidth = 2.0,
}) {
  assert(strokeWidth >= 0.0);
  final _paint = Paint()
    ..color = color
    ..strokeWidth = strokeWidth;
  canvas.drawLine(
    position.toOffset(),
    (position + Vec2.fromRot(length, rotation)).toOffset(),
    _paint,
  );
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

void drawArrow({
  required final Canvas canvas,
  required final Vec2 position,
  required final Vec2 line,
  final Color color = Colors.red,
  final double strokeWidth = 1.0,
  final double lengthTip = 5.0,
}) {
  assert(lengthTip >= 0.0);
  assert(strokeWidth >= 0.0);
  final _paint = Paint()
    ..color = Color.fromRGBO(
      color.red,
      color.green,
      color.blue,
      1.0,
    )
    ..strokeWidth = strokeWidth
    ..strokeCap = StrokeCap.round;
  final double _alpha = pi / 6.0;
  final Vec2 _tip0 = line.unit * lengthTip;
  final Vec2 _end = position + line;
  final Vec2 _tip1 = _end - _tip0.rotated(_alpha);
  final Vec2 _tip2 = _end - _tip0.rotated(-_alpha);
  canvas.drawLine(position.toOffset(), _end.toOffset(), _paint);
  canvas.drawLine(_end.toOffset(), _tip1.toOffset(), _paint);
  canvas.drawLine(_end.toOffset(), _tip2.toOffset(), _paint);
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

void drawAxes({
  required final Canvas canvas,
  required final Vec2 position,
  required final Size size,
  final Color color = Colors.red,
  final double thickness = 2.0,
}) {
  assert(size.height >= 0.0 && size.width >= 0.0);
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
  required final double radius,
  final Color color = Colors.red,
}) {
  assert(radius >= 0.0);
  canvas.drawCircle(
    position.toOffset(),
    radius,
    Paint()..color = color,
  );
}

void drawCircleOutline({
  required final Canvas canvas,
  required final Vec2 position,
  required final double radius,
  final Color color = Colors.red,
  final double strokeWidth = 2.0,
}) {
  assert(radius >= 0.0);
  canvas.drawCircle(
    position.toOffset(),
    radius,
    Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke,
  );
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

void drawEllipse({
  required final Canvas canvas,
  required final Vec2 position,
  required Size size,
  final Color color = Colors.red,
}) {
  assert(size.height >= 0.0 && size.width >= 0.0);
  canvas.drawOval(
    Rect.fromCenter(
      center: position.toOffset(),
      height: size.height,
      width: size.width,
    ),
    Paint()..color = color,
  );
}

void drawEllipseOutline({
  required final Canvas canvas,
  required final Vec2 position,
  required Size size,
  final Color color = Colors.red,
  final double strokeWidth = 2.0,
}) {
  assert(size.height >= 0.0 && size.width >= 0.0);
  assert(strokeWidth >= 0.0);
  canvas.drawOval(
    Rect.fromCenter(
      center: position.toOffset(),
      height: size.height,
      width: size.width,
    ),
    Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke,
  );
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
  final Color colorBackground = Colors.transparent,
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
    Paint()..color = colorBackground,
  );
  if (flipped) canvas.translate(_w, _h);
  canvas.rotate(-rotation);
  canvas.translate(-_x, -_y);
  return _w;
}
