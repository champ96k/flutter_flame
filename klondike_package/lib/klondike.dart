library klondike_package;

import 'package:flame/game.dart';
import 'package:klondike_package/klondike_game.dart';

class Klondike extends GameWidget<KlondikeGame> {
  Klondike({super.key}) : super(game: KlondikeGame());
}
