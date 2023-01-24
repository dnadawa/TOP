import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:sendgrid_mailer/sendgrid_mailer.dart';
import 'package:top/constants.dart';

class EmailService {
  sendEmail(
      {List<String>? to,
      required String subject,
      Map<String, dynamic>? templateData,
      required String templateID,
      String from = 'topnurseagency@gmail.com'}) async {
    try {
      final mailer = Mailer(dotenv.env['SENDGRID']!);
      List<Address> toAddresses =
          to == null ? [Address(adminEmail)] : to.map((e) => Address(e)).toList();
      final fromAddress = Address(from, "TOP Nurse Agency");
      final personalization =
          Personalization(toAddresses.length > 1 ? [Address("topnurseagency@gmail.com")] : toAddresses, dynamicTemplateData: templateData, subject: subject, bcc: toAddresses.length > 1 ? toAddresses : null);

      final email = Email([personalization], fromAddress, subject, templateId: templateID);
      await mailer.send(email).then((result) => print(result));
      return true;
    } catch (e) {
      print("mail error : $e");
      return false;
    }
  }

  sendNotification(
      {required List<String> playerIDs, String? content, required String heading}) async {
    try {
      await OneSignal.shared.postNotification(OSCreateNotification(
        playerIds: playerIDs,
        content: content ?? heading,
        heading: heading,
      ));

      return true;
    } catch (e) {
      return false;
    }
  }
}
