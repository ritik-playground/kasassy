part of 'search_cubit.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  const SearchLoaded(this.searchUserResults);

  final List<UserData> searchUserResults;

  @override
  List<Object> get props => [searchUserResults];
}

class SearchEmpty extends SearchState {}
