// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CharacterModel _$CharacterModelFromJson(Map<String, dynamic> json) =>
    CharacterModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      status: json['status'] as String,
      species: json['species'] as String,
      type: json['type'] as String,
      gender: json['gender'] as String,
      origin: OriginModel.fromJson(json['origin'] as Map<String, dynamic>),
      location:
          LocationModel.fromJson(json['location'] as Map<String, dynamic>),
      image: json['image'] as String,
      episode:
          (json['episode'] as List<dynamic>).map((e) => e as String).toList(),
      url: json['url'] as String,
      created: json['created'] as String,
    );

Map<String, dynamic> _$CharacterModelToJson(CharacterModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'status': instance.status,
      'species': instance.species,
      'type': instance.type,
      'gender': instance.gender,
      'origin': instance.origin,
      'location': instance.location,
      'image': instance.image,
      'episode': instance.episode,
      'url': instance.url,
      'created': instance.created,
    };

OriginModel _$OriginModelFromJson(Map<String, dynamic> json) => OriginModel(
      name: json['name'] as String,
      url: json['url'] as String,
    );

Map<String, dynamic> _$OriginModelToJson(OriginModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'url': instance.url,
    };

LocationModel _$LocationModelFromJson(Map<String, dynamic> json) =>
    LocationModel(
      name: json['name'] as String,
      url: json['url'] as String,
    );

Map<String, dynamic> _$LocationModelToJson(LocationModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'url': instance.url,
    };
