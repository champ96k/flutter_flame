import 'dart:async';
import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'components/components.dart';
import 'config.dart';

enum PlayState { welcome, playing, pause, gameOver, won }

class BrickBreaker extends FlameGame with HasCollisionDetection, KeyboardEvents, TapDetector {
  BrickBreaker()
      : super(
    camera: CameraComponent.withFixedResolution(
      width: gameWidth,
      height: gameHeight,
    ),
  );

  final rand = math.Random();
  double get width => size.x;
  double get height => size.y;
  int currentRowPosition = 1;
  final ValueNotifier<int> score = ValueNotifier(0);
  late Ball _currentBall;
  late PlayState _playState;
  PlayState get playState => _playState;
  set playState(PlayState playState) {
    _playState = playState;
    switch (playState) {
      case PlayState.welcome:
      case PlayState.gameOver:
      case PlayState.won:
        overlays.add(playState.name);
      case PlayState.playing:
        overlays.remove(PlayState.welcome.name);
        overlays.remove(PlayState.gameOver.name);
        overlays.remove(PlayState.won.name);
        overlays.remove(PlayState.pause.name);
      case PlayState.pause:
        _currentBall.stop();
        overlays.add(playState.name);
    }
  }
  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    camera.viewfinder.anchor = Anchor.topLeft;
    world.add(PlayArea());
    playState = PlayState.welcome;
  }
  void startGame(){
    if(playState == PlayState.playing) return;
    playState = PlayState.playing;
    resetGame();
    currentRowPosition = 1;
    score.value = 0;
    addBall();
    world.add(Bat(
        size: Vector2(batWidth, batHeight),
        cornerRadius: const Radius.circular(ballRadius / 2),
        position: Vector2(width / 2, height * 0.95)));
    while(currentRowPosition <= 5) {
       final isMaxReached = !addBrickRow();
       if(isMaxReached) break;
    }
  }
  bool addBrickRow(){
    double y = (currentRowPosition + 1.0) * brickHeight + currentRowPosition * brickGutter;
    if(y > (height/2) - (2 * (brickHeight + brickGutter))) {
      return false;
    }

    final List<Brick> brickList = [];
    for (var i = 0; i < brickColors.length; i++) {
      brickList.add(Brick(
        position: Vector2(
          (i + 0.5) * brickWidth + (i + 1) * brickGutter,
          y,
        ),
        color: brickColors[i],
      )
      );
    }
    world.addAll(brickList);
    currentRowPosition++;
    return true;
  }

  void resetGame(){
    world.removeAll(world.children.query<Ball>());
    world.removeAll(world.children.query<Bat>());
    world.removeAll(world.children.query<Brick>());
  }

  void addBall(){
    _currentBall = Ball(
        position: size/2,
        radius: ballRadius,
        difficultyModifier: difficultyModifier,
        velocity: Vector2((rand.nextDouble() - 0.5) * width, height * 0.2)
            .normalized()
          ..scale(height / 4));
    world.add(_currentBall);
  }



  @override
  void onTap() {
    super.onTap();
    if(playState == PlayState.playing){
      playState = PlayState.pause;
    }
    else if(playState == PlayState.pause){
      playState = PlayState.playing;
      _currentBall.start();
    }
    else {
      startGame();
    }
  }

  void reStart(){
    playState = PlayState.welcome;
    startGame();
  }


  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowLeft:
        world.children.query<Bat>().first.moveBy(-batStep);
      case LogicalKeyboardKey.arrowRight:
        world.children.query<Bat>().first.moveBy(batStep);
      case LogicalKeyboardKey.space:                            // Add from here...
      case LogicalKeyboardKey.enter:
      startGame();
    }
    return super.onKeyEvent(event, keysPressed);
  }
}