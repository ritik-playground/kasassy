part of 'details_cubit.dart';

enum DetailsStatus { initial, success, failure, loading }

class DetailsState extends Equatable {
  const DetailsState({
    this.status = DetailsStatus.initial,
    this.error,
  });

  final DetailsStatus status;
  final String? error;

  @override
  List<Object?> get props => [error, status];
}
