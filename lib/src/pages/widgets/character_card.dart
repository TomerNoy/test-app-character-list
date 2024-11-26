import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:testapp/src/models/character.dart';
import 'package:testapp/src/services/services.dart';

/// Character single card widget
class CharacterCard extends StatelessWidget {
  final CharacterModel character;

  const CharacterCard({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        onTap: () {
          Navigator.of(context).pushNamed('/character', arguments: character);
        },
        leading: Hero(
          tag: character.id,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: character.image,
              width: 60,
              height: 60,
              placeholder: (context, url) {
                return Center(child: CircularProgressIndicator());
              },
              errorWidget: (context, url, error) {
                loggerService.error('Error loading image', error);
                return Icon(Icons.error);
              },
            ),
          ),
        ),
        title: Text(
          character.name,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: Colors.blueGrey),
        ),
        subtitle: Text('${character.species} - ${character.status}'),
      ),
    );
  }
}
