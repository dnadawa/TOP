import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:top/constants.dart';
import 'package:top/controllers/user_controller.dart';
import 'package:top/models/user_model.dart';
import 'package:top/views/hospital/hospital_page_selector.dart';
import 'package:top/views/log_in.dart';
import 'package:top/views/page_selector.dart';
import 'package:top/widgets/toast.dart';


class Wrapper extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var userController = Provider.of<UserController>(context);

    return FutureBuilder<User?>(
      future: userController.getCurrentUser(),
      builder: (context, snapshot){
        if (snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator());
        }

        if(snapshot.data != null && !snapshot.data!.isApproved!){
          userController.signOut();
          ToastBar(text: 'Your account is deleted or not approved!', color: Colors.red).show();
        }

        return (snapshot.data == null || !snapshot.data!.isApproved!) ? LogIn() : snapshot.data!.role == Role.Nurse ? PageSelector() : HospitalPageSelector();
      },
    );
  }
}
