import 'package:brick_breaker_package/brick_breaker_game.dart';
import 'package:flutter/material.dart';
import 'package:game_launcher/model/game_info.dart';
import 'package:game_launcher/widgets/game_list_item.dart';
import 'package:klondike_package/klondike.dart';

class GameList extends StatefulWidget {
  const GameList({super.key});

  @override
  State<StatefulWidget> createState() => _GameListState();
}

class _GameListState extends State<GameList> {
  void onGameSelect(GameInfo gameInfo, BuildContext context) {
    switch (gameInfo.id) {
      case "1":
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => Klondike(),
          ),
        );
        break;
      case "2":
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => const BrickBreakerGame(),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = (MediaQuery.of(context).size.width) ~/ 150;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Please Select a Game"),
      ),
      body: GridView(
        padding: const EdgeInsets.all(20),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount > 2 ? crossAxisCount : 2,
          childAspectRatio: 1,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        children: [
          GameListItem(
              gameInfo: const GameInfo(
                  id: "1", name: "Klondike", icon: "klondike.png"),
              onGameSelect: (gameInfo) {
                onGameSelect(gameInfo, context);
              }),
          GameListItem(
            gameInfo: const GameInfo(
                id: "2", name: "Brick Breaker", icon: "brick-breaker.png"),
            onGameSelect: (gameInfo) {
              onGameSelect(gameInfo, context);
            },
          ),
        ],
      ),
    );
  }
}
