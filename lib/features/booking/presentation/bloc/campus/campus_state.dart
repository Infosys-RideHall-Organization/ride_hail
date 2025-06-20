part of 'campus_bloc.dart';

@immutable
sealed class CampusState extends Equatable {
  const CampusState();

  @override
  List<Object?> get props => [];
}

final class CampusInitial extends CampusState {}

final class CampusLoading extends CampusState {}

final class CampusLoaded extends CampusState {
  final List<Campus> campuses;

  const CampusLoaded({required this.campuses});

  @override
  List<Object?> get props => [campuses];
}

final class CampusFailure extends CampusState {
  final String message;

  const CampusFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
