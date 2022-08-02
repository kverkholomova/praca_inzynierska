// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class NotificationApi {
//   static final _notifications = FlutterLocalNotificationsPlugin();

//   static Future _notificationDetails() async{
//     return const NotificationDetails(
//       android:  AndroidNotificationDetails(
//         'channel id',
//         'channel name',
//      importance: Importance.max,
//       )
//
//     );
//   }
//
//   static Future showNotification({
//   int id = 0,
//     String? title,
//     String? body
// }) async{
//     _notifications.show(id, title, body, notificationDetails())
//   }
// }
