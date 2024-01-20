import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_storage/get_storage.dart';

final _box = GetStorage();

Future<bool> requestPermissionAndSubscribe() async {
  var notificationSettings = await FirebaseMessaging.instance.getNotificationSettings();
  if (notificationSettings.authorizationStatus == AuthorizationStatus.notDetermined) {
    final notificationSettings = await FirebaseMessaging.instance.requestPermission(provisional: true);
    if (notificationSettings.authorizationStatus == AuthorizationStatus.authorized) {
      subscribeTo("emergency");
      subscribeTo("general");

      await FirebaseAnalytics.instance.logEvent(name: "FirebaseMessaging: authorized");

      FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
        FirebaseAnalytics.instance.logEvent(name: "FirebaseMessaging: onTokenRefresh");
      }).onError((error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack);
      });

      return true;
    }
  }
  return false;
}

void subscribeTo(String topic) async {
  await FirebaseMessaging.instance.subscribeToTopic(topic);
  await _box.write("topic-$topic", true);
}

void unsubscribeFrom(String topic) async {
  await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
  await _box.write("topic-$topic", false);
}
