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

/// Calculates the number of plates needed to reach a specific weight
List<num> plateCalculator(num totalWeight, num barWeight, List<num> plates) {
  final List<num> result = [];
  final sortedPlates = List.of(plates)..sort();

  // Weight is less than the bar
  if (totalWeight < barWeight) {
    return [];
  }

  if (sortedPlates.isEmpty) {
    return [];
  }

  // Remove the bar and divide by two to get weight on each side
  totalWeight = (totalWeight - barWeight) / 2;

  // Iterate through the plates, beginning with the biggest ones
  for (final plate in sortedPlates.reversed) {
    while (totalWeight >= plate) {
      totalWeight -= plate;
      result.add(plate);
    }
  }

  // Check if we can achieve the remaining weight with the smallest plate
  // Use tolerance for floating point comparison
  const double tolerance = 1e-10;
  if (totalWeight > tolerance) {
    // Check if remaining weight can be achieved with available plates
    bool canAchieveRemaining = false;
    for (final plate in sortedPlates) {
      if ((totalWeight / plate - (totalWeight / plate).floor()).abs() < tolerance) {
        canAchieveRemaining = true;
        break;
      }
    }
    
    if (!canAchieveRemaining) {
      return []; // Can't achieve exact weight with available plates
    }
  }

  return result;
}

/// Groups a list of plates as calculated by [plateCalculator]
///
/// e.g. [15, 15, 15, 10, 10, 5] returns {15: 3, 10: 2, 5: 1}
Map<num, int> groupPlates(List<num> plates) {
  final Map<num, int> out = {};
  for (final plate in plates) {
    if (!out.containsKey(plate)) {
      out[plate] = 1;
    } else {
      out[plate] = out[plate]! + 1;
    }
  }

  return out;
}
