import 'package:ecom_app/controllers/auth_controller.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  AccountScreen({super.key});

  final AuthController _authController = AuthController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () async{
                  _authController.signOutUser(context: context);
                },
                child: Text("Đăng xuất"),
              ),
              ElevatedButton(
                onPressed: () async{
                  // Navigator.push(context, MaterialPageRoute(builder: (context) {
                  //   return OrderScreen();
                  // }));
                },
                child: Text("My order"),
              ),
            ],
          )
      ),
    );;
  }
}
