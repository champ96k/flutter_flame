library klondike_package;

import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:klondike_package/suit.dart';

import 'components/foundation_pile.dart';
import 'components/game_card.dart';
import 'components/tableau_pile.dart';
import 'components/stock_pile.dart';
import 'components/waste_pile.dart';
import 'config.dart';

class KlondikeGame extends FlameGame {
  KlondikeGame() : super(camera: CameraComponent());

  late final WastePile _waste;
  late final StockPile _stock;

  void moveCardToWaste(GameCard card) {
    if (!card.isFaceUp) card.flip();
    _waste.acquireCard(card);
  }

  void moveCardToStock(GameCard card) {
    if (card.isFaceUp) card.flip();
    _stock.acquireCard(card);
  }

  @override
  Color backgroundColor() {
    return Colors.blue;
  }

  @override
  FutureOr<void> onLoad() async {
    images.prefix = 'klondike_package/assets/images/';
    await Flame.images.load('klondike-sprites.png');
    _waste = WastePile(removeLastCard: moveCardToStock)
      ..size = cardSize
      ..position = Vector2(cardWidth + 4 * cardGap, cardGap + topMargin);

    _stock = StockPile(
        removeLastCard: moveCardToWaste, refillStock: _waste.removeAllCards)
      ..size = cardSize
      ..position = Vector2(cardGap, cardGap + topMargin);

    final foundations = List.generate(
      4,
      (i) => FoundationPile(suit: Suit.fromInt(i))
        ..size = cardSize
        ..position = Vector2(
            (i + 3) * (cardWidth + cardGap) + cardGap, cardGap + topMargin),
    );

    final piles = List.generate(
      7,
      (i) => TableauPile()
        ..size = cardSize
        ..position = Vector2(
          cardGap + i * (cardWidth + cardGap),
          cardHeight + 2 * (topMargin + cardGap),
        ),
    );
    final world = World()
      ..add(_stock)
      ..add(_waste)
      ..addAll(foundations)
      ..addAll(piles);
    add(world);
    camera.world = world;
    camera.viewfinder.visibleGameSize =
        Vector2(cardWidth * 7 + cardGap * 8, 4 * cardHeight + 3 * cardGap);
    camera.viewfinder.position = Vector2((cardWidth * 3.5) + (cardGap * 4), 0);
    camera.viewfinder.anchor = Anchor.topCenter;
    add(camera);
    final cards = [
      for (int rank = 1; rank <= 13; rank++)
        for (int suit = 0; suit < 4; suit++) GameCard(rank, suit)
    ]..shuffle();
    world.addAll(cards);
    int cardToDeal = cards.length - 1;
    for (var i = 0; i < 7; i++) {
      for (var j = i; j < 7; j++) {
        piles[j].acquireCard(cards[cardToDeal--]);
      }
      piles[i].flipTopCard();
    }
    for (int n = 0; n <= cardToDeal; n++) {
      _stock.acquireCard(cards[n]);
    }
  }
}
