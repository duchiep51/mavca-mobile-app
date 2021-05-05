import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:capstone_mobile/src/data/models/notification/notification.dart';
import 'package:capstone_mobile/src/data/repositories/authentication/authentication_repository.dart';
import 'package:capstone_mobile/src/data/repositories/notification/notification_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository notificationRepository;
  final AuthenticationRepository _authenticationRepository;
  StreamSubscription<AuthenticationStatus> _authenticationStatusSubscription;

  @override
  Future<void> close() {
    _authenticationStatusSubscription?.cancel();
    _authenticationRepository.dispose();
    return super.close();
  }

  NotificationBloc({
    @required this.notificationRepository,
    @required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(NotificationInitial()) {
    _authenticationStatusSubscription = _authenticationRepository.status.listen(
      (status) => add(NotificationAuthenticationStatusChanged(status: status)),
    );
  }

  @override
  Stream<NotificationState> mapEventToState(
    NotificationEvent event,
  ) async* {
    final currentState = state;
    if (event is NotificationRequested) {
      // yield (NotificationLoadInProgress());

      try {
        if (currentState is NotificationInitial) {
          final notifications = await notificationRepository.fetchNotifications(
            sort: 'desc createdAt',
            token: _authenticationRepository.token,
            page: 0,
          );

          yield NotificationLoadSuccess(
            notifications: notifications,
            hasReachedMax: notifications.length < 20 ? true : false,
          );
          return;
        }

        if (currentState is NotificationLoadFailure) {
          final notifications = await notificationRepository.fetchNotifications(
            sort: 'desc createdAt',
            token: _authenticationRepository.token,
            page: 0,
          );

          yield NotificationLoadSuccess(
            notifications: notifications,
            hasReachedMax: notifications.length < 20 ? true : false,
          );
          return;
        }

        if (currentState is NotificationLoadSuccess &&
            event.isRefresh == true) {
          final notifications = await notificationRepository.fetchNotifications(
            sort: 'desc createdAt',
            token: _authenticationRepository.token,
            limit: currentState.notifications.length,
          );

          yield currentState.copyWith(
            notifications: notifications,
          );
          return;
        }

        if (currentState is NotificationLoadSuccess &&
            !_hasReachedMax(currentState)) {
          final notifications = await notificationRepository.fetchNotifications(
            sort: 'desc createdAt',
            token: _authenticationRepository.token,
          );

          yield notifications.isEmpty
              ? currentState.copyWith(
                  hasReachedMax: true,
                )
              : currentState.copyWith(
                  notifications: notifications + currentState.notifications,
                  hasReachedMax: false,
                );
          return;
        }
      } catch (e) {
        print(e.toString());
        yield NotificationLoadFailure();
      }
    } else if (event is NotificationAuthenticationStatusChanged) {
      if (event.status == AuthenticationStatus.unauthenticated) {
        yield (NotificationInitial());
      } else if (event.status == AuthenticationStatus.authenticated) {
        add(NotificationRequested());
      }
    } else if (event is NotificationIsRead) {
      yield* _mapNotificationIsReadToState(event);
    }
  }

  Stream<NotificationState> _mapNotificationIsReadToState(
      NotificationIsRead event) async* {
    final currentState = state;
    if (currentState is NotificationLoadSuccess) {
      notificationRepository.readNotification(
        token: _authenticationRepository.token,
        id: event.id,
      );
      List<Notification> result = List<Notification>.from((currentState)
          .notifications
          .map((notification) => notification.id != event.id
              ? notification
              : notification.copyWith(isRead: true)));

      yield NotificationLoadSuccess(notifications: result);
    }
  }

  bool _hasReachedMax(NotificationLoadSuccess state) =>
      state is NotificationLoadSuccess && state.hasReachedMax;
}
