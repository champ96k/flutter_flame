import 'dart:ui';

import 'package:flame/components.dart';
import 'package:klondike_package/components/pile.dart';
import 'package:klondike_package/config.dart';

import 'game_card.dart';

class WastePile extends PositionComponent implements Pile{
  WastePile({super.position, required this.removeLastCard}) : super(size: cardSize);

  final List<GameCard> _cards = [];
  final Vector2 _fanOffset = Vector2(cardWidth * 0.2, 0);
  final void Function(GameCard card) removeLastCard;

  @override
  void acquireCard(GameCard card){
    assert(card.isFaceUp);
    card.position = position;
    card.priority = _cards.length;
    card.pile = this;
    _cards.add(card);
    _fanOutTopCards();
  }

  void _fanOutTopCards() {
    final n = _cards.length;
    for (var i = 0; i < n; i++) {
      _cards[i].position = position;
    }
    if (n == 2) {
      _cards[1].position.add(_fanOffset);
    } else if (n >= 3) {
      _cards[n - 2].position.add(_fanOffset);
      _cards[n - 1].position.addScaled(_fanOffset, 2);
    }
  }

  void removeAllCards(){
    final n = _cards.length;
    for(var i = 0; i < n; i++){
      removeLastCard(_cards.removeLast());
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
  bool canMoveCard(GameCard card) => _cards.isNotEmpty && card == _cards.last;

  @override
  bool canMoveCardHere(GameCard card) => false;

  @override
  void removeCard(GameCard card) {
    _cards.remove(card);
    _fanOutTopCards();
  }

  @override
  void returnCard(GameCard card) {
    card.priority = _cards.indexOf(card);
    _fanOutTopCards();
  }
}