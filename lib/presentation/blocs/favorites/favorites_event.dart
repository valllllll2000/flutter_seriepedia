part of 'favorites_bloc.dart';

abstract class FavoritesEvent {}

class UpdateFavorite extends FavoritesEvent {
  final Serie serie;

  UpdateFavorite({required this.serie});
}

class LoadFavorites extends FavoritesEvent {}
