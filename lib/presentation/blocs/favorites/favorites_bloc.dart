import 'package:cinemapedia/domain/datasources/favorites_datasource.dart';
import 'package:cinemapedia/infrastructure/datasources/sqlite_favorites_datasource.dart';
import 'package:cinemapedia/infrastructure/repositories/favorites_repository_impl.dart';
import 'package:cinemapedia/infrastructure/services/database_service_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/serie.dart';
import '../../../domain/repositories/favorites_repository.dart';

part 'favorites_event.dart';

part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  //TODO: inject this
  final FavoritesRepository favoritesRepository =
      FavoritesRepositoryImpl(SqliteFavoritesDatasource(DatabaseServiceImpl()));

  FavoritesBloc() : super(const FavoritesState()) {
    on<LoadFavorites>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final series = await favoritesRepository.loadFavoriteSeries();
      emit(state.copyWith(isLoading: false, favorites: series));
    });

    on<UpdateFavorite>((event, emit) async {
      await favoritesRepository.toggleFavorite(event.serie);
      if (isFavorite(event.serie)) {
        _removeFavorite(event, emit);
      } else {
        _addFavorite(event, emit);
      }
    });

    add(LoadFavorites());
  }

  void _removeFavorite(UpdateFavorite event, Emitter<FavoritesState> emit) {
    final Set<Serie> favorites = Set.from(state.favorites);
    favorites.removeWhere((e) => e.id == event.serie.id);
    emit(state.copyWith(favorites: favorites));
  }

  void _addFavorite(UpdateFavorite event, Emitter<FavoritesState> emit) {
    emit(state.copyWith(favorites: {...state.favorites, event.serie}));
  }

  bool isFavorite(Serie serie) {
    return state.favorites.any((e) => serie.id == e.id);
  }
}
