import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationPlugin {
  FlutterLocalNotificationsPlugin? flutterNotification;

  NotificationPlugin() {
    init();
  }

  void init() {
    flutterNotification = new FlutterLocalNotificationsPlugin();
    var androidInitialize = AndroidInitializationSettings('notification');
    var IosInitialize = IOSInitializationSettings();

    var initializationSetting = new InitializationSettings(
        android: androidInitialize, iOS: IosInitialize);

    flutterNotification?.initialize(initializationSetting);
    tz.initializeTimeZones();
  }

  Future ShowTaskNotification(
      String title, DateTime date, String desc, int id) async {
    //  DateTime date2 = DateTime.now().add(Duration(seconds: 5));
    final String currentTimeZone =
        await FlutterNativeTimezone.getLocalTimezone();
    final location = tz.getLocation(currentTimeZone);
    var scheduledTime = tz.TZDateTime.from(date, location);

    var androidDetails = new AndroidNotificationDetails(
      "Channel ID 2",
      title,
      desc,
      importance: Importance.max,
    );
    var iOSDetails = new IOSNotificationDetails();
    var generalNotificationDetails = new NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await flutterNotification!.zonedSchedule(
      id,
      title,
      desc,
      scheduledTime,
      generalNotificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      payload: "task1",
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  Future cancelTask(int id) async {
    await flutterNotification!.cancel(150);
  }
}
