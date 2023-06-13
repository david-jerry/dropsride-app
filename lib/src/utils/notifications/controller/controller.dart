import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationController {
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
    print('Notification Created: ${receivedNotification.id}');
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
    print('Notification displayed: ${receivedNotification.id}');
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here
    print('Notification dismissed: ${receivedAction.id}');
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here

    // // Navigate into pages, avoiding to open the notification details page over another details page already opened
    // MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil('/notification-page',
    //         (route) => (route.settings.name != '/notification-page') || route.isFirst,
    //     arguments: receivedAction);

    // Navigate to pages or perform actions based on the received action
    if (receivedAction != null) {
      print('Action received: ${receivedAction.groupKey}');

      if (receivedAction.buttonKeyPressed == 'view') {
        // Example: Navigate to the notification page
        print('Navigating to notification page');
        // Navigator.of(context).pushNamed('/notification-page');
      } else if (receivedAction.buttonKeyPressed == 'action1') {
        // Perform action 1
        print('Performing action 1');
        // performAction1();
      } else if (receivedAction.buttonKeyPressed == 'action2') {
        // Perform action 2
        print('Performing action 2');
        // performAction2();
      }
    }
  }
}
