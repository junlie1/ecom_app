import 'package:ecom_tieuluan_app/controllers/auth_controller.dart';
import 'package:ecom_tieuluan_app/views/screens/authenication_screen/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthController _authController = AuthController();
  bool isLoading = false;
  var isObsecure = true.obs;

  loginUser() async {
    setState(() {
      isLoading = true;
    });
    String email = emailController.text;
    String password = passwordController.text;
    await _authController.signInUsers(
        context: context,
        email: email,
        password: password
    ).whenComplete(() {
      formKey.currentState!.reset();
      setState(() {
        isLoading = false;
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
            key: formKey,
            // Thêm SingleChildScrollView để có thể cuộn
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: screenHeight,
              ),
              child: IntrinsicHeight(
                //Khung Login
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //Images
                    Image.asset(
                      'assets/images/headerlogin_image.jpg',
                      width: screenWidth,
                      height: screenHeight * 0.3,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 20.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "SIGN IN",
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
                                return 'Sorry, we could not find your account';
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
                          // Trường nhập Mật khẩu
                          Obx(
                                () => TextFormField(
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
                          SizedBox(height: 5),
                          //Quên mật khẩu?
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              child: const Text(
                                "Forgotten password?",
                                style: TextStyle(color: Colors.purple),
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          //Button SignIn
                          Center(
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () async{
                                    if (formKey.currentState!.validate()) {
                                      loginUser();
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                                    decoration: BoxDecoration(
                                      color: Colors.purple.withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: isLoading? CircularProgressIndicator(color: Colors.white,) : Text(
                                      "Login",
                                      style: TextStyle(fontSize: 18, color: Colors.white),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("Don't have an account?"),
                                    TextButton(
                                      onPressed: () {
                                        Get.to(RegisterScreen());
                                      },
                                      //Sang trang SignUp
                                      child: const Text(
                                        "Sign up here",
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
                          SizedBox(height: 10),
                          Center(
                            child: const Text(
                              "Or continue with",
                              style: TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(Icons.g_mobiledata, size: 40, color: Colors.purple),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: Icon(Icons.facebook, size: 40, color: Colors.purple),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: Icon(Icons.phone, size: 40, color: Colors.purple),
                                onPressed: () {},
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
