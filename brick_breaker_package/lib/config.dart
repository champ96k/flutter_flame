import 'package:flutter/material.dart';

final gameWidth = MediaQueryData.fromView(WidgetsBinding.instance.platformDispatcher.views.first).size.width;
final gameHeight = MediaQueryData.fromView(WidgetsBinding.instance.platformDispatcher.views.first).size.height;
const ballRadius = 10.0;
const batWidth = 100.0;
const batHeight = 10.0;
const batStep = batWidth/2;
final brickGutter = gameWidth * 0.015;
final brickWidth = (gameWidth - (brickGutter * (brickColors.length + 1))) / brickColors.length;
final brickHeight = gameHeight * 0.03;
const double difficultyModifier = 1.03;
const double maxModifier = 4;
const brickColors = [
  Color(0xfff94144),
  Color(0xfff3722c),
  Color(0xfff8961e),
  Color(0xfff9844a),
  Color(0xfff9c74f),
  Color(0xff90be6d),
  Color(0xff43aa8b),
  Color(0xff4d908e),
  Color(0xff277da1),
  Color(0xff577590),
];