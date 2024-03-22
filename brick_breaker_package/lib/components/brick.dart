import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

import '../brick_breaker.dart';
import '../config.dart';

class Brick extends RectangleComponent
    with CollisionCallbacks, HasGameReference<BrickBreaker> {
  Brick({required super.position, required Color color})
      : super(
    size: Vector2(brickWidth, brickHeight),
    anchor: Anchor.center,
    paint: Paint()
      ..color = color
      ..style = PaintingStyle.fill,
    children: [RectangleHitbox()],
  );

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (game.world.children.query<Brick>().length == 1) {
      game.resetGame();
      game.playState = PlayState.won;
    }
    else {
      add(SizeEffect.to(
          Vector2(0,0),
          EffectController(duration: 0.5),
        onComplete: (){
          removeFromParent();
          game.score.value++;
        }
      ));
    }
  }
}