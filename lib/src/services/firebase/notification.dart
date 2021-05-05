import 'package:capstone_mobile/src/services/firebase/message.dart'
    as firebaseMessage;
import 'package:capstone_mobile/src/ui/screens/login_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseNotification {
  static Future<void> myBackgroundMessageHandler(Map<String, dynamic> message) {
    print('on background $message');
    return null;
  }

  static FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  static List<firebaseMessage.Message> messages = [];
  static List<String> topics = List();
  static FlutterLocalNotificationsPlugin notificationPlugin;

  static Future notificationSelected(String payload) async {}

  static void unsubscribeFromTopic() {
    if (topics.isNotEmpty) {
      print("unsubscribeFromTopic");
      print(topics.toString());
      // topics.forEach((topic) {
      //   firebaseMessaging.unsubscribeFromTopic(topic);
      // });
      topics.clear();
      // topics = List();
    }
  }

  static void initilizeNotification() {
    var androidInitilization = AndroidInitializationSettings('logo');
    var iOSInitilization = IOSInitializationSettings();
    var initilizationSettings =
        InitializationSettings(androidInitilization, iOSInitilization);
    notificationPlugin = FlutterLocalNotificationsPlugin();
    notificationPlugin.initialize(initilizationSettings,
        onSelectNotification: notificationSelected);
  }

  static Future configFirebaseMessaging(NavigatorState navigator) async {
    initilizeNotification();

    if (topics.isNotEmpty) {
      print("subscribeToTopic");
      print(topics.length);

      topics.forEach((topic) {
        firebaseMessaging.subscribeToTopic(topic);
      });

      firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print('onMessage: $message');

          const AndroidNotificationDetails androidDetails =
              AndroidNotificationDetails(
            'high_importance_channel', // id
            'High Importance Notifications', // title
            'This channel is used for important notifications.', // description
            importance: Importance.Max,
          );
          const IOSNotificationDetails iOSDetail = IOSNotificationDetails();
          var generalNotificaitionDetails =
              NotificationDetails(androidDetails, iOSDetail);

          await notificationPlugin.show(
            0,
            message['notification']['title'],
            message['notification']['body'],
            generalNotificaitionDetails,
          );
        },
        onBackgroundMessage: myBackgroundMessageHandler,
        onLaunch: (Map<String, dynamic> message) async {
          print('onLaunch: $message');
          navigator.push(LoginScreen.route());
        },
        onResume: (Map<String, dynamic> message) async {
          print('onResume: $message');
        },
      );
    }
  }

  @override
  List<Object> get props => [
        firebaseMessaging,
        messages,
      ];
}
