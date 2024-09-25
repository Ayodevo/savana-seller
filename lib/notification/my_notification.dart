import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sixvalley_vendor_app/notification/models/notification_body.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';
import 'package:sixvalley_vendor_app/features/chat/screens/inbox_screen.dart';
import 'package:sixvalley_vendor_app/features/notification/screens/notification_screen.dart';
import 'package:sixvalley_vendor_app/features/order_details/screens/order_details_screen.dart';

import '../main.dart';

class MyNotification {

  static Future<void> initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize = const AndroidInitializationSettings('notification_icon');
    var iOSInitialize = const DarwinInitializationSettings();
    var initializationsSettings = InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    flutterLocalNotificationsPlugin.initialize(initializationsSettings, onDidReceiveNotificationResponse: (NotificationResponse data) async {

      print('---------on click clicked');
      print('---------${data.payload}');
      print('---------${data.payload}');
      try{
        NotificationBody payload;
        if(data.payload != null && data.payload!.isNotEmpty) {
          payload = NotificationBody.fromJson(jsonDecode(data.payload!));
          if(payload.type == 'chatting'){
            Get.navigator!.push(MaterialPageRoute(builder: (context) => const InboxScreen( )));
          }else if(payload.type == 'Theme'){
            Get.navigator!.push(MaterialPageRoute(builder: (context) => const NotificationScreen( )));
          } else if(payload.orderId != null){
            Get.navigator!.push(MaterialPageRoute(builder: (context) => OrderDetailsScreen(orderId: payload.orderId, fromNotification: true)));
          }
        }
      }catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
      return;
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print("onMessage: ${message.notification!.title}/${message.notification!.body}/${message.notification!.titleLocKey}");
      }
      if(message.notification!.title!.contains('chatting')){
        //Get.navigator!.push(MaterialPageRoute(builder: (context) => const InboxScreen( )));
      }else if(message.notification!.title!.contains('Theme')){
        Get.navigator!.push(MaterialPageRoute(builder: (context) => const NotificationScreen( )));
      }
      showNotification(message, flutterLocalNotificationsPlugin, false);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print("onOpenApp: ${message.notification!.title}/${message.notification!.body}/${message.notification!.titleLocKey}");
      }
      if(message.notification!.title!.contains('chatting')){
        Get.navigator!.push(MaterialPageRoute(builder: (context) => const InboxScreen( )));

      }else if(message.notification!.title!.contains('Theme')){
        Get.navigator!.push(MaterialPageRoute(builder: (context) => const NotificationScreen( )));
      }
      try{
        if(message.notification!.titleLocKey != null && message.notification!.titleLocKey!.isNotEmpty) {
          Get.navigator!.push(
              MaterialPageRoute(builder: (context) => OrderDetailsScreen(orderId: int.parse(message.notification!.titleLocKey!), fromNotification: true,)));
        }
      }catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    });
  }

  static Future<void> showNotification(RemoteMessage message, FlutterLocalNotificationsPlugin fln, bool data) async {
    String? title;
    String? body;
    String? orderID;
    String? image;
    title = message.data['title'];
    body = message.data['body'];
    orderID = message.data['order_id'];
    image = (message.data['image'] != null && message.data['image'].isNotEmpty)
        ? message.data['image'].startsWith('http') ? message.data['image']
        : '${AppConstants.baseUrl}/storage/app/public/notification/${message.data['image']}' : null;


    if(image != null && image.isNotEmpty) {
      try{
        await showBigPictureNotificationHiddenLargeIcon(title, body, message.data, image, fln);
      }catch(e) {
        await showBigTextNotification(title, body!, message.data, fln);
      }
    }else {
      await showBigTextNotification(title, body!, message.data, fln);
    }
  }


  static Future<void> showBigTextNotification(String? title, String body, Map<String, dynamic> data, FlutterLocalNotificationsPlugin fln) async {
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      body, htmlFormatBigText: true,
      contentTitle: title, htmlFormatContentTitle: true,
    );
    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id', 'your channel name', importance: Importance.max,
      styleInformation: bigTextStyleInformation, priority: Priority.max, playSound: true,
      sound: const RawResourceAndroidNotificationSound('notification'),
    );
    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, title, body, platformChannelSpecifics, payload: jsonEncode(data));
  }

  static Future<void> showBigPictureNotificationHiddenLargeIcon(String? title, String? body, Map<String, dynamic> data, String image, FlutterLocalNotificationsPlugin fln) async {
    final String largeIconPath = await _downloadAndSaveFile(image, 'largeIcon');
    final String bigPicturePath = await _downloadAndSaveFile(image, 'bigPicture');
    final BigPictureStyleInformation bigPictureStyleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicturePath), hideExpandedLargeIcon: true,
      contentTitle: title, htmlFormatContentTitle: true,
      summaryText: body, htmlFormatSummaryText: true,
    );
    final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id', 'your channel name',
      largeIcon: FilePathAndroidBitmap(largeIconPath), priority: Priority.max, playSound: true,
      styleInformation: bigPictureStyleInformation, importance: Importance.max,
      sound: const RawResourceAndroidNotificationSound('notification'),
    );
    final NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, title, body, platformChannelSpecifics, payload: jsonEncode(data));
  }

  static Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final Response response = await Dio().get(url, options: Options(responseType: ResponseType.bytes));
    final File file = File(filePath);
    await file.writeAsBytes(response.data);
    return filePath;
  }

}

Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print("onBackground: ${message.notification!.title}/${message.notification!.body}/${message.notification!.titleLocKey}");
  }
}