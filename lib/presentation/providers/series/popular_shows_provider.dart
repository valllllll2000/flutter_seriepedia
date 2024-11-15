import 'shows_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/serie.dart';

final popularShowsProvider =
    StateNotifierProvider<PopularShowsNotifier, List<Serie>>((ref) {
  final popularList = ref.watch(showsRepositoryProvider).getPopularList;
  return PopularShowsNotifier(loadMoreCallback: popularList);
});

typedef ShowCallback = Future<List<Serie>> Function(int page);

class PopularShowsNotifier extends StateNotifier<List<Serie>> {
  PopularShowsNotifier({required this.loadMoreCallback}) : super([]);
  final ShowCallback loadMoreCallback;
  bool isLastPage = false;
  bool isLoading = false;
  int page = 1;

  Future<void> loadPopularShows() async {
    if (isLastPage || isLoading) return;
    isLoading = true;
    List<Serie> shows = await loadMoreCallback(page);
    isLoading = false;
    if (shows.isEmpty) {
      isLastPage = true;
      return;
    }
    page++;;
    state = [...state, ...shows];
  }
}
