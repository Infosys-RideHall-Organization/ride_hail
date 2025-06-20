part of 'activity_bloc.dart';

abstract class ActivityState extends Equatable {
  final List<Booking> pastBookings;
  final List<Booking> upcomingBookings;

  const ActivityState({
    this.pastBookings = const [],
    this.upcomingBookings = const [],
  });

  @override
  List<Object> get props => [pastBookings, upcomingBookings];
}

class ActivityInitial extends ActivityState {}

class ActivityLoading extends ActivityState {}

class ActivityLoaded extends ActivityState {
  const ActivityLoaded({super.pastBookings, super.upcomingBookings});
}

class ActivityError extends ActivityState {
  final String message;

  const ActivityError({required this.message});

  @override
  List<Object> get props => [message];
}
