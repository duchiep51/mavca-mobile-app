import 'dart:async';
import 'package:capstone_mobile/src/data/models/notification/notification.dart';
import 'package:capstone_mobile/src/data/repositories/notification/notification_api.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class NotificationRepository {
  NotificationApi _notificationApi = NotificationApi(httpClient: http.Client());

  Future<List<Notification>> fetchNotifications({
    @required String token,
    String sort,
    double page,
    int limit,
    bool isRead,
  }) async {
    return await _notificationApi.getNotifications(
      token: token,
      page: page,
      limit: limit,
      sort: sort,
      isRead: isRead,
    );
  }

  Future<void> readNotification({
    @required String token,
    @required int id,
  }) async {
    return await _notificationApi.readNotificatin(token: token, id: id);
  }
}
