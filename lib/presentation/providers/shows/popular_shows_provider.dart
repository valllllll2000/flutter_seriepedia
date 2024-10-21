import 'package:cinemapedia/presentation/providers/shows/shows_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/show.dart';

final popularShowsProvider =
    StateNotifierProvider<PopularShowsNotifier, List<Show>>((ref) {
  final popularList = ref.watch(showsRepositoryProvider).getPopularList;
  return PopularShowsNotifier(callback: popularList);
});

typedef ShowCallback = Future<List<Show>> Function();

class PopularShowsNotifier extends StateNotifier<List<Show>> {
  PopularShowsNotifier({required this.callback}) : super([]);
  final ShowCallback callback;

  Future<void> loadPopularShows() async {
    List<Show> shows = await callback();
    state = [...state, ...shows];
  }
}
