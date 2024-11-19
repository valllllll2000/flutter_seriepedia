part of 'favorites_bloc.dart';

abstract class FavoritesEvent {
  final Serie serie;

  FavoritesEvent({required this.serie});
}

class AddFavorite extends FavoritesEvent {
  AddFavorite({required super.serie});
}

class RemoveFavorite extends FavoritesEvent {
  RemoveFavorite({required super.serie});

}

class UpdateFavorite extends FavoritesEvent {
  UpdateFavorite({required super.serie});
}
