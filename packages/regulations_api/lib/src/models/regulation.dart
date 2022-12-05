import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:regulations_api/regulations_api.dart';
import 'package:uuid/uuid.dart';

part 'regulation.g.dart';

/// {@template Regulation}
/// A single Regulation item.
///
/// Contains a [title], [description] and [id], in addition to a [isCompleted]
/// flag.
///
/// If an [id] is provided, it cannot be empty. If no [id] is provided, one
/// will be generated.
///
/// [Regulation]s are immutable and can be copied using [copyWith], in addition to
/// being serialized and deserialized using [toJson] and [fromJson]
/// respectively.
/// {@endtemplate}
@immutable
@JsonSerializable()
class Regulation extends Equatable {
  /// {@macro Regulation}
  Regulation({
    String? id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
  })  : assert(
  id == null || id.isNotEmpty,
  'id can not be null and should be empty',
  ),
        id = id ?? const Uuid().v4();

  /// The unique identifier of the Regulation.
  ///
  /// Cannot be empty.
  final String id;

  /// The title of the Regulation.
  ///
  /// Note that the title may be empty.
  final String title;

  /// The description of the Regulation.
  ///
  /// Defaults to an empty string.
  final String description;

  /// Whether the Regulation is completed.
  ///
  /// Defaults to `false`.
  final bool isCompleted;

  /// Returns a copy of this Regulation with the given values updated.
  ///
  /// {@macro Regulation}
  Regulation copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
  }) {
    return Regulation(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  /// Deserializes the given [JsonMap] into a [Regulation].
  static Regulation fromJson(JsonMap json) => _$RegulationFromJson(json);

  /// Converts this [Regulation] into a [JsonMap].
  JsonMap toJson() => _$RegulationToJson(this);

  @override
  List<Object> get props => [id, title, description, isCompleted];
}
