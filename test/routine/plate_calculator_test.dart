/*
 * This file is part of wger Workout Manager <https://github.com/wger-project>.
 * Copyright (C) 2020, 2021 wger Team
 *
 * wger Workout Manager is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * wger Workout Manager is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:wger/helpers/consts.dart';
import 'package:wger/helpers/gym_mode.dart';

void main() {
  group('Test the plate calculator', () {
    test('Regular weights', () {
      expect(plateCalculator(40, BAR_WEIGHT, AVAILABLE_PLATES), [10]);
      expect(plateCalculator(100, BAR_WEIGHT, AVAILABLE_PLATES), [15, 15, 10]);
      expect(plateCalculator(102.5, BAR_WEIGHT, AVAILABLE_PLATES), [15, 15, 10, 1.25]);
      expect(plateCalculator(140, BAR_WEIGHT, AVAILABLE_PLATES), [15, 15, 15, 15]);
      expect(plateCalculator(45, BAR_WEIGHT, AVAILABLE_PLATES), [10, 2.5]);
      expect(plateCalculator(85, BAR_WEIGHT, AVAILABLE_PLATES), [15, 15, 2.5]);
    });

    test('Exceptions', () {
      expect(
        plateCalculator(10, BAR_WEIGHT, AVAILABLE_PLATES),
        [],
        reason: 'Weight is less than the bar',
      );

      expect(
        plateCalculator(101, BAR_WEIGHT, AVAILABLE_PLATES),
        [],
        reason: 'Weight cant be achieved with plates (40.5 per side, 0.5 remaining)',
      );

      // Use a weight that really can't be achieved
      expect(
        plateCalculator(103, BAR_WEIGHT, AVAILABLE_PLATES),
        [],
        reason: 'Weight cant be achieved with plates',
      );
    });

    test('Floating point precision edge cases', () {
      // This case was failing due to floating point precision issues
      expect(plateCalculator(45, BAR_WEIGHT, AVAILABLE_PLATES), [10, 2.5]);
      
      // Test other decimal cases that should work
      expect(plateCalculator(50, BAR_WEIGHT, AVAILABLE_PLATES), [15]);
      expect(plateCalculator(55, BAR_WEIGHT, AVAILABLE_PLATES), [15, 2.5]);
    });

    test('Common squat weights with full plate set', () {
      // Test with full KG plate set like in the app
      final fullKgPlates = [0.5, 1, 1.25, 2, 2.5, 5, 10, 15, 20, 25];
      
      // Common squat weights that should work
      expect(plateCalculator(60, 20, fullKgPlates), [20]); // 60kg: 20 each side
      expect(plateCalculator(80, 20, fullKgPlates), [25, 5]); // 80kg: 25+5 each side
      expect(plateCalculator(100, 20, fullKgPlates), [25, 15]); // 100kg: 25+15 each side
      expect(plateCalculator(120, 20, fullKgPlates), [25, 25]); // 120kg: 25+25 each side
      expect(plateCalculator(140, 20, fullKgPlates), [25, 25, 10]); // 140kg: 25+25+10 each side
      expect(plateCalculator(160, 20, fullKgPlates), [25, 25, 20]); // 160kg: 25+25+20 each side
      expect(plateCalculator(180, 20, fullKgPlates), [25, 25, 25, 5]); // 180kg: 25+25+25+5 each side
      expect(plateCalculator(200, 20, fullKgPlates), [25, 25, 25, 15]); // 200kg: 25+25+25+15 each side
    });

    test('Problematic weights that might fail', () {
      final fullKgPlates = [0.5, 1, 1.25, 2, 2.5, 5, 10, 15, 20, 25];
      
      // Test weights that require smaller plates
      expect(plateCalculator(22.5, 20, fullKgPlates), [1.25]); // 22.5kg: 1.25 each side
      expect(plateCalculator(25, 20, fullKgPlates), [2.5]); // 25kg: 2.5 each side
      expect(plateCalculator(27.5, 20, fullKgPlates), [2.5, 1.25]); // 27.5kg: 2.5+1.25 each side
      expect(plateCalculator(30, 20, fullKgPlates), [5]); // 30kg: 5 each side
      expect(plateCalculator(32.5, 20, fullKgPlates), [5, 1.25]); // 32.5kg: 5+1.25 each side
      expect(plateCalculator(35, 20, fullKgPlates), [5, 2.5]); // 35kg: 5+2.5 each side
      expect(plateCalculator(37.5, 20, fullKgPlates), [5, 2.5, 1.25]); // 37.5kg: 5+2.5+1.25 each side
      expect(plateCalculator(40, 20, fullKgPlates), [10]); // 40kg: 10 each side
    });
  });

  group('Test the plate calculator group', () {
    test('Test groups', () {
      expect(groupPlates([15, 15, 15, 10, 10, 5]), {15: 3, 10: 2, 5: 1});
      expect(groupPlates([15, 10, 5, 1.25]), {15: 1, 10: 1, 5: 1, 1.25: 1});
      expect(groupPlates([10, 10, 10, 10, 10, 10, 10]), {10: 7});
    });
  });
}
