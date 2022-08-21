import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sendgrid_mailer/sendgrid_mailer.dart';

class EmailService {
  sendEmail({String to = 'nkenwey@gmail.com', required String subject, Map<String, dynamic>? templateData, required String templateID}) async {
    try{
      final mailer = Mailer(dotenv.env['SENDGRID']!);
      final toAddress = Address(to);
      final fromAddress = Address('damienkenway61@gmail.com', "TOP Nurse Agency");
      final personalization = Personalization([toAddress], dynamicTemplateData: templateData);

      final email = Email([personalization], fromAddress, subject, templateId: templateID);
      await mailer.send(email);
      return true;
    } catch (e){
      print(e);
      return false;
    }
  }
}
