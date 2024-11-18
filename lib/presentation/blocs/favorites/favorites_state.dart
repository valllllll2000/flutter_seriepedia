part of 'favorites_bloc.dart';

class FavoritesState extends Equatable {
  final List<Serie> favorites;
  final bool isLoading;
  final bool isLastPage;

  const FavoritesState({this.favorites = const [], this.isLoading = false, this.isLastPage = false, });

  @override
  List<Object> get props => [favorites, isLoading];
}
