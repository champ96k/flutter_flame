import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:klondike_package/components/pile.dart';
import 'package:klondike_package/config.dart';

import 'game_card.dart';

class StockPile extends PositionComponent with TapCallbacks implements Pile{
  StockPile({super.position, required this.removeLastCard, required this.refillStock}) : super(size: cardSize);

  final List<GameCard> _cards = [];
  final void Function(GameCard card) removeLastCard;
  final void Function() refillStock;

  @override
  void acquireCard(GameCard card){
    assert(!card.isFaceUp);
    card.position = position;
    card.priority = _cards.length;
    card.pile = this;
    _cards.add(card);
  }

  @override
  void onTapUp(TapUpEvent event) {
    if(_cards.isEmpty) {
      refillStock();
    } else {
      for (var i = 0; i < 3; i++) {
        if (_cards.isNotEmpty) {
          final card = _cards.removeLast();
          removeLastCard(card);
        }
      }
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(cardRRect, borderPaint);
    canvas.drawCircle(
        Offset(width / 2, height / 2),
        cardWidth * .03,
        circlePaint);
  }

  @override
  bool canMoveCard(GameCard card) => false;

  @override
  bool canMoveCardHere(GameCard card) => false;

  @override
  void removeCard(GameCard card) {
    _cards.remove(card);
  }

  @override
  void returnCard(GameCard card) {}
}