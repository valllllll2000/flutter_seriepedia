import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/serie.dart';

part 'favorites_event.dart';

part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc() : super(const FavoritesState()) {
    print("FavoritesBloc created");
    on<AddFavorite>((event, emit) {
      _addFavorite(event, emit);
    });

    on<RemoveFavorite>((event, emit) {
      _removeFavorite(event, emit);
    });

    on<UpdateFavorite>((event, emit) {
      if (isFavorite(event.serie)) {
        _removeFavorite(event, emit);
      } else {
        _addFavorite(event, emit);
      }
    });
  }

  void _removeFavorite(FavoritesEvent event, Emitter<FavoritesState> emit) {
    final Set<Serie> favorites = Set.from(state.favorites);
    favorites.removeWhere((e) => e.id == event.serie.id);
    emit(state.copyWith(favorites: favorites));
  }

  void _addFavorite(FavoritesEvent event, Emitter<FavoritesState> emit) {
    emit(state.copyWith(favorites: {...state.favorites, event.serie}));
  }

  bool isFavorite(Serie serie) {
    return state.favorites.any((e) => serie.id == e.id);
  }
}
