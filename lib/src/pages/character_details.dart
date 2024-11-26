import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:testapp/src/models/character.dart';

/// Character details page with hero animation
class CharacterDetails extends StatelessWidget {
  const CharacterDetails({super.key, required this.character});

  final CharacterModel character;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(character.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // main character image
            Center(
              child: Hero(
                tag: character.id,
                child: CachedNetworkImage(
                  imageUrl: character.image,
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) => const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Name: ${character.name}', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text(
              'Species: ${character.species}',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text('Status: ${character.status}', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Gender: ${character.gender}', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text(
              'Origin: ${character.origin.name}',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Location: ${character.location.name}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
