part of 'search_series_bloc.dart';

abstract class SearchSeriesEvent {}

class MakeQuery extends SearchSeriesEvent {
  final String query;

  MakeQuery(this.query);
}

class LoadNextPage extends SearchSeriesEvent {}
