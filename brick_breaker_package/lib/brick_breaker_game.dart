import '../widgets/overlay_screen.dart';
import '../widgets/restart_game.dart';
import '../widgets/score_card.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'brick_breaker.dart';
import 'config.dart';

class BrickBreakerGame extends StatefulWidget {
  const BrickBreakerGame({super.key});

  @override
  State<BrickBreakerGame> createState() => _BrickBreakerGameState();
}

class _BrickBreakerGameState extends State<BrickBreakerGame> {
  late final BrickBreaker game;

  @override
  void initState() {
    super.initState();
    game = BrickBreaker();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.pressStart2pTextTheme().apply(
          bodyColor: const Color(0xff184e77),
          displayColor: const Color(0xff184e77),
        ),
      ),
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xffa9d6e5),
                Color(0xff0cade3),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Column(                                  // Modify from here...
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ScoreCard(score: game.score),
                        RestartGame(reStart: game.reStart)
                      ],
                    ),
                    Expanded(
                      child: FittedBox(
                        child: SizedBox(
                          width: gameWidth,
                          height: gameHeight,
                          child: GameWidget(
                            game: game,
                            overlayBuilderMap: {
                              PlayState.welcome.name: (context, game) =>
                               OverlayScreen(
                                title: 'TAP TO PLAY',
                                subtitle: 'Use arrow keys or swipe',
                                onTap: this.game.onTap,
                               ),
                              PlayState.gameOver.name: (context, game) =>
                                  OverlayScreen(
                                    title: 'GAME OVER',
                                    subtitle: 'Tap to Play Again',
                                    onTap: this.game.onTap,
                                  ),
                              PlayState.won.name: (context, game) =>
                               OverlayScreen(
                                title: 'YOU WON!!!',
                                subtitle: 'Tap to Play Again',
                                 onTap: this.game.onTap,
                              ),
                              PlayState.pause.name: (context, game) =>
                                  OverlayScreen(
                                    title: 'GAME PAUSED',
                                    subtitle: 'Tap to Resume',
                                    onTap: this.game.onTap,
                                  ),
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),                                              // To here.
              ),
            ),
          ),
        ),
      ),
    );
  }
}