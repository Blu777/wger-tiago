/*
 * This file is part of wger Workout Manager <https://github.com/wger-project>.
 * Copyright (C) 2020, 2021 wger Team
 *
 * wger Workout Manager is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:logging/logging.dart';
import 'package:wger/helpers/consts.dart';
import 'package:wger/models/exercises/category.dart';
import 'package:wger/models/exercises/equipment.dart';
import 'package:wger/models/exercises/exercise_api.dart';
import 'package:wger/models/exercises/image.dart';
import 'package:wger/models/exercises/language.dart';
import 'package:wger/models/exercises/muscle.dart';
import 'package:wger/models/exercises/translation.dart';
import 'package:wger/models/exercises/video.dart';

part 'exercise.g.dart';

@JsonSerializable(explicitToJson: true)
class Exercise extends Equatable {
  static final _logger = Logger('ExerciseModel');

  @JsonKey(required: true)
  final int? id;

  @JsonKey(required: true)
  final String? uuid;

  @JsonKey(required: true, name: 'variation_group')
  final String? variationGroup;

  @JsonKey(required: true, name: 'created')
  final DateTime? created;

  @JsonKey(required: true, name: 'last_update')
  final DateTime? lastUpdate;

  @JsonKey(required: true, name: 'last_update_global')
  final DateTime? lastUpdateGlobal;

  @JsonKey(required: true, name: 'category')
  final int categoryId;

  @JsonKey(includeFromJson: true, includeToJson: true, name: 'categories')
  final ExerciseCategory? category;

  @JsonKey(required: true, name: 'muscles')
  final List<int> musclesIds;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final List<Muscle> muscles;

  @JsonKey(required: true, name: 'muscles_secondary')
  final List<int> musclesSecondaryIds;

  @JsonKey(includeFromJson: false, includeToJson: true)
  final List<Muscle> musclesSecondary;

  @JsonKey(required: true, name: 'equipment')
  final List<int> equipmentIds;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final List<Equipment> equipment;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final List<ExerciseImage> images;

  @JsonKey(includeFromJson: true, includeToJson: false)
  final List<Translation> translations;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final List<Video> videos;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final List<String> authors;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final List<String> authorsGlobal;

  const Exercise({
    this.id,
    this.uuid,
    this.created,
    this.lastUpdate,
    this.lastUpdateGlobal,
    this.variationGroup,
    this.categoryId = 0,
    this.category,
    this.musclesIds = const [],
    this.muscles = const [],
    this.musclesSecondaryIds = const [],
    this.musclesSecondary = const [],
    this.equipmentIds = const [],
    this.equipment = const [],
    this.images = const [],
    this.translations = const [],
    this.videos = const [],
    this.authors = const [],
    this.authorsGlobal = const [],
  });

  bool get showPlateCalculator => equipment.map((e) => e.id).contains(ID_EQUIPMENT_BARBELL);

  factory Exercise.fromApiDataString(String baseData, List<Language> languages) =>
      Exercise.fromApiData(ExerciseApiData.fromString(baseData), languages);

  factory Exercise.fromApiDataJson(Map<String, dynamic> baseData, List<Language> languages) =>
      Exercise.fromApiData(ExerciseApiData.fromJson(baseData), languages);

  factory Exercise.fromApiData(ExerciseApiData exerciseData, List<Language> languages) {
    final languageMap = {for (final l in languages) l.id: l};

    return Exercise(
      id: exerciseData.id,
      uuid: exerciseData.uuid,
      categoryId: exerciseData.category.id,
      category: exerciseData.category,
      created: exerciseData.created,
      lastUpdate: exerciseData.lastUpdate,
      lastUpdateGlobal: exerciseData.lastUpdateGlobal,
      muscles: exerciseData.muscles,
      musclesIds: exerciseData.muscles.map((e) => e.id).toList(),
      musclesSecondary: exerciseData.musclesSecondary,
      musclesSecondaryIds: exerciseData.musclesSecondary.map((e) => e.id).toList(),
      equipment: exerciseData.equipment,
      equipmentIds: exerciseData.equipment.map((e) => e.id).toList(),
      translations: exerciseData.translations.map((e) {
        final lang = languageMap[e.languageId] ??
            Language(
              id: e.languageId,
              shortName: 'unknown',
              fullName: 'unknown',
            );
        return e.copyWith(languageObj: lang);
      }).toList(),
      videos: exerciseData.videos,
      images: exerciseData.images,
      authors: exerciseData.authors,
      authorsGlobal: exerciseData.authorsGlobal,
      variationGroup: exerciseData.variationGroup,
    );
  }

  /// Returns translation for the given language
  ///
  /// If no translation is found, English will be returned
  ///
  /// Note: we return the first translation as a fallback if we don't find a
  ///       translation in English. This is something that should never happen,
  ///       but we can't make sure that no local installation hasn't deleted
  ///       the entry in English.
  Translation getTranslation(String language) {
    // Guard against empty translations
    if (translations.isEmpty) {
      _logger.info('[Exercise] No translations for exercise $id, returning fallback');
      return const Translation(
        id: null,
        languageId: 0,
        name: 'Unknown exercise',
        description: 'No translation available',
      );
    }

    // If the language is in the form en-US, take the language code only
    final languageCode = language.split('-')[0];

    return translations.firstWhere(
      (e) => e.languageObj?.shortName == languageCode,
      orElse: () => translations.firstWhere(
        (e) => e.languageObj?.shortName == LANGUAGE_SHORT_ENGLISH,
        orElse: () {
          _logger.info(
            'Could not find fallback english translation for exercise-ID $id, returning '
            'first language (${translations.first.languageObj?.shortName ?? 'unknown'}) instead.',
          );
          return translations.first;
        },
      ),
    );
  }

  ExerciseImage? get getMainImage {
    return images.firstWhereOrNull((image) => image.isMain);
  }

  Exercise copyWith({
    int? id,
    String? uuid,
    String? variationGroup,
    DateTime? created,
    DateTime? lastUpdate,
    DateTime? lastUpdateGlobal,
    int? categoryId,
    ExerciseCategory? category,
    List<int>? musclesIds,
    List<Muscle>? muscles,
    List<int>? musclesSecondaryIds,
    List<Muscle>? musclesSecondary,
    List<int>? equipmentIds,
    List<Equipment>? equipment,
    List<ExerciseImage>? images,
    List<Translation>? translations,
    List<Video>? videos,
    List<String>? authors,
    List<String>? authorsGlobal,
  }) =>
      Exercise(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        variationGroup: variationGroup ?? this.variationGroup,
        created: created ?? this.created,
        lastUpdate: lastUpdate ?? this.lastUpdate,
        lastUpdateGlobal: lastUpdateGlobal ?? this.lastUpdateGlobal,
        categoryId: categoryId ?? this.categoryId,
        category: category ?? this.category,
        musclesIds: musclesIds ?? this.musclesIds,
        muscles: muscles ?? this.muscles,
        musclesSecondaryIds: musclesSecondaryIds ?? this.musclesSecondaryIds,
        musclesSecondary: musclesSecondary ?? this.musclesSecondary,
        equipmentIds: equipmentIds ?? this.equipmentIds,
        equipment: equipment ?? this.equipment,
        images: images ?? this.images,
        translations: translations ?? this.translations,
        videos: videos ?? this.videos,
        authors: authors ?? this.authors,
        authorsGlobal: authorsGlobal ?? this.authorsGlobal,
      );

  // Boilerplate
  factory Exercise.fromJson(Map<String, dynamic> json) => _$ExerciseFromJson(json);

  Map<String, dynamic> toJson() => _$ExerciseToJson(this);

  @override
  List<Object?> get props => [
    id,
    uuid,
    created,
    lastUpdate,
    category,
    equipment,
    muscles,
    musclesSecondary,
  ];
}
