
import 'package:dhopai/Products/products.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/material.dart';

import '../Routing/global_navigator_key.dart';
class LocalNotificationService {

  static final LocalNotificationService _localNotificationService =
  LocalNotificationService._internal();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  LocalNotificationService._internal();

  factory LocalNotificationService() {
    return _localNotificationService;
  }

  // initialization after widget initialized in main function
  Future<void> init() async {
    const AndroidInitializationSettings _initSettingAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    final IOSInitializationSettings _initSettingIOS = IOSInitializationSettings(
        requestSoundPermission: false,
        requestAlertPermission: false,
        requestBadgePermission: false,
        onDidReceiveLocalNotification: onDidReceiveLocalNotification
    );
    const MacOSInitializationSettings _initializationSettingsMacOS =
    MacOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: _initSettingAndroid, iOS: _initSettingIOS ,macOS: _initializationSettingsMacOS
    );

    tz.initializeTimeZones();

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification );
  }
  Future onSelectNotification(String? payload) async {
    try{
      if( payload!=null &&  payload!.isNotEmpty){
        //Navigator.of(context as BuildContext).push(MaterialPageRoute(builder: (context) =>  SignInPage()));
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.of(GlobalVariable.navState.currentContext!)
              .push(MaterialPageRoute(
              builder: (context) => ProductList(0),
              )

          );
        });
      }

    }catch(e){

    }
  }

  Future showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'Dhopai', 'Dhopai',
        'channel for local notification',
        //priority: Priority.high,
        importance: Importance.high
    );
    const IOSNotificationDetails iOSPlatformChannelSpecifics =
    IOSNotificationDetails(threadIdentifier: 'Dhopai');
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0,
        title,
        body,
        platformChannelSpecifics
    );
  }


  Future onDidReceiveLocalNotification(
      int value, String? x, String? y, String? z) async {}
}

