import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sendgrid_mailer/sendgrid_mailer.dart';
import 'package:top/constants.dart';

class EmailService {
  sendEmail({List<String>? to, required String subject, Map<String, dynamic>? templateData, required String templateID, String from = 'topnurseagency@gmail.com'}) async {
    try{
      final mailer = Mailer(dotenv.env['SENDGRID']!);
      List<Address> toAddresses = to == null ? [Address(adminEmail)] : to.map((e) => Address(e)).toList();
      final fromAddress = Address(from, "TOP Nurse Agency");
      final personalization = Personalization(toAddresses, dynamicTemplateData: templateData, subject: subject);

      final email = Email([personalization], fromAddress, subject, templateId: templateID);
      await mailer.send(email);
      return true;
    } catch (e){
      print(e);
      return false;
    }
  }
}
