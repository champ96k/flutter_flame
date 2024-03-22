import 'dart:ui';

import 'package:flame/components.dart';
import 'package:klondike_package/components/pile.dart';
import 'package:klondike_package/config.dart';

import 'game_card.dart';

class TableauPile extends PositionComponent implements Pile {
  TableauPile({super.position}) : super(size: cardSize);

  final List<GameCard> _cards = [];
  final Vector2 _fanOffset = Vector2(0, cardWidth * 0.2);
  void flipTopCard() {
    assert(!_cards.last.isFaceUp);
    _cards.last.flip();
  }

  List<GameCard> cardsOnTop(GameCard card) {
    assert(card.isFaceUp && _cards.contains(card));
    final index = _cards.indexOf(card);
    return _cards.getRange(index + 1, _cards.length).toList();
  }

  @override
  void acquireCard(GameCard card) {
    card.priority = _cards.length;
    card.pile = this;
    var lastPosition = _cards.isEmpty ? position : _cards.last.position + _fanOffset;
    card.position = card.isFaceUp ? lastPosition + _fanOffset : lastPosition ;
    _cards.add(card);
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
  bool canMoveCard(GameCard card) => _cards.isNotEmpty && card.isFaceUp;

  @override
  bool canMoveCardHere(GameCard card) {
    if (_cards.isEmpty) return card.rank.value == 13;
    return card.suit.isRed != _cards.last.suit.isRed &&
        card.rank.value == _cards.last.rank.value - 1;
  }

  @override
  void removeCard(GameCard card) {
    _cards.remove(card);
    _cards.last.flip();
  }

  @override
  void returnCard(GameCard card) {
    final index = _cards.indexOf(card);
    card.position =
    index == 0 ? position : _cards[index - 1].position + _fanOffset;
    card.priority = index;
  }
}