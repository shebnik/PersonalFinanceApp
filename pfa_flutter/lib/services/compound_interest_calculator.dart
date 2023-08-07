import 'dart:math';

import 'package:pfa_flutter/utils/logger.dart';

class CompoundInterestCalculator {
  static const interestRate = 0.10; // 10%
  static const yearsToGrow = 10; // 10 years

  static double calculate(double unspentMoney) {
    if (yearsToGrow == 0) return unspentMoney;
    double result = unspentMoney * pow(1 + interestRate, yearsToGrow);
    Logger.i(
        '[CompoundInterestCalculator] unspentMoney: $unspentMoney with interestRate: $interestRate in $yearsToGrow years = $result');
    return result;
  }
}
