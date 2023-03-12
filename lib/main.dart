import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fight_club/resources/fight_club_icons.dart';
import 'package:flutter_fight_club/resources/fight_club_colors.dart';
import 'package:flutter_fight_club/resources/fight_club_images.dart';
import 'package:flutter_fight_club/pages/main_page.dart';
import 'package:google_fonts/google_fonts.dart';

import 'widgets/action_button.dart';

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
      home: MainPage(),
    );
  }
}
