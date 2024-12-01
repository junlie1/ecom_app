import 'dart:convert';

import 'package:ecom_app/global_varibales.dart';
import 'package:ecom_app/models/user.dart';
import 'package:ecom_app/provider/user_provider.dart';
import 'package:ecom_app/services/manage_http_response.dart';
import 'package:ecom_app/views/screens/authenication_screen/login_screen.dart';
import 'package:ecom_app/views/screens/main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


final providerContainer = ProviderContainer();
class AuthController {
  Future<void> signUpUsers({
    required context,
    required String email,
    required String password,
    required String confirmPassword,
  })async {
    try {
      User user = User(
          id: '',
          name: '',
          email: email,
          password: password,
          confirmPassword: confirmPassword,
          phone: 0,
          address: '',
          avatar: '',
          token: '',
          city: '',
      );
      http.Response response = await http.post(Uri.parse('$uri/api/user/sign-up'),
          body: user.toJson(),
          headers: <String, String> {
            "Content-Type" : 'application/json; charset=UTF-8',
          }
      );
      managerHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
            showSnackBar(context, "Bạn đã tạo mới tài khoản thành công");
          }
      );
    }
    catch(e) {

    }
  }

  //SignIn Users
  Future<void> signInUsers({
    required context,
    required email,
    required password
  })async{
    try {
      http.Response response = await http.post(
          Uri.parse('$uri/api/user/sign-in'),
          body: jsonEncode({
            'email':email,
            'password': password
          }),
          headers: <String, String> {
            "Content-Type" : 'application/json; charset=UTF-8',
          }
      );
      print(jsonDecode(response.body)['statusCode']);
        managerHttpResponse(
            response: response,
            context: context,
            onSuccess: () async {
              /*Lưu trữ thông tin user bằng SharedPreferences*/
              //Khởi tạo SharedPreferences
              SharedPreferences preferences = await SharedPreferences.getInstance();
              final responseData = jsonDecode(response.body);
              //Giải mã token từ body để sử dụng trong app
              String token = responseData['token'];
              await preferences.setString('auth_token', token);

              // Mã hóa user data nhận được từ backend trả về không lấy password trong auth.js
              final userJson = jsonEncode(responseData['user']);
              providerContainer.read(userProvider.notifier).setUser(userJson);

              //Lưu trữ dữ liệu user cho sau này sử dụng
              await preferences.setString('user', userJson);

              /* Navigator.pushAndRemoveUntil(context, newRoute, predicate)
      Là đẩy sang trang mới và xóa dữ liệu trang cũ
      predicate là một hàm bool Function(Route) trả về giá trị true hoặc false */
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen()), (route)=> false
              );
              showSnackBar(context, "Bạn đã đăng nhập thành công");
            });
      }
    catch(e) {
      print("Error: $e");
    }
  }

  //SignOut User
  Future<void> signOutUser({required context}) async {
    try{
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.remove('auth_token');
      await preferences.remove('user');
      //Xóa thông tin user trong userProvider
      providerContainer.read(userProvider.notifier).signOut();

      //Đẩy về trang Login
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) {
            return LoginScreen();
          }),
              (route) => false
      );
      showSnackBar(context, "Bạn đã đăng xuất thành công" );
    }
    catch(e) {
      showSnackBar(context, "Đăng xuất thất bại" );
    }
  }

  //Update location
  Future<void> updateUserLocation({
    required context,
    required userId,
    required phone,
    required address,
    required avatar,
  }) async {
    try{
      http.Response response = await http.put(
          Uri.parse("$uri/api/users/$userId"),
          body: jsonEncode({
            'phone': phone,
            'address': address,
            'avatar': avatar,
          }),
          headers: <String, String> {
            "Content-Type" : 'application/json; charset=UTF-8',
          }
      );
      managerHttpResponse(
          response: response,
          context: context,
          onSuccess: ()async {
            final updatedUser = jsonDecode(response.body);
            SharedPreferences preferences = await SharedPreferences.getInstance();
            final userJson = jsonEncode(updatedUser);

            providerContainer.read(userProvider.notifier).setUser(userJson);

            preferences.setString('user', userJson);
          }
      );
    }
    catch(e) {
      showSnackBar(context, "Lỗi update user localtion");
    }
  }
}