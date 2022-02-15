import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kasassy/data/models/user.dart';
import 'package:kasassy/data/repositories/database_repository.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit({required DatabaseRepository userDataRepository})
      : _userDataRepository = userDataRepository,
        super(
          SearchInitial(),
        );

  final DatabaseRepository _userDataRepository;

  Future<void> searchStart(String searchTerm) async {
    emit(
      SearchLoading(),
    );
    final searchUserResults =
        await _userDataRepository.handleSearch(searchTerm);
    if (searchUserResults.isEmpty) {
      emit(
        SearchEmpty(),
      );
    } else {
      emit(
        SearchLoaded(searchUserResults),
      );
    }
  }
}
