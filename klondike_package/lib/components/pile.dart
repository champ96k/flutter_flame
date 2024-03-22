import 'package:klondike_package/components/game_card.dart';

abstract class Pile {
  bool canMoveCard(GameCard card);
  bool canMoveCardHere(GameCard card);
  void acquireCard(GameCard card);
  void removeCard(GameCard card);
  void returnCard(GameCard card);
}