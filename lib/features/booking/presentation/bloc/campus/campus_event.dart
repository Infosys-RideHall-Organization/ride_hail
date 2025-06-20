part of 'campus_bloc.dart';

@immutable
sealed class CampusEvent extends Equatable {
  const CampusEvent();

  @override
  List<Object?> get props => [];
}

final class LoadCampuses extends CampusEvent {}
