import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testapp/src/constants.dart';
import 'package:testapp/src/models/character.dart';
import 'package:testapp/src/services/http_service.dart';
import 'package:testapp/src/services/services.dart';

/// This file holds all the providers related to characters
/// (ideally, for larger projects this file should be split into multiple files)
final characterProvider =
    StateNotifierProvider<CharacterNotifier, CharacterState>(
      (ref) => CharacterNotifier(ref),
    );

/// Search query state providers
final searchQueryProvider = StateProvider<String>((ref) => '');
final filterStatusProvider = StateProvider<String>((ref) => '');

/// immutable character state class, uses copyWith to update state
class CharacterState {
  final List<CharacterModel> characters;
  final int currentPage;
  final bool isFetching;
  final String errorMessage;
  final int? totalPages;

  CharacterState({
    required this.characters, // list of characters
    required this.currentPage, // current page number
    required this.isFetching, // is fetching data
    this.errorMessage = '', // error message if exists
    this.totalPages, // total pages available
  });

  CharacterState copyWith({
    List<CharacterModel>? characters,
    int? currentPage,
    bool? isFetching,
    String? errorMessage,
    int? totalPages,
  }) {
    return CharacterState(
      characters: characters ?? this.characters,
      currentPage: currentPage ?? this.currentPage,
      isFetching: isFetching ?? this.isFetching,
      errorMessage: errorMessage ?? this.errorMessage,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}

/// Character notifier class to handle fetching characters
class CharacterNotifier extends StateNotifier<CharacterState> {
  final Ref ref;

  CharacterNotifier(this.ref)
    : super(CharacterState(characters: [], currentPage: 1, isFetching: false));

  /// Fetch characters from the API
  Future<void> fetchCharacters() async {
    // Prevent multiple fetch requests
    if (state.isFetching) return;
    // Prevent fetching if all pages are fetched
    if (state.totalPages != null && state.currentPage > state.totalPages!) {
      loggerService.warning('No more pages to fetch');
      return;
    }

    // Read search query and filter status if need filtering
    final searchQuery = ref.read(searchQueryProvider);
    final filterStatus = ref.read(filterStatusProvider);

    // Set fetching state and reset any error message
    state = state.copyWith(isFetching: true, errorMessage: '');

    try {
      final uri = Uri.https(Constants.domain, Constants.characterPath, {
        'page': '${state.currentPage}',
        if (searchQuery.isNotEmpty) 'name': searchQuery,
        if (filterStatus.isNotEmpty) 'status': filterStatus,
      });

      final response = await httpService.call(
        method: HttpMethod.get,
        path: '$uri',
      );

      // Handle success response
      if (response.isSuccess) {
        final data = response.data;

        final results = data?['results'];
        final info = data?['info'];

        final totalPages = info?['pages'];

        // Update total pages only when needed
        if (totalPages != state.totalPages) {
          state = state.copyWith(totalPages: totalPages);
        }

        // Parse the json data to character model
        final newCharacters =
            results?.map((json) => CharacterModel.fromJson(json)).toList();

        // Update the state with new characters and page number
        state = state.copyWith(
          characters: [...state.characters, ...?newCharacters],
          currentPage: state.currentPage + 1,
          errorMessage: '',
        );
      } else {
        // Handle error response
        final error = response.error ?? 'Unknown error occurred';
        loggerService.error('Error fetching characters', error);
        state = state.copyWith(errorMessage: error);
      }
    } catch (e, stackTrace) {
      // Handle general errors/parsing errors
      final errorMessage = 'Failed to fetch characters: $e';
      loggerService.error(errorMessage, e, stackTrace);
      state = state.copyWith(errorMessage: errorMessage);
    } finally {
      state = state.copyWith(isFetching: false);
    }
  }

  /// Reset the state when search or filter changes
  void onSearchOrFilterChanged() {
    state = state.copyWith(characters: [], currentPage: 1, errorMessage: '');
  }
}
