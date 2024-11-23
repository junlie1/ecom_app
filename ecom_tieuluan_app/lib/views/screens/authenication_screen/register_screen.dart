import 'package:ecom_tieuluan_app/controllers/auth_controller.dart';
import 'package:ecom_tieuluan_app/views/screens/authenication_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var _formKey = GlobalKey<FormState>();
  var isObsecure = true.obs;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;
  final AuthController _authController = AuthController();

  signUpUsers() async{
    setState(() {
      _isLoading = true;
    });
    String email = emailController.text;
    String confirmPassword = confirmPasswordController.text;
    String password = passwordController.text;
    await _authController.signUpUsers(
        context: context,
        email: email,
        confirmPassword: confirmPassword,
        password: password
    ).whenComplete(() {
      _formKey.currentState!.reset();
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: screenHeight),
                child: IntrinsicHeight(
//Form SignUp
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //Image
                      Image.asset(
                        'assets/images/headerregister_image.jpg',
                        width: screenWidth,
                        height: screenHeight * 0.3,
                        fit: BoxFit.cover,
                      ),
                      //SignUp, Email, Password
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "SIGN UP",
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.purple,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            // Trường nhập Email
                            TextFormField(
                              controller: emailController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter your email';
                                } else if (!value.endsWith('@gmail.com')) {
                                  return 'Email addresses ending in @gmail.com';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person_outline, color: Colors.purple),
                                labelText: 'Email',
                                labelStyle: TextStyle(color: Colors.purple),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.purple),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.purple),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            //Trường nhập fullName
                            TextFormField(
                              controller: confirmPasswordController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter your full name';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person_outline, color: Colors.purple),
                                labelText: 'Confirm password',
                                labelStyle: TextStyle(color: Colors.purple),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.purple),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.purple),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            // Trường nhập Password
                            Obx( () => TextFormField(
                              controller: passwordController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter your password';
                                }
                                return null;
                              },
                              obscureText: isObsecure.value,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock_outline, color: Colors.purple),
                                labelText: 'Password',
                                labelStyle: TextStyle(color: Colors.purple),
                                suffixIcon: Obx(() => GestureDetector(
                                  onTap: () {
                                    isObsecure.value = !isObsecure.value;
                                  },
                                  child: Icon(
                                    isObsecure.value ? Icons.visibility_off : Icons.visibility,
                                    color: Colors.purple,
                                  ),
                                )),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.purple),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.purple),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),
                            ),
                            SizedBox(height: 20),
                            //Button SignUp
                            Center(
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () async{
                                      if (_formKey.currentState!.validate()) {
                                        signUpUsers();
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                                      decoration: BoxDecoration(
                                        color: Colors.purple.withOpacity(0.8),
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      child: _isLoading? CircularProgressIndicator(color: Colors.white,) : Text(
                                        "Sign up",
                                        style: TextStyle(fontSize: 18, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text("Bạn đã có tài khoản?"),
                                      TextButton(
                                        onPressed: () {
                                          Get.to(LoginScreen());
                                        },
                                        child: const Text(
                                          "Login here",
                                          style: TextStyle(
                                            color: Colors.purple,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
