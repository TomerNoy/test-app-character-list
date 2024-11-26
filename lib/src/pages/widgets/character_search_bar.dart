import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testapp/src/constants.dart';
import 'package:testapp/src/providers/character_provider.dart';

/// Character search bar widget with search and filter options
class CharacterSearchBar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  const CharacterSearchBar({super.key});

  @override
  ConsumerState<CharacterSearchBar> createState() => _SearchBarState();

  @override
  Size get preferredSize => const Size.fromHeight(155);
}

class _SearchBarState extends ConsumerState<CharacterSearchBar> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final searchQuery = ref.read(searchQueryProvider);
    _controller = TextEditingController(text: searchQuery);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filterStatus = ref.watch(filterStatusProvider);

    // Callbacks for search
    void onSearchChanged(String value) {
      // Update search box, clear the list and fetch characters
      ref.read(searchQueryProvider.notifier).state = value;
      ref.read(characterProvider.notifier).onSearchOrFilterChanged();
      ref.read(characterProvider.notifier).fetchCharacters();
    }

    // Callbacks for filter
    void onFilterChanged(String? value) {
      // Update filter status, clear the list and fetch characters
      ref.read(filterStatusProvider.notifier).state = value ?? '';
      ref.read(characterProvider.notifier).onSearchOrFilterChanged();
      ref.read(characterProvider.notifier).fetchCharacters();
    }

    return Container(
      height: widget.preferredSize.height,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Search bar
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: Constants.searchBarLabel,
              border: OutlineInputBorder(),
              // clear search button
              suffixIcon: IconButton(
                icon:
                    _controller.text.isEmpty
                        ? Icon(Icons.refresh)
                        : Icon(Icons.clear),
                onPressed: () {
                  _controller.clear();
                  onSearchChanged('');
                },
              ),
            ),
            onChanged: onSearchChanged,
          ),
          const SizedBox(height: 8),
          // Filter dropdown
          DropdownButtonFormField<String>(
            value: filterStatus.isEmpty ? null : filterStatus,
            items: const [
              DropdownMenuItem(value: '', child: Text('All')),
              DropdownMenuItem(value: 'alive', child: Text('Alive')),
              DropdownMenuItem(value: 'dead', child: Text('Dead')),
              DropdownMenuItem(value: 'unknown', child: Text('Unknown')),
            ],
            onChanged: onFilterChanged,
            decoration: const InputDecoration(
              labelText: Constants.filterBarLabel,
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
