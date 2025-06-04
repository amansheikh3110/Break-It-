import 'package:flutter/material.dart';
class GameOverScreen extends StatelessWidget {

  final bool isGameOver;
  final function;


  const GameOverScreen({super.key, required this.isGameOver, this.function});

  @override
  Widget build(BuildContext context) {
    return isGameOver ?
        Stack(children: [
          Container(
            alignment: Alignment(0, -0.3),
            child: Text(
              "GAME OVER",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'PressStart',
                fontSize: 25,
              ),
            ),
          ),
          Container(
            alignment: Alignment(0, 0),
            child: GestureDetector(
              onTap: function,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 50,
                  width: 120,
                  color: Colors.black,
                  child: Center(
                    child: Text(
                      "PLAY AGAIN",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'PressStart',
                        fontSize: 13, // Optional: adjust for visibility
                      ),
                      textAlign: TextAlign.center, // Optional: safe to keep
                    ),
                  ),
                ),
              ),
            ),
          )
          ,
        ],):Container();
  }
}
