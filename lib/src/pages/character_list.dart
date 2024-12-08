import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testapp/src/pages/widgets/character_card.dart';
import 'package:testapp/src/pages/widgets/character_search_bar.dart';
import 'package:testapp/src/pages/widgets/error_widget.dart';
import 'package:testapp/src/providers/character_provider.dart';

/// Character list page with character cards
class CharacterList extends ConsumerStatefulWidget {
  const CharacterList({super.key});

  @override
  CharacterListState createState() => CharacterListState();
}

class CharacterListState extends ConsumerState<CharacterList> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    Future.microtask(() {
      ref.read(characterProvider.notifier).fetchCharacters();
    });
  }

  void _onScroll() {
    final position = _scrollController.position;
    if (position.extentAfter < 300 && !ref.read(characterProvider).isFetching) {
      ref.read(characterProvider.notifier).fetchCharacters();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(characterProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('characters'),
        bottom: CharacterSearchBar(),
        centerTitle: true,
      ),
      body:
          state.characters.isEmpty && state.isFetching
              // Show loading indicator
              ? Center(child: CircularProgressIndicator())
              : state.errorMessage.isNotEmpty
              // Show error message
              ? ErrorDisplay(
                errorMessage: state.errorMessage,
                onRetry: () {
                  ref.read(characterProvider.notifier).fetchCharacters();
                },
              )
              // Show character cards
              : ListView.builder(
                controller: _scrollController,
                itemCount: state.characters.length + (state.isFetching ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == state.characters.length) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final character = state.characters[index];
                  return CharacterCard(character: character);
                },
              ),
    );
  }
}
