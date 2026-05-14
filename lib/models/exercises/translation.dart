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

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:wger/models/exercises/alias.dart';
import 'package:wger/models/exercises/comment.dart';
import 'package:wger/models/exercises/language.dart';

part 'translation.g.dart';

@JsonSerializable()
class Translation extends Equatable {
  @JsonKey(required: true)
  final int? id;

  @JsonKey(required: true)
  final String? uuid;

  @JsonKey(required: true, name: 'language')
  final int languageId;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final Language? languageObj;

  @JsonKey(required: true, name: 'created')
  final DateTime? created;

  @JsonKey(required: true, name: 'exercise')
  final int? exerciseId;

  @JsonKey(required: true)
  final String name;

  @JsonKey(required: true)
  final String description;

  @JsonKey(name: 'description_source', defaultValue: '')
  final String descriptionSource;

  @JsonKey(includeFromJson: true, includeToJson: false)
  final List<Comment> notes;

  @JsonKey(includeFromJson: true, includeToJson: false)
  final List<Alias> aliases;

  const Translation({
    this.id,
    this.uuid,
    required this.languageId,
    this.languageObj,
    this.created,
    this.exerciseId,
    required this.name,
    required this.description,
    this.descriptionSource = '',
    this.notes = const [],
    this.aliases = const [],
  });

  Translation copyWith({
    int? id,
    String? uuid,
    int? languageId,
    Language? languageObj,
    DateTime? created,
    int? exerciseId,
    String? name,
    String? description,
    String? descriptionSource,
    List<Comment>? notes,
    List<Alias>? aliases,
  }) =>
      Translation(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        languageId: languageId ?? this.languageId,
        languageObj: languageObj ?? this.languageObj,
        created: created ?? this.created,
        exerciseId: exerciseId ?? this.exerciseId,
        name: name ?? this.name,
        description: description ?? this.description,
        descriptionSource: descriptionSource ?? this.descriptionSource,
        notes: notes ?? this.notes,
        aliases: aliases ?? this.aliases,
      );

  // Boilerplate
  factory Translation.fromJson(Map<String, dynamic> json) => _$TranslationFromJson(json);

  Map<String, dynamic> toJson() => _$TranslationToJson(this);

  @override
  List<Object?> get props => [
    id,
    exerciseId,
    uuid,
    languageId,
    created,
    name,
    description,
    descriptionSource,
  ];
}
