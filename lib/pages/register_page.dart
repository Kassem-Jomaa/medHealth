import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:med_health_app/api/url_api.dart';
import 'package:med_health_app/pages/login_page.dart';
import 'package:med_health_app/theme.dart';
import 'package:http/http.dart' as http;
import 'package:med_health_app/widgets/button_primary.dart';
import 'package:med_health_app/widgets/general_logo.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _secureText = true;

  // Method to show or hide the password
  showeHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  // Method to handle registration logic
  registerSubmit() async {
    var registerUrl = Uri.parse(BASEURL.apiRegister);
    final response = await http.post(registerUrl, body: {
      'fullname': fullNameController.text,
      'email': emailController.text,
      'phone': phoneController.text,
      'address': addressController.text,
      'password': passwordController.text,
    });

    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];
    if (value == 1) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Information"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text("OK"),
            )
          ],
        ),
      );
      setState(() {});
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Information"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK"),
            )
          ],
        ),
      );
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(25),
            child: GeneralLogo(child: SizedBox()),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "REGISTER",
                  style: regularTextStyle.copyWith(fontSize: 25),
                ),
                SizedBox(height: 8),
                Text(
                  "Register your new account",
                  style: regularTextStyle.copyWith(
                      fontSize: 15, color: greyLightColor),
                ),
                SizedBox(height: 15),
                _buildTextField("Full Name", fullNameController),
                SizedBox(height: 15),
                _buildTextField("Email Address", emailController),
                SizedBox(height: 15),
                _buildTextField("Phone Number", phoneController),
                SizedBox(height: 15),
                _buildTextField("Home Address", addressController),
                SizedBox(height: 15),
                _buildPasswordField(),
                SizedBox(height: 20),
                Center(
                  child: ButtonPrimary(
                    text: "Register",
                    onTap: () {
                      print("object");
                      print("$fullNameController");
                      print("$emailController");

                      if (fullNameController.text.isEmpty ||
                          emailController.text.isEmpty ||
                          phoneController.text.isEmpty ||
                          addressController.text.isEmpty ||
                          passwordController.text.isEmpty) {
                        print("empty");
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Warning !!!"),
                            content: Text("Please fill out all fields"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("OK"),
                              )
                            ],
                          ),
                        );
                      } else {
                        registerSubmit();
                      }
                    },
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: lightTextStyle.copyWith(color: greyLightColor),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: Text(
                        "Login now",
                        style: lightTextStyle.copyWith(
                            color: greenColor, fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build text fields
  Widget _buildTextField(String hint, TextEditingController controller) {
    return Container(
      padding: EdgeInsets.only(left: 16),
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0x40000000),
            offset: Offset(0, 1),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
        color: whiteColor,
      ),
      width: MediaQuery.of(context).size.width,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle:
              lightTextStyle.copyWith(fontSize: 15, color: greyLightColor),
        ),
      ),
    );
  }

  // Helper method to build password field with show/hide functionality
  Widget _buildPasswordField() {
    return Container(
      padding: EdgeInsets.only(left: 16),
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0x40000000),
            offset: Offset(0, 1),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
        color: whiteColor,
      ),
      width: MediaQuery.of(context).size.width,
      child: TextField(
        controller: passwordController,
        obscureText: _secureText,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: showeHide,
            icon: Icon(
              _secureText ? Icons.visibility_off : Icons.visibility,
              size: 25,
            ),
          ),
          border: InputBorder.none,
          hintText: 'Password',
          hintStyle:
              lightTextStyle.copyWith(fontSize: 15, color: greyLightColor),
        ),
      ),
    );
  }
}
