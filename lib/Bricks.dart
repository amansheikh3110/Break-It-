import 'package:flutter/material.dart';
class MyBrick extends StatelessWidget {

  final brickHeight;
  final brickWidth;
  final brickX;
  final brickY;
  final BrickBroken;
  const MyBrick({super.key, this.brickHeight, this.brickWidth, this.brickX, this.brickY,
    required this.BrickBroken});

  @override
  Widget build(BuildContext context) {
    return BrickBroken ? Container()
        :Container(alignment: Alignment((2 * brickX + brickWidth)/(2 - brickWidth), brickY),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child:Container(
                height:
                MediaQuery.of(context).size.height*brickHeight / 2,
                width:
                MediaQuery.of(context).size.width*brickWidth / 2,
                color: Colors.white,
              )
          ),
        );
  }
}
