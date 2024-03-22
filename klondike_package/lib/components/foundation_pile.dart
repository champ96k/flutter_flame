import 'dart:ui';

import 'package:flame/components.dart';
import 'package:klondike_package/components/pile.dart';
import 'package:klondike_package/config.dart';
import 'package:klondike_package/suit.dart';

import 'game_card.dart';

class FoundationPile extends PositionComponent implements Pile{
  FoundationPile({super.position, required this.suit}) : super(size: cardSize);

  final List<GameCard> _cards = [];
  final Suit suit;

  @override
  void acquireCard(GameCard card){
    assert(card.isFaceUp && card.rank.value == _cards.length + 1 && card.suit.value == suit.value);
    card.position = position;
    card.priority = _cards.length;
    card.pile = this;
    _cards.add(card);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(cardRRect, borderPaint);
    suit.sprite.render(
      canvas,
      position: size / 2,
      anchor: Anchor.center,
      size: Vector2.all(cardWidth * 0.6),
    );
  }

  @override
  bool canMoveCard(GameCard card) => false;

  @override
  bool canMoveCardHere(GameCard card) => card.rank.value == _cards.length + 1 && card.suit.value == suit.value && card.attachedCards.isEmpty;

  @override
  void removeCard(GameCard card) {
    _cards.remove(card);
  }

  @override
  void returnCard(GameCard card) {}

}