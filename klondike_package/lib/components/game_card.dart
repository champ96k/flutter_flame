import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:klondike_package/components/pile.dart';
import 'package:klondike_package/components/tableau_pile.dart';

import '../config.dart';
import '../rank.dart';
import '../suit.dart';

class GameCard extends PositionComponent with DragCallbacks {
  GameCard(int intRank, int intSuit)
      : rank = Rank.fromInt(intRank),
        suit = Suit.fromInt(intSuit),
        _faceUp = false,
        super(size: cardSize);

  Pile? pile;
  final List<GameCard> attachedCards = [];
  final Rank rank;
  final Suit suit;
  bool _faceUp;
  static final Paint backBackgroundPaint = Paint()..color = Colors.white;
  static final Paint backBorderPaint1 = Paint()
    ..color = const Color(0xffdbaf58)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10;
  static final Paint backBorderPaint2 = Paint()
    ..color = const Color(0x5CEF971B)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 35;
  static final RRect cardRRect = RRect.fromRectAndRadius(
    cardSize.toRect(),
    const Radius.circular(cardRadius),
  );
  static final Paint frontBackgroundPaint = Paint()..color = Colors.white;
  static final Paint redBorderPaint = Paint()
    ..color = const Color(0xffece8a3)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10;
  static final Paint blackBorderPaint = Paint()
    ..color = const Color(0xffece8a3)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10;
  static final RRect backRRectInner = cardRRect.deflate(40);
  static final Sprite flameSprite = klondikeSprite(1367, 6, 357, 501);
  static final Sprite redJack = klondikeSprite(81, 565, 562, 488)
    ..paint = redFilter;
  static final Sprite redQueen = klondikeSprite(717, 541, 486, 515)
    ..paint = redFilter;
  static final Sprite redKing = klondikeSprite(1305, 532, 407, 549)
    ..paint = redFilter;
  static final Sprite blackJack = klondikeSprite(81, 565, 562, 488)
    ..paint = blackFilter;
  static final Sprite blackQueen = klondikeSprite(717, 541, 486, 515)
    ..paint = blackFilter;
  static final Sprite blackKing = klondikeSprite(1305, 532, 407, 549)
    ..paint = blackFilter;
  bool get isFaceUp => _faceUp;
  void flip() => _faceUp = !_faceUp;
  @override
  String toString() => rank.label + suit.label;

  @override
  void render(Canvas canvas) {
    if (_faceUp) {
      _renderFront(canvas);
    } else {
      _renderBack(canvas);
    }
  }

  @override
  void onDragStart(DragStartEvent event) {
    if (pile?.canMoveCard(this) != true) return;
    super.onDragStart(event);
    priority = 100;
    if (pile is TableauPile) {
      attachedCards.clear();
      final extraCards = (pile! as TableauPile).cardsOnTop(this);
      for (final card in extraCards) {
        card.priority = attachedCards.length + 101;
        attachedCards.add(card);
      }
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (!isDragged) {
      return;
    }
    final delta = event.localDelta;
    position += delta;
    for (var card in attachedCards) {
      card.position.add(delta);
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    if (!isDragged) {
      return;
    }
    super.onDragEnd(event);
    final dropPiles = parent!
        .componentsAtPoint(position + size / 2)
        .whereType<Pile>()
        .toList();
    if (dropPiles.isNotEmpty) {
      for (var dropPile in dropPiles) {
        if (dropPile.canMoveCardHere(this) == true) {
          pile!.removeCard(this);
          dropPile.acquireCard(this);
          return;
        }
      }
    }
    pile!.returnCard(this);
    if (attachedCards.isNotEmpty) {
      for (var card in attachedCards) {
        pile!.returnCard(card);
      }
      attachedCards.clear();
    }
  }

  void _renderFront(Canvas canvas) {
    canvas.drawRRect(cardRRect, frontBackgroundPaint);
    canvas.drawRRect(
      cardRRect,
      suit.isRed ? redBorderPaint : blackBorderPaint,
    );
    final rankSprite = suit.isBlack ? rank.blackSprite : rank.redSprite;
    final suitSprite = suit.sprite;
    _drawSprite(canvas, rankSprite, 0.1, 0.08);
    _drawSprite(canvas, rankSprite, 0.1, 0.08, rotate: true);
    _drawSprite(canvas, suitSprite, 0.1, 0.18, scale: 0.5);
    _drawSprite(canvas, suitSprite, 0.1, 0.18, scale: 0.5, rotate: true);
    switch (rank.value) {
      case 1:
        _drawSprite(canvas, suitSprite, 0.5, 0.5, scale: 2.5);
        break;
      case 2:
        _drawSprite(canvas, suitSprite, 0.5, 0.25);
        _drawSprite(canvas, suitSprite, 0.5, 0.25, rotate: true);
        break;
      case 3:
        _drawSprite(canvas, suitSprite, 0.5, 0.2);
        _drawSprite(canvas, suitSprite, 0.5, 0.5);
        _drawSprite(canvas, suitSprite, 0.5, 0.2, rotate: true);
        break;
      case 4:
        _drawSprite(canvas, suitSprite, 0.3, 0.25);
        _drawSprite(canvas, suitSprite, 0.7, 0.25);
        _drawSprite(canvas, suitSprite, 0.3, 0.25, rotate: true);
        _drawSprite(canvas, suitSprite, 0.7, 0.25, rotate: true);
        break;
      case 5:
        _drawSprite(canvas, suitSprite, 0.3, 0.25);
        _drawSprite(canvas, suitSprite, 0.7, 0.25);
        _drawSprite(canvas, suitSprite, 0.3, 0.25, rotate: true);
        _drawSprite(canvas, suitSprite, 0.7, 0.25, rotate: true);
        _drawSprite(canvas, suitSprite, 0.5, 0.5);
        break;
      case 6:
        _drawSprite(canvas, suitSprite, 0.3, 0.25);
        _drawSprite(canvas, suitSprite, 0.7, 0.25);
        _drawSprite(canvas, suitSprite, 0.3, 0.5);
        _drawSprite(canvas, suitSprite, 0.7, 0.5);
        _drawSprite(canvas, suitSprite, 0.3, 0.25, rotate: true);
        _drawSprite(canvas, suitSprite, 0.7, 0.25, rotate: true);
        break;
      case 7:
        _drawSprite(canvas, suitSprite, 0.3, 0.2);
        _drawSprite(canvas, suitSprite, 0.7, 0.2);
        _drawSprite(canvas, suitSprite, 0.5, 0.35);
        _drawSprite(canvas, suitSprite, 0.3, 0.5);
        _drawSprite(canvas, suitSprite, 0.7, 0.5);
        _drawSprite(canvas, suitSprite, 0.3, 0.2, rotate: true);
        _drawSprite(canvas, suitSprite, 0.7, 0.2, rotate: true);
        break;
      case 8:
        _drawSprite(canvas, suitSprite, 0.3, 0.2);
        _drawSprite(canvas, suitSprite, 0.7, 0.2);
        _drawSprite(canvas, suitSprite, 0.5, 0.35);
        _drawSprite(canvas, suitSprite, 0.3, 0.5);
        _drawSprite(canvas, suitSprite, 0.7, 0.5);
        _drawSprite(canvas, suitSprite, 0.3, 0.2, rotate: true);
        _drawSprite(canvas, suitSprite, 0.7, 0.2, rotate: true);
        _drawSprite(canvas, suitSprite, 0.5, 0.35, rotate: true);
        break;
      case 9:
        _drawSprite(canvas, suitSprite, 0.3, 0.2);
        _drawSprite(canvas, suitSprite, 0.7, 0.2);
        _drawSprite(canvas, suitSprite, 0.5, 0.3);
        _drawSprite(canvas, suitSprite, 0.3, 0.4);
        _drawSprite(canvas, suitSprite, 0.7, 0.4);
        _drawSprite(canvas, suitSprite, 0.3, 0.2, rotate: true);
        _drawSprite(canvas, suitSprite, 0.7, 0.2, rotate: true);
        _drawSprite(canvas, suitSprite, 0.3, 0.4, rotate: true);
        _drawSprite(canvas, suitSprite, 0.7, 0.4, rotate: true);
        break;
      case 10:
        _drawSprite(canvas, suitSprite, 0.3, 0.2);
        _drawSprite(canvas, suitSprite, 0.7, 0.2);
        _drawSprite(canvas, suitSprite, 0.5, 0.3);
        _drawSprite(canvas, suitSprite, 0.3, 0.4);
        _drawSprite(canvas, suitSprite, 0.7, 0.4);
        _drawSprite(canvas, suitSprite, 0.3, 0.2, rotate: true);
        _drawSprite(canvas, suitSprite, 0.7, 0.2, rotate: true);
        _drawSprite(canvas, suitSprite, 0.5, 0.3, rotate: true);
        _drawSprite(canvas, suitSprite, 0.3, 0.4, rotate: true);
        _drawSprite(canvas, suitSprite, 0.7, 0.4, rotate: true);
        break;
      case 11:
        _drawSprite(canvas, suit.isRed ? redJack : blackJack, 0.5, 0.5);
        break;
      case 12:
        _drawSprite(canvas, suit.isRed ? redQueen : blackQueen, 0.5, 0.5);
        break;
      case 13:
        _drawSprite(canvas, suit.isRed ? redKing : blackKing, 0.5, 0.5);
        break;
    }
  }

  void _renderBack(Canvas canvas) {
    canvas.drawRRect(cardRRect, backBackgroundPaint);
    canvas.drawRRect(cardRRect, backBorderPaint1);
    canvas.drawRRect(backRRectInner, backBorderPaint2);
    flameSprite.render(canvas, position: size / 2, anchor: Anchor.center);
  }

  void _drawSprite(
    Canvas canvas,
    Sprite sprite,
    double relativeX,
    double relativeY, {
    double scale = 1,
    bool rotate = false,
  }) {
    if (rotate) {
      canvas.save();
      canvas.translate(size.x / 2, size.y / 2);
      canvas.rotate(pi);
      canvas.translate(-size.x / 2, -size.y / 2);
    }
    sprite.render(
      canvas,
      position: Vector2(relativeX * size.x, relativeY * size.y),
      anchor: Anchor.center,
      size: sprite.srcSize.scaled(scale),
    );
    if (rotate) {
      canvas.restore();
    }
  }
}
