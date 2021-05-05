part of 'notification_bloc.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoadInProgress extends NotificationState {}

class NotificationLoadSuccess extends NotificationState {
  final List<Notification> notifications;
  final bool hasReachedMax;

  NotificationLoadSuccess({@required this.notifications, this.hasReachedMax});

  NotificationLoadSuccess copyWith({
    List<Notification> notifications,
    bool hasReachedMax,
  }) {
    return NotificationLoadSuccess(
      notifications: notifications ?? this.notifications,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [notifications, hasReachedMax];

  @override
  String toString() =>
      ' NotificationLoadSuccess: { notification total: ${notifications.length} }';
}

class NotificationLoadFailure extends NotificationState {}
