import 'package:flutter/material.dart';
import 'package:hangman/game/figure_widget.dart';
import 'package:hangman/game/hidden_letter.dart';
import 'package:hangman/const/const.dart';
import 'dart:math';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  var characters = "abcdefghijklmnopqrstuvwxyz".toUpperCase();
  var selectedChar = <String>[];
  var tries = 0;
  bool isAnswerCorrect = false;
  bool isGameLost = false;
  var wordList = [
    "palm".toUpperCase(),
    "love".toUpperCase(),
    "apple".toUpperCase(),
    "banana".toUpperCase(),
  ]; // เพิ่มโจทย์เพิ่มเติมที่นี่
  late String currentWord;

  void _getRandomWord() {
    setState(() {
      // สุ่มคำใหม่จากรายการ
      currentWord = wordList[Random().nextInt(wordList.length)];
      // รีเซ็ตค่าที่เกี่ยวกับเกม
      selectedChar.clear();
      tries = 0;
      isAnswerCorrect = false;
      isGameLost = false;
    });
  }

  @override
  void initState() {
    super.initState();
    // สุ่มเลือกโจทย์เมื่อเริ่มเกม
    currentWord = wordList[Random().nextInt(wordList.length)];
  }

  void _navigateToStartPage(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: GestureDetector(
          onTap: () {
            _navigateToStartPage(context);
          },
          child: Text(
            'Hangman',
            style: TextStyle(
              fontFamily: 'Pacifico',
              fontSize: 30.0,
              color: Colors.lightBlueAccent, // กำหนดสีของข้อความ
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.home,
              size: 36, // ขนาดของไอคอน
              color: Colors.green, // สีของไอคอน
            ),
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Color(0xFFCCCCFF),
      body: Column(
        children: [
          Expanded(
              flex: 3,
              child: Column(
                children: [
                  Expanded(
                    flex: 4,
                    child: Stack(
                      children: [
                        figure(GameUI.hang, tries >= 0),
                        figure(GameUI.head, tries >= 1),
                        figure(GameUI.body, tries >= 2),
                        figure(GameUI.leftArm, tries >= 3),
                        figure(GameUI.RightArm, tries >= 4),
                        figure(GameUI.leftLeg, tries >= 5),
                        figure(GameUI.RightLeg, tries >= 6),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: currentWord.split("").map((e) {
                          if (selectedChar.contains(e.toUpperCase())) {
                            return Text(
                              e,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          } else {
                            return hiddenLetter(e, true);
                          }
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              )),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 6,
                crossAxisCount: 8,
                children: characters.split("").map((e) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black87),
                    onPressed: selectedChar.contains(e.toUpperCase())
                        ? null
                        : () {
                            setState(() {
                              selectedChar.add(e.toUpperCase());
                              if (!currentWord
                                  .split("")
                                  .contains(e.toUpperCase())) {
                                tries++;
                              }
                              if (tries >= 6) {
                                isGameLost = true;
                              }
                              if (currentWord.split("").every(
                                  (letter) => selectedChar.contains(letter))) {
                                setState(() {
                                  isAnswerCorrect = true;
                                });
                              }
                            });
                          },
                    child: Text(
                      e,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          isAnswerCorrect
              ? Column(
                  children: [
                    Text(
                      "ยินดีด้วยคุณตอบถูก!",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _getRandomWord();
                      },
                      child: Text("Retry"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      },
                      child: Text("Home"),
                    ),
                  ],
                )
              : Container(),
          isGameLost
              ? Column(
                  children: [
                    Text(
                      "คุณแพ้เกม",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isGameLost = false;
                          selectedChar.clear();
                          tries = 0;
                        });
                      },
                      child: Text("Retry"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      },
                      child: Text("Home"),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}
