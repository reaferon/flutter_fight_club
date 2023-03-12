class FightResult {
  final String result;

  const FightResult._(this.result);

  static const won = FightResult._("Won");
  static const lost = FightResult._("Lost");
  static const draw = FightResult._("Draw");

  static FightResult?  calculateResult(final int yourLives, final int enemyLives) {
    if(yourLives == 0 && enemyLives == 0) {
      return draw;
    } else if(yourLives == 0) {
      return lost;
    } else if(enemyLives == 0) {
      return won;
    }
    return null;
  }

  @override
  String toString() {
    return 'FightResult{result: $result}';
  }
}