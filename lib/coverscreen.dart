import 'package:flutter/material.dart';

class Coverscreen extends StatelessWidget {
  const Coverscreen({super.key, required this.hasGameStarted, required this.isGameOver});

  final bool hasGameStarted;
  final bool isGameOver;


  @override
  Widget build(BuildContext context) {
    return hasGameStarted ? Container(
      alignment: Alignment(0, -0.5),
      child: Text(isGameOver ? '' : 'BREAK IT',
        style: TextStyle(
        color: Colors.grey[600],
        fontFamily: 'PressStart',
        fontSize: 25,
      )
    )
    )
        : Stack(
      children:[Container(
        alignment: Alignment(0, -0.5),
        child: Text('BREAK IT', style: TextStyle(color: Colors.white, fontSize: 25, fontFamily: 'PressStart'),
        ),
      ),
        Container(
          alignment: Alignment(0, 0.8),
          child: Text('Tap To Play', style: TextStyle(color: Colors.white, fontSize: 15, fontFamily: 'PressStart'),
        ),)
      ],
    );
  }
}
