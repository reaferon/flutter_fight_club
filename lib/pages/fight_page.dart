
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fight_club/fight_result.dart';
import 'package:flutter_fight_club/resources/fight_club_colors.dart';
import 'package:flutter_fight_club/resources/fight_club_icons.dart';
import 'package:flutter_fight_club/resources/fight_club_images.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/action_button.dart';

class FightPage extends StatefulWidget {
  @override
  State<FightPage> createState() => FightPageState();
}

class FightPageState extends State<FightPage> {
  static const maxLives = 5;
  int yourLives = maxLives;
  int enemyLives = maxLives;
  String centerText = "";

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
                    child: Center(
                        child: Text(
                          centerText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: FightClubColors.darkGreyText,
                          ),
                        )),
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
            ActionButton(
                text:
                yourLives == 0 || enemyLives == 0 ? "Back" : "Go",
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
        Navigator.of(context).pop();
        // yourLives = maxLives;
        // enemyLives = maxLives;
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

      final FightResult? fightResult = FightResult.calculateResult(yourLives, enemyLives);

      if(fightResult != null) {
        SharedPreferences.getInstance().then((sharedPreferences) {
          sharedPreferences.setString("last_fight_result", fightResult.result); 
        });
      }
      centerText = _calculateCenterText();

      whatEnemyDefends = BodyPart.random();
      whatEnemyAttack = BodyPart.random();

      defendingBodyPart = null;
      attackingBodyPart = null;
    }
  }

  String _calculateCenterText() {
    if (enemyLives == 0 && yourLives == 0) {
      return "Draw";
    } else if (yourLives == 0) {
      return "You lost";
    } else if (enemyLives == 0) {
      return "You won";
    } else {
      centerText = (attackingBodyPart != whatEnemyDefends)
          ? "You hit enemy's ${attackingBodyPart!.name.toLowerCase()}.\n"
          : "Your attack was blocked.\n";
      centerText += (defendingBodyPart != whatEnemyAttack)
          ? "Enemy hit your ${whatEnemyAttack!.name.toLowerCase()}.\n"
          : "Enemy attack was blocked.\n";
      return centerText;
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
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        color: FightClubColors.white,
                        gradient: LinearGradient(
                          colors: [
                            FightClubColors.white,
                            FightClubColors.darkPurple
                          ],
                        )),
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
                  Image.asset(
                    FightClubImages.youAvatar,
                    width: 92,
                    height: 92,
                  ),
                ],
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                    color: FightClubColors.blueButton, shape: BoxShape.circle),
                child: SizedBox(
                  width: 44,
                  height: 44,
                  child: Center(
                      child: Text(
                        "vs",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: FightClubColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      )),
                ),
              ),
              Column(
                children: [
                  SizedBox(height: 16),
                  Text("Enemy",
                      style: TextStyle(color: FightClubColors.darkGreyText)),
                  SizedBox(height: 12),
                  Image.asset(
                    FightClubImages.enemyAvatar,
                    width: 92,
                    height: 92,
                  ),
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
            return Padding(
              padding: EdgeInsets.only(
                  bottom: (index < overallLivesCount - 1) ? 4 : 0),
              child: Image.asset(
                FightClubIcons.heartFull,
                width: 18,
                height: 18,
              ),
            );
          } else {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: (index < overallLivesCount - 1) ? 4 : 0),
              child: Image.asset(
                FightClubIcons.heartEmpty,
                width: 18,
                height: 18,
              ),
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
        child: DecoratedBox(
          decoration: BoxDecoration(
              color: selected ? FightClubColors.blueButton : Colors.transparent,
              border: selected
                  ? null
                  : Border.all(color: FightClubColors.darkGreyText, width: 2)),
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
