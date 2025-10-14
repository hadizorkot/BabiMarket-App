import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    // ignore: avoid_print
    print('FCM Token: $fCMToken');
    FirebaseMessaging.onBackgroundMessage(handlerBackgroundMessage);
  }

  Future<void> handlerBackgroundMessage(RemoteMessage message) async {
    // ignore: avoid_print
    print('Title: ${message.notification?.title}');
    // ignore: avoid_print
    print('Body: ${message.notification?.body}');
    // ignore: avoid_print
    print('payload: ${message.data}');
  }
}
