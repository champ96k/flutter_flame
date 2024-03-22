import 'package:flutter/material.dart';
import 'package:game_launcher/model/game_info.dart';

class GameListItem extends StatelessWidget{
   const GameListItem({super.key, required this.gameInfo, required this.onGameSelect});

  final GameInfo gameInfo;
  final Function(GameInfo gameInfo) onGameSelect;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        onGameSelect(gameInfo);
      },
      child: Column(
        children: [
          const SizedBox(height: 20,),
          Image.asset(
              "assets/images/${gameInfo.icon}",
            width: 100,
            height: 100,
          ),
          Text(gameInfo.name),
        ],
      ),
    );
  }

}