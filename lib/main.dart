import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fight_club/fight_club_icons.dart';
import 'package:flutter_fight_club/fight_club_colors.dart';
import 'package:flutter_fight_club/fight_club_images.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme:
            GoogleFonts.pressStart2pTextTheme(Theme.of(context).textTheme),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const maxLives = 5;
  int yourLives = maxLives;
  int enemyLives = maxLives;

  BodyPart? defendingBodyPart;
  BodyPart? attackingBodyPart;
  BodyPart whatEnemyDefends = BodyPart.random();
  BodyPart whatEnemyAttack = BodyPart.random();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FightClubColors.background,
      body: SafeArea(
        child: Column(
          children: [
            FightersInfo(
              maxLivesCount: maxLives,
              yourLivesCount: yourLives,
              enemyLivesCount: enemyLives,
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                child: ColoredBox(
                  color: FightClubColors.darkPurple,
                  child: SizedBox(
                    width: double.infinity,

                  ),
                ),
              ),
            ),
            ControlsWidget(
              defendingBodyPart: defendingBodyPart,
              attackingBodyPart: attackingBodyPart,
              selectDefendingBodyPart: _selectDefendingBodyPart,
              selectAttackingBodyPart: _selectAttackingBodyPart,
            ),
            SizedBox(height: 14),
            GoButton(
                text:
                    yourLives == 0 || enemyLives == 0 ? "Start new game" : "Go",
                onTap: () {
                  setState(() {
                    _onGoButtonClicked();
                  });
                },
                color: _getGoButtonColor()),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Color _getGoButtonColor() {
    if (yourLives == 0 || enemyLives == 0) {
      return FightClubColors.greyButton;
    } else if (defendingBodyPart != null && attackingBodyPart != null) {
      return FightClubColors.blackButton;
    } else {
      return FightClubColors.greyButton;
    }
  }

  void _onGoButtonClicked() {
    if (yourLives == 0 || enemyLives == 0) {
      setState(() {
        yourLives = maxLives;
        enemyLives = maxLives;
      });
    } else if (defendingBodyPart != null && attackingBodyPart != null) {
      final bool enemyLoseLife = attackingBodyPart != whatEnemyDefends;
      final bool youLoseLife = defendingBodyPart != whatEnemyAttack;

      if (enemyLoseLife) {
        enemyLives -= 1;
      }
      if (youLoseLife) {
        yourLives -= 1;
      }
      whatEnemyDefends = BodyPart.random();
      whatEnemyAttack = BodyPart.random();

      defendingBodyPart = null;
      attackingBodyPart = null;
    }
  }

  void _selectDefendingBodyPart(final BodyPart value) {
    if (yourLives == 0 || enemyLives == 0) {
      return;
    }
    setState(() {
      defendingBodyPart = value;
    });
  }

  void _selectAttackingBodyPart(BodyPart value) {
    if (yourLives == 0 || enemyLives == 0) {
      return;
    }
    setState(() {
      attackingBodyPart = value;
    });
  }
}

class GoButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color color;

  const GoButton(
      {Key? key, required this.text, required this.onTap, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          height: 40,
          child: ColoredBox(
            color: color,
            child: Center(
              child: Text(
                text.toUpperCase(),
                style: TextStyle(
                    color: FightClubColors.whiteText,
                    fontSize: 16,
                    fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FightersInfo extends StatelessWidget {
  final int maxLivesCount;
  final int yourLivesCount;
  final int enemyLivesCount;

  const FightersInfo({
    super.key,
    required this.maxLivesCount,
    required this.yourLivesCount,
    required this.enemyLivesCount,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                  child: ColoredBox(
                color: FightClubColors.white,
              )),
              Expanded(
                  child: ColoredBox(
                color: FightClubColors.darkPurple,
              )),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LivesWidget(
                overallLivesCount: maxLivesCount,
                currentLivesCount: yourLivesCount,
              ),
              Column(
                children: [
                  SizedBox(height: 16),
                  Text(
                    "You",
                    style: TextStyle(color: FightClubColors.darkGreyText),
                  ),
                  SizedBox(height: 12),
                  Image.asset(FightClubImages.youAvatar, width: 92, height: 92,),
                ],
              ),
              ColoredBox(
                color: Colors.green,
                child: SizedBox(
                  width: 44,
                  height: 44,
                ),
              ),
              Column(
                children: [
                  SizedBox(height: 16),
                  Text("Enemy",
                      style: TextStyle(color: FightClubColors.darkGreyText)),
                  SizedBox(height: 12),
                  Image.asset(FightClubImages.enemyAvatar, width: 92, height: 92,),
                ],
              ),
              LivesWidget(
                overallLivesCount: maxLivesCount,
                currentLivesCount: enemyLivesCount,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ControlsWidget extends StatelessWidget {
  BodyPart? defendingBodyPart;
  BodyPart? attackingBodyPart;
  final ValueSetter<BodyPart> selectDefendingBodyPart;
  final ValueSetter<BodyPart> selectAttackingBodyPart;

  ControlsWidget({
    super.key,
    required this.defendingBodyPart,
    required this.attackingBodyPart,
    required this.selectDefendingBodyPart,
    required this.selectAttackingBodyPart,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: 16),
        Expanded(
          child: Column(
            children: [
              Text("Defend".toUpperCase(),
                  style: TextStyle(color: FightClubColors.darkGreyText)),
              SizedBox(height: 13),
              BodyPartButton(
                bodyPart: BodyPart.head,
                selected: defendingBodyPart == BodyPart.head,
                bodyPartSetter: selectDefendingBodyPart,
              ),
              SizedBox(height: 14),
              BodyPartButton(
                bodyPart: BodyPart.torso,
                selected: defendingBodyPart == BodyPart.torso,
                bodyPartSetter: selectDefendingBodyPart,
              ),
              SizedBox(height: 14),
              BodyPartButton(
                bodyPart: BodyPart.legs,
                selected: defendingBodyPart == BodyPart.legs,
                bodyPartSetter: selectDefendingBodyPart,
              ),
            ],
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            children: [
              Text("Attack".toUpperCase(),
                  style: TextStyle(color: FightClubColors.darkGreyText)),
              SizedBox(height: 13),
              BodyPartButton(
                bodyPart: BodyPart.head,
                selected: attackingBodyPart == BodyPart.head,
                bodyPartSetter: selectAttackingBodyPart,
              ),
              SizedBox(height: 14),
              BodyPartButton(
                bodyPart: BodyPart.torso,
                selected: attackingBodyPart == BodyPart.torso,
                bodyPartSetter: selectAttackingBodyPart,
              ),
              SizedBox(height: 14),
              BodyPartButton(
                bodyPart: BodyPart.legs,
                selected: attackingBodyPart == BodyPart.legs,
                bodyPartSetter: selectAttackingBodyPart,
              ),
            ],
          ),
        ),
        SizedBox(width: 16),
      ],
    );
  }
}

class LivesWidget extends StatelessWidget {
  final int overallLivesCount;
  final int currentLivesCount;

  const LivesWidget({
    Key? key,
    required this.overallLivesCount,
    required this.currentLivesCount,
  })  : assert(overallLivesCount >= 1),
        assert(currentLivesCount >= 0),
        assert(currentLivesCount <= overallLivesCount),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(overallLivesCount, (index) {
          if (index < currentLivesCount) {
            return Image.asset(
              FightClubIcons.heartFull,
              width: 18,
              height: 18,
            );
          } else {
            return Image.asset(
              FightClubIcons.heartEmpty,
              width: 18,
              height: 18,
            );
          }
        }));
  }
}

class BodyPart {
  final String name;

  const BodyPart._(this.name);

  static const head = BodyPart._("Head");
  static const torso = BodyPart._("Torso");
  static const legs = BodyPart._("Legs");

  @override
  String toString() {
    return 'BodyPart{name: $name}';
  }

  static const List<BodyPart> _values = [head, torso, legs];

  static BodyPart random() {
    return _values[Random().nextInt(_values.length)];
  }
}

class BodyPartButton extends StatelessWidget {
  final BodyPart bodyPart;
  final bool selected;
  final ValueSetter<BodyPart> bodyPartSetter;

  const BodyPartButton({
    super.key,
    required this.bodyPart,
    required this.selected,
    required this.bodyPartSetter,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => bodyPartSetter(bodyPart),
      child: SizedBox(
        height: 40,
        child: ColoredBox(
          color: selected
              ? FightClubColors.blueButton
              : FightClubColors.greyButton,
          child: Center(
              child: Text(
            bodyPart.name.toUpperCase(),
            style: TextStyle(
              color: FightClubColors.darkGreyText,
            ),
          )),
        ),
      ),
    );
  }
}
