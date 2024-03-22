import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

const double topMargin = 500.0;
const double cardWidth = 1000.0;
const double cardHeight = 1400.0;
const double cardGap = 175.0;
const double cardRadius = 100.0;

final Vector2 cardSize = Vector2(cardWidth, cardHeight);
klondikeSprite(double x, double y, double width, double height) {
  return Sprite(
    Flame.images.fromCache('klondike-sprites.png'),
    srcPosition: Vector2(x, y),
    srcSize: Vector2(width, height),
  );
}
final redFilter = Paint()
  ..colorFilter = const ColorFilter.mode(
    Color(0xabea063b),
    BlendMode.srcATop,
  );

final blackFilter = Paint()
  ..colorFilter = const ColorFilter.mode(
    Color(0xe01f1e1e),
    BlendMode.srcATop,
  );

final borderPaint = Paint()
  ..style = PaintingStyle.stroke
  ..strokeWidth = 10
  ..color = const Color(0xFF3F5B5D);

final circlePaint = Paint()
  ..style = PaintingStyle.stroke
  ..strokeWidth = 100
  ..color = const Color(0x883F5B5D);

final cardRRect = RRect.fromRectAndRadius(
  const Rect.fromLTWH(0, 0, cardWidth, cardHeight),
  const Radius.circular(cardRadius),
);