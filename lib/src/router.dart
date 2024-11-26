import 'package:flutter/material.dart';
import 'package:testapp/src/models/character.dart';
import 'package:testapp/src/pages/character_details.dart';
import 'package:testapp/src/pages/character_list.dart';

/// App router class
class AppRouter {
  static const String home = '/';
  static const String characterDetail = '/character';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => CharacterList());

      case characterDetail:
        final character = settings.arguments as CharacterModel;
        return MaterialPageRoute(
          builder: (_) => CharacterDetails(character: character),
        );

      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                body: Center(
                  child: Text('No route defined for ${settings.name}'),
                ),
              ),
        );
    }
  }
}
