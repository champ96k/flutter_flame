
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../config.dart';
import '../brick_breaker.dart';
import 'components.dart';

class Ball extends CircleComponent with CollisionCallbacks, HasGameReference<BrickBreaker> {
  Ball({
    required this.velocity,
    required super.position,
    required double radius,
    required this.difficultyModifier
  }) : super(
      radius: radius,
      anchor: Anchor.center,
      paint: Paint()
        ..color = const Color(0xff1e6091)
        ..style = PaintingStyle.fill,
      children: [CircleHitbox()]
  );

  final Vector2 velocity;
  final rand = math.Random();
  final double difficultyModifier;
  Vector2? _lastVelocity;
  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;
  }

  void _updateVelocity(){
    if(velocity.x < maxModifier * width && velocity.y < maxModifier * height){
      velocity.setFrom(velocity * difficultyModifier);
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is PlayArea) {
      if (intersectionPoints.first.y <= 1) {
        velocity.y = -velocity.y;
      } else if (intersectionPoints.first.x <= 1) {
        velocity.x = -velocity.x;
      } else if (intersectionPoints.first.x >= (game.width - 1)) {
        velocity.x = -velocity.x;
      } else if (intersectionPoints.first.y >= (game.height -1)) {
        add(RemoveEffect(delay: 0.35, onComplete: (){
          final isGameOver = !game.addBrickRow();
          if(isGameOver) {
            game.playState = PlayState.gameOver;
          }
          else {
            game.addBall();
          }
        }));
      }
    }
    else if (other is Bat) {
      velocity.y = -velocity.y;
      velocity.x = velocity.x + (position.x - other.position.x) / other.size.x * game.width * 0.3;
      _updateVelocity();
    }
    else if (other is Brick) { // Modify from here...
      if (position.y < other.position.y - other.size.y / 2) {
        velocity.y = -velocity.y;
      } else if (position.y > other.position.y + other.size.y / 2) {
        velocity.y = -velocity.y;
      } else if (position.x < other.position.x) {
        velocity.x = -velocity.x;
      } else if (position.x > other.position.x) {
        velocity.x = -velocity.x;
      }
      _updateVelocity();
    }
  }

  void stop(){
    _lastVelocity = Vector2(velocity.x, velocity.y);
    velocity.setZero();
  }

  void start(){
    velocity.setFrom(_lastVelocity!);
  }
}