import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('FCM Token: $fCMToken');
    FirebaseMessaging.onBackgroundMessage(handlerBackgroundMessage);
  }

  Future<void> handlerBackgroundMessage(RemoteMessage message) async {
    print('Title: ${message.notification?.title}');
    print('Body: ${message.notification?.body}');
    print('payload: ${message.data}');
  }
}
