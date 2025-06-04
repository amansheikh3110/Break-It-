import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stuff/Bricks.dart';
import 'package:flutter_stuff/ball.dart';
import 'package:flutter_stuff/coverscreen.dart';
import 'package:flutter_stuff/gameoverscreen.dart';
import 'package:flutter_stuff/player.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

enum direction { UP, DOWN, LEFT, RIGHT }

class _HomePageState extends State<HomePage> {
  // ball variables
  double ballX = 0;
  double ballY = 0;
  double ballXincrements = 0.02;
  double ballYincrements = 0.01;
  var ballYDirection = direction.DOWN;
  var ballXDirection = direction.LEFT;

  // player variables
  double playerX = -0.2;
  double playerWidth = 0.4;

  // game settings
  bool hasGameStarted = false;
  bool isGameOver = false;

  // brick variables
  double brickWidth = 0.4;
  double brickHeight = 0.05;
  double brickGap = 0.01;
  double rowGap = 0.02;
  int numberOfBricksPerRow = 4;
  int numberOfRows = 3; // Default number of rows (can be 1-5)

  List<List<dynamic>> MyBricks = [];

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _generateBricks();
    // Request focus when widget is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  void _generateBricks() {
    final wallGap = 0.5 * (2 - numberOfBricksPerRow * brickWidth - (numberOfBricksPerRow - 1) * brickGap);
    final firstBrickX = -1 + wallGap;
    final firstBrickY = -0.9;

    List<List<dynamic>> newBricks = [];

    for (int row = 0; row < numberOfRows; row++) {
      double yPos = firstBrickY + row * (brickHeight + rowGap);

      for (int col = 0; col < numberOfBricksPerRow; col++) {
        double xPos = firstBrickX + col * (brickWidth + brickGap);
        newBricks.add([xPos, yPos, false]);
      }
    }

    setState(() {
      MyBricks = newBricks;
    });
  }

  void setNumberOfRows(int rows) {
    if (rows >= 1 && rows <= 5 && !hasGameStarted) {
      setState(() {
        numberOfRows = rows;
        _generateBricks();
      });
    }
  }

  void startGame() {
    hasGameStarted = true;
    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      // update all
      updateDirection();

      // move ball
      moveBall();

      if (isPlayerDead()) {
        timer.cancel();
        isGameOver = true;
      }

      // check for broken bricks
      checkForBrokrnBrick();
    });
  }

  void checkForBrokrnBrick() {
    for (int i = 0; i < MyBricks.length; i++) {
      if (ballX >= MyBricks[i][0] &&
          ballX <= MyBricks[i][0] + brickWidth &&
          ballY <= MyBricks[i][1] + brickHeight &&
          MyBricks[i][2] == false) {
        setState(() {
          MyBricks[i][2] = true;
          ballYDirection = direction.DOWN;

          double leftSideDist = (MyBricks[i][0] - ballX).abs();
          double rightSideDist = (MyBricks[i][0] + brickWidth - ballX).abs();
          double topSideDist = (MyBricks[i][1] - ballY).abs();
          double bottomSideDist = (MyBricks[i][1] + brickHeight - ballY).abs();

          String min = findMin(leftSideDist, rightSideDist, bottomSideDist, topSideDist);

          switch (min) {
            case 'left':
              ballXDirection = direction.RIGHT;
              break;
            case 'right':
              ballXDirection = direction.LEFT;
              break;
            case 'up':
              ballYDirection = direction.DOWN;
              break;
            case 'down':
              ballYDirection = direction.UP;
              break;
          }
        });
      }
    }
  }

  String findMin(double a, double b, double c, double d) {
    List<double> myList = [a, b, c, d];
    double currentMin = a;
    for (int i = 0; i < myList.length; i++) {
      if (myList[i] < currentMin) {
        currentMin = myList[i];
      }
    }

    if ((currentMin - a).abs() < 0.01) {
      return 'left';
    } else if ((currentMin - b).abs() < 0.01) {
      return 'right';
    } else if ((currentMin - c).abs() < 0.01) {
      return 'up';
    } else if ((currentMin - d).abs() < 0.01) {
      return 'down';
    }
    return '';
  }

  bool isPlayerDead() {
    if (ballY >= 1) {
      return true;
    }
    return false;
  }

  // move ball
  void moveBall() {
    setState(() {
      if (ballXDirection == direction.LEFT) {
        ballX -= ballXincrements;
      } else if (ballXDirection == direction.RIGHT) {
        ballX += ballXincrements;
      }
      if (ballYDirection == direction.DOWN) {
        ballY += ballYincrements;
      } else if (ballYDirection == direction.UP) {
        ballY -= ballYincrements;
      }
    });
  }

  // Update ball
  void updateDirection() {
    setState(() {
      // ball goes up when it hits the player
      if (ballY >= 0.9 && ballX >= playerX && ballX <= playerX + playerWidth) {
        ballYDirection = direction.UP;
      }
      // ball goes down when it hits the top of the screen
      else if (ballY <= -1) {
        ballYDirection = direction.DOWN;
      }
      // ball goes right when it hits the left wall
      else if (ballX <= -1) {
        ballXDirection = direction.RIGHT;
      }
      // ball goes left when it hits the right wall
      else if (ballX >= 1) {
        ballXDirection = direction.LEFT;
      }
    });
  }

  Timer? leftPressTimer;
  Timer? rightPressTimer;

  void startMovingLeft() {
    leftPressTimer?.cancel();
    leftPressTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      moveLeft();
    });
  }

  void startMovingRight() {
    rightPressTimer?.cancel();
    rightPressTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      moveRight();
    });
  }

  void stopMovingLeft() {
    leftPressTimer?.cancel();
  }

  void stopMovingRight() {
    rightPressTimer?.cancel();
  }

  // move player bar
  // move left
  void moveLeft() {
    setState(() {
      if (!(playerX - 0.1 < -1)) {
        playerX -= 0.1;
      }
    });
  }

  // move Right
  void moveRight() {
    setState(() {
      if (!(playerX + playerWidth >= 1)) {
        playerX += 0.1;
      }
    });
  }

  void ResetGame() {
    setState(() {
      playerX = -0.2;
      ballX = 0;
      ballY = 0;
      isGameOver = false;
      hasGameStarted = false;
      _generateBricks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent) {
          if (HardwareKeyboard.instance.isLogicalKeyPressed(LogicalKeyboardKey.arrowLeft)) {
            moveLeft();
          } else if (HardwareKeyboard.instance.isLogicalKeyPressed(LogicalKeyboardKey.arrowRight)) {
            moveRight();
          }
        }
      },
      child: GestureDetector(
        onTap: startGame,
        child: Scaffold(
          backgroundColor: Colors.grey[800],
          body: Center(
            child: Stack(
              children: [
                // Tap to play
                Coverscreen(
                  hasGameStarted: hasGameStarted,
                  isGameOver: isGameOver,
                ),

                // game over screen
                GameOverScreen(
                  isGameOver: isGameOver,
                  function: ResetGame,
                ),

                // ball
                MyBall(
                  ballX: ballX,
                  ballY: ballY,
                  hasGameStarted: hasGameStarted,
                  isGameOver: isGameOver,
                ),

                // player
                MyPlayer(
                  playerX: playerX,
                  playerWidth: playerWidth,
                ),

                // Bricks - dynamically generated
                for (var brick in MyBricks)
                  MyBrick(
                    brickHeight: brickHeight,
                    brickWidth: brickWidth,
                    brickX: brick[0],
                    brickY: brick[1],
                    BrickBroken: brick[2],
                  ),

                // LEFT ARROW
                Positioned(
                  bottom: 30,
                  left: 20,
                  child: GestureDetector(
                    onTap: moveLeft,
                    onTapCancel: stopMovingLeft,
                    onLongPressStart: (_) => startMovingLeft(),
                    onLongPressEnd: (_) => stopMovingLeft(),
                    child: const Icon(Icons.arrow_left, size: 50, color: Colors.white),
                  ),
                ),

                // RIGHT ARROW
                Positioned(
                  bottom: 30,
                  right: 20,
                  child: GestureDetector(
                    onTap: moveRight,
                    onTapCancel: stopMovingRight,
                    onLongPressStart: (_) => startMovingRight(),
                    onLongPressEnd: (_) => stopMovingRight(),
                    child: const Icon(Icons.arrow_right, size: 50, color: Colors.white),
                  ),
                ),

                // Row selection buttons (top right corner)
                Visibility(
                  visible: !hasGameStarted,
                  child :Positioned(
                    top: 550,
                    right: 160,
                    child: Row(
                      children: [
                        // Text('Rows:$numberOfRows', style: const TextStyle(color: Colors.white, fontFamily: 'pressStart')),
                        // const SizedBox(width: 10),
                        // Decrease row button
                        GestureDetector(
                          onTap: () => setNumberOfRows(numberOfRows - 1),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Icon(Icons.remove, size: 30, color: Colors.black),
                          ),
                        ),
                        const SizedBox(width: 5),
                        // Increase row button
                        GestureDetector(
                          onTap: () => setNumberOfRows(numberOfRows + 1),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Icon(Icons.add, size: 30, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}