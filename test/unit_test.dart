import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:testapp/src/models/result.dart';
import 'package:testapp/src/providers/character_provider.dart';
import 'package:testapp/src/services/http_service.dart';
import 'package:testapp/src/services/logger_service.dart';

class MockHttpService extends Mock implements HttpService {}

class MockLoggerService extends Mock implements LoggerService {}

void main() {
  group('CharacterProvider Tests', () {
    late MockHttpService mockHttpService;
    late MockLoggerService mockLoggerService;
    late ProviderContainer container;

    setUp(() async {
      await GetIt.instance.reset();
      mockHttpService = MockHttpService();
      mockLoggerService = MockLoggerService();

      GetIt.instance.registerSingleton<LoggerService>(mockLoggerService);
      GetIt.instance.registerSingleton<HttpService>(mockHttpService);

      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
      GetIt.instance.reset();
    });

    test('Initial state is correct', () {
      final state = container.read(characterProvider);

      // Verify the initial state
      expect(state.characters, isEmpty);
      expect(state.isFetching, isFalse);
      expect(state.currentPage, 1);
      expect(state.errorMessage, isEmpty);
    });

    test('Fetch characters updates state correctly', () async {
      final notifier = container.read(characterProvider.notifier);
      final mockData = generateCharacterJson(5);

      when(() {
        return mockHttpService.call(
          method: HttpMethod.get,
          path: any(named: 'path'),
        );
      }).thenAnswer((_) async {
        return Result(data: mockData);
      });

      await notifier.fetchCharacters();

      final state = container.read(characterProvider);

      // Verify the state after fetching
      expect(state.isFetching, isFalse);
      expect(state.characters, isNotEmpty);
      expect(state.errorMessage, isEmpty);
    });

    test('Fetch characters error from http service', () async {
      final notifier = container.read(characterProvider.notifier);

      when(() {
        return mockHttpService.call(
          method: HttpMethod.get,
          path: any(named: 'path'),
        );
      }).thenAnswer((_) async {
        return Result(data: {'error': 'some failed error'});
      });

      await notifier.fetchCharacters();

      final state = container.read(characterProvider);

      // Verify the state after fetching
      expect(state.isFetching, isFalse);
      expect(state.errorMessage, isNotEmpty);
    });
  });
}

Map<String, dynamic> generateCharacterJson(int count) {
  return {
    'results': List.generate(
      count,
      (i) => {
        'id': i,
        'name': 'Character $i',
        'status': 'Alive',
        'species': 'Species $i',
        'type': '',
        'gender': 'Gender $i',
        'origin': {'name': 'Origin $i', 'url': 'url_$i'},
        'location': {'name': 'Location $i', 'url': 'url_$i'},
        'image': 'image_$i',
        'episode': [],
        'url': 'url_$i',
        'created': '2023-01-01T00:00:00.000Z',
      },
    ),
    'info': {
      'count': count,
      'pages': (count / 10).ceil(),
      'next': null,
      'prev': null,
    },
  };
}
