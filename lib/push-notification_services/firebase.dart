import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Repository/log_debugger.dart';
import 'local_notification.dart';

class FirebaseApi{

  final _firebaseMessaging = FirebaseMessaging.instance;
  Future<void> initNotifications() async {
   await  _firebaseMessaging.requestPermission();
   SharedPreferences prefs = await SharedPreferences.getInstance();
   final fCMToken= await _firebaseMessaging.getToken();
   print('Token: $fCMToken');
   prefs.setString('com.dhopai.user.deviceToken', fCMToken!);
  }
  Future<void> enableNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url='https://api.dhopai.com/api-customer/store_token';
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${prefs.getString('token')}',
      },
      body: jsonEncode(<String, dynamic>{
        'device_token':prefs.getString('com.dhopai.user.deviceToken'),
        'id':prefs.getInt('customer_id'),
      }),
    );
    try {

      if (response.statusCode == 200) {
        print('api calling is successful......');
       // final Map userInfo = json.decode(response.body);
       // print('User data : $userInfo');

      }
      else {
        throw Exception('Request Error: ${response.statusCode}');
      }
    }
    on Exception {
      rethrow;
    }

  }
  Future<void> initializePushNotification() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
     LogDebugger.instance.i(message.notification?.title ?? '');
      _handleForegroundNotification(
        message.notification?.title ?? 'Unknown',
        message.notification?.body ?? 'Unknown',
      );
    });


    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      LogDebugger.instance.i(message.notification?.title ?? '');
      _handleBackgroundNotification(
        message.notification?.title ?? 'Unknown',
        message.notification?.body ?? 'Unknown',
      );
    });
  }
  void _handleForegroundNotification(String title, String body) async {
    await LocalNotificationService().showNotification(title, body);
  }
  void _handleBackgroundNotification(String title, String body) async {
    await LocalNotificationService().showNotification(title, body);
  }


}