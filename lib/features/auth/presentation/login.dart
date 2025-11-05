import 'package:coffee_pos/core/widgets/custom_button.dart';
import 'package:coffee_pos/core/theme/input_style.dart';
import 'package:coffee_pos/features/auth/data/auth_service.dart';
import 'package:coffee_pos/features/auth/utils/validator.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final formKey = GlobalKey<FormState>();
  final userController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/StreetSide_BG.png"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
          ),
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.08),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: [
                  Image.asset(
                    "assets/images/StreetSide_BG.png",
                    height: 120,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "DON’T WORRY, BREW HAPPY ☕",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              Container(
                width: 400,
                padding: EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.brown.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Text(
                        'Street Side Café',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 36,
                          letterSpacing: 2,
                        ),
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        controller: userController,
                        style: TextStyle(color: Colors.white),
                        decoration: customInputDecoration('Username', Icons.person),
                        validator: AuthValidators.username,
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: passwordController,
                        obscureText: obscurePassword,
                        style: TextStyle(color: Colors.white),
                        decoration: customInputDecoration(
                          'Password',
                          Icons.lock,
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.white70,
                            ),
                            onPressed: () {
                              setState(() {
                                obscurePassword = !obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: AuthValidators.password,
                      ),
                      SizedBox(height: 30),
                      CustomButton(
                        text: ('Sign In'),
                        onPressed: (){
                          if (formKey.currentState!.validate()) {
                            AuthService.login(
                              userController.text,
                              passwordController.text,
                            );
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
