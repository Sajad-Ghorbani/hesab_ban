import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/app/features/feature_check/presentation/controller/check_controller.dart';
import 'package:hesab_ban/app/features/feature_setting/presentation/screens/check_details.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

AndroidNotificationDetails androidNotificationDetails =
    const AndroidNotificationDetails(
  'basic_channel',
  'Basic Notification',
  channelDescription: 'Notification channel for basic tests',
  importance: Importance.max,
  priority: Priority.high,
  ticker: 'ticker',
);
NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @pragma('vm:entry-point')
  static void notificationTapBackground(
      NotificationResponse notificationResponse) {
    final String? payload = notificationResponse.payload;
    if (payload != null) {
      var response = Get.find<CheckController>().getAllChecks();
      if (response != null) {
        var check = response.firstWhere((element) {
          return element.id == int.parse(payload);
        });
        Get.to(
          () => CheckDetails(check),
        );
      }
    }
  }

  initializationNotification() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        final String? payload = notificationResponse.payload;
        if (notificationResponse.payload != null) {
          debugPrint('notification payload: $payload');
        }
        notificationTapBackground(notificationResponse);
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  receiveNotification() async {
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      String? payload =
          notificationAppLaunchDetails!.notificationResponse?.payload;
      if (kDebugMode) {
        print('selectedNotificationPayload -------------------->  ');
        print(payload);
      }
      var response = Get.find<CheckController>().getAllChecks();
      if (response != null) {
        var check = response.firstWhere((element) {
          return element.id == int.parse(payload!);
        });
        Future.delayed(const Duration(seconds: 5), () {
          Get.to(
            () => CheckDetails(check),
          );
        });
      }
    }
  }

  Future<bool> notificationStatus() async =>
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.areNotificationsEnabled() ??
      false;

  Future<bool?> requestPermission() async =>
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
  }) async {
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  // updateNotificationTime(DateTime dateTime) async {
  //   List<ActiveNotification> notificationList =
  //       await flutterLocalNotificationsPlugin.getActiveNotifications();
  //   await cancelAllNotifications();
  //   for (var item in notificationList) {
  //     await scheduleNotification(
  //       id: item.id!,
  //       title: item.title!,
  //       body: item.body!,
  //       payload: item.payload!,
  //       dateTime: dateTime,
  //     );
  //   }
  // }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
    required DateTime dateTime,
  }) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.now(tz.local).add(dateTime.difference(DateTime.now())),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }
}
