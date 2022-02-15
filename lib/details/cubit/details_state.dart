part of 'details_cubit.dart';

abstract class DetailsState extends Equatable {
  const DetailsState();

  @override
  List<Object> get props => [];
}

class DetailsInitial extends DetailsState {}

class DetailsInProgress extends DetailsState {}

class DetailsSuccess extends DetailsState {}

class DetailsFailure extends DetailsState {}
