import 'package:awesome_notifications/awesome_notifications.dart';

void sendNotification(int id, String message, String title, String? photoUrl,
    String? summary, NotificationCategory? category) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: id,
      channelKey: 'basic_channel',
      title: title,
      body: message,
      bigPicture: photoUrl,
      summary: summary,
      wakeUpScreen: true,
      displayOnBackground: true,
      category: category,
    ),
  );
}

Future<void> cancelNotification(int id) async {
  await AwesomeNotifications().cancel(id);
}
