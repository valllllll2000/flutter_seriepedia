part of 'favorites_bloc.dart';

class FavoritesState extends Equatable {
  final Set<Serie> favorites;
  final bool isLoading;

  const FavoritesState({this.favorites = const {}, this.isLoading = false});

  FavoritesState copyWith({
    Set<Serie>? favorites,
    bool? isLoading,
  }) =>
      FavoritesState(
          favorites: favorites ?? this.favorites,
          isLoading: isLoading ?? this.isLoading);

  @override
  List<Object> get props => [favorites, isLoading];
}
