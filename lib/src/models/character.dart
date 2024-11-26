import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:testapp/src/services/services.dart';

part 'character.g.dart';

/// character model class to hold character data
@JsonSerializable()
class CharacterModel extends Equatable {
  final int id;
  final String name;
  final String status;
  final String species;
  final String type;
  final String gender;
  final OriginModel origin;
  final LocationModel location;
  final String image;
  final List<String> episode;
  final String url;
  final String created;

  const CharacterModel({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.origin,
    required this.location,
    required this.image,
    required this.episode,
    required this.url,
    required this.created,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$CharacterModelFromJson(json);
    } catch (e, stackTrace) {
      loggerService.error('Error deserializing CharacterModel', e, stackTrace);
      throw FormatException('Invalid JSON for CharacterModel');
    }
  }

  Map<String, dynamic> toJson() {
    try {
      return _$CharacterModelToJson(this);
    } catch (e, stackTrace) {
      loggerService.error('Error serializing CharacterModel', e, stackTrace);
      throw Exception('Serialization failed for CharacterModel');
    }
  }

  @override
  List<Object?> get props => [
    id,
    name,
    status,
    species,
    type,
    gender,
    origin,
    location,
    image,
    episode,
    url,
    created,
  ];
}

@JsonSerializable()
class OriginModel extends Equatable {
  final String name;
  final String url;

  const OriginModel({required this.name, required this.url});

  factory OriginModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$OriginModelFromJson(json);
    } catch (e, stackTrace) {
      loggerService.error('Error deserializing OriginModel', e, stackTrace);
      throw FormatException('Invalid JSON for OriginModel');
    }
  }

  Map<String, dynamic> toJson() {
    try {
      return _$OriginModelToJson(this);
    } catch (e, stackTrace) {
      loggerService.error('Error serializing OriginModel', e, stackTrace);
      throw Exception('Serialization failed for OriginModel');
    }
  }

  @override
  List<Object?> get props => [name, url];
}

@JsonSerializable()
class LocationModel extends Equatable {
  final String name;
  final String url;

  const LocationModel({required this.name, required this.url});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$LocationModelFromJson(json);
    } catch (e, stackTrace) {
      loggerService.error('Error deserializing LocationModel', e, stackTrace);
      throw FormatException('Invalid JSON for LocationModel');
    }
  }

  Map<String, dynamic> toJson() {
    try {
      return _$LocationModelToJson(this);
    } catch (e, stackTrace) {
      loggerService.error('Error serializing LocationModel', e, stackTrace);
      throw Exception('Serialization failed for LocationModel');
    }
  }

  @override
  List<Object?> get props => [name, url];
}
