import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:top/constants.dart';

class EmailService {
  Future<bool> sendEmail(
      {List<String>? to,
      required String subject,
      Map<String, dynamic>? templateData,
      required String templateID,
      String from = 'topnurseagency@gmail.com'}) async {
    try {
      if (to != null) {
        to = [...{...to}];
      }

      final recipients = to ?? [adminEmail];
      final response = await http.post(
        Uri.parse("https://api.topnurseagency.com/sendEmailFromApp"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'toAddress': recipients.length > 1 ? ["topnurseagency@gmail.com"] : recipients,
          'subject': subject,
          'bcc': recipients.length > 1 ? recipients : null,
          'templateData': templateData,
          'templateId': templateID,
        }),
      );

      final success = jsonDecode(response.body)['success'] == true;
      if (success != true) {
        print("mail error : ${response.body}");
      }
      return success;
    } catch (e) {
      print("mail error : $e");
      return false;
    }
  }

  Future<bool> sendNotification(
      {required List<String> playerIDs, String? content, required String heading}) async {
    try {
      final response = await http.post(
        Uri.parse("https://api.topnurseagency.com/sendNotification"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'playerIds': playerIDs,
          'heading': heading,
          'content': content,
        }),
      );

      return jsonDecode(response.body)['success'] == true;
    } catch (e) {
      return false;
    }
  }
}
