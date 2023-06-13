import 'package:dropsride/src/utils/alert.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

Future<void> sendEmail(String recipientEmail, String subject, String message,
    bool? failSilently) async {
  final smtpServer = SmtpServer(
    "host62.registrar-servers.com",
    username: 'noreply@dropsride.com',
    password: 'Abdullahi223@',
    port: 465, //587
    ssl: true,
  );

  final mailMessage = Message()
    ..from = const Address('noreply@dropsride.com')
    ..recipients.add(recipientEmail)
    ..subject = subject
    ..text = message;

  try {
    final sendReport = await send(mailMessage, smtpServer);
    if (failSilently != null || failSilently != false) {
      showSuccessMessage(
          "MAIL SENT", sendReport.toString(), Icons.mail_outline_rounded);
    }
  } catch (e) {
    if (failSilently != null || failSilently != false) {
      showErrorMessage(
          'SMTP ERROR',
          "There were issues sending the mail to: $recipientEmail\n\nThis was the error received: ${e.toString()}",
          Icons.mail_outline_rounded);
      return;
    }
  }
}
