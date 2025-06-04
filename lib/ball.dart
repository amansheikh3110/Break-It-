import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';

class MyBall extends StatelessWidget {

  final ballX ;
  final ballY ;
  final isGameOver;
  final hasGameStarted;

  const MyBall({super.key, this.ballX, this.ballY, this.isGameOver, this.hasGameStarted});
  @override
  Widget build(BuildContext context) {
    return hasGameStarted ?
    Container(
      alignment: Alignment(ballX, ballY),
      child: Container(
        height: 16,
        width: 16,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    ): Container(
      alignment: Alignment(ballX, ballY),
      child: AvatarGlow(
        endRadius: 60.0,
        child: Material(
          elevation: 8.0,
          shape: CircleBorder(),
          child: CircleAvatar(
            backgroundColor: Colors.grey[100],
            radius: 7.0,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              width: 15,
              height: 15,
            ),
          ),
        ),
      ),
    );
  }
}
