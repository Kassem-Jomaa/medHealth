import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:med_health_app/api/url_api.dart';
import 'package:med_health_app/model/pref_profile_model.dart';
import 'package:med_health_app/pages/main_page.dart';
import 'package:med_health_app/pages/register_page.dart';
import 'package:med_health_app/theme.dart';
import 'package:med_health_app/widgets/button_primary.dart';
import 'package:med_health_app/widgets/general_logo.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// LoginPage widget is a StatefulWidget that provides login functionality
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

// State class for LoginPage
class _LoginPageState extends State<LoginPage> {
  // Text controllers to handle user input for email and password
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _secureText = true; // Flag to toggle password visibility

  // Toggles password visibility
  void showHide() {
    setState(() {
      _secureText = !_secureText; // Toggles the _secureText flag
    });
  }

  // Method to handle login submission with error handling
  Future<void> submitLogin() async {
    try {
      // Define the login URL and send a POST request with email and password
      var urlLogin = Uri.parse(BASEURL.apiLogin);
      final response = await http.post(urlLogin, body: {
        'email': emailController.text,
        'password': passwordController.text,
      });

      // Decodes JSON response from server
      final data = jsonDecode(response.body);
      int value = data['value'];
      String message = data['message'];

      // If login is successful, save user info in shared preferences
      if (value == 1) {
        int idUser = data['user_id'];
        String name = data['name'];
        String email = data['email'];
        String phone = data['phone'];
        String address = data['address'];
        String createdAt = data['created_at'];

        // Save data in shared preferences
        await SavePref(
            idUser.toString(), name, email, phone, address, createdAt);

        // Retrieve and print name to confirm it is stored correctly
        await getPref();
        print("Logged in user: $name");

        // Show success message and navigate to MainPage
        _showAlertDialog("Information", message, () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainPage()),
          );
        });
      } else {
        // Show error message if login fails
        _showAlertDialog("Information", message, () {
          Navigator.pop(context);
        });
      }
    } catch (e) {
      // Error handling for failed network connection
      debugPrint("Error: $e");
      _showAlertDialog(
          "Error", "Failed to connect to server. Please try again.", () {
        Navigator.pop(context);
      });
    }
  }

  // Method to show an alert dialog with a title, message, and action button
  void _showAlertDialog(String title, String message, VoidCallback onPressed) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: onPressed,
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  // Method to save user data to shared preferences
  SavePref(String idUser, String name, String email, String phone,
      String address, String createdAt) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences.setString(PrefProfileModel.idUser, idUser);
      sharedPreferences.setString(PrefProfileModel.name, name);
      sharedPreferences.setString(PrefProfileModel.email, email);
      sharedPreferences.setString(PrefProfileModel.phone, phone);
      sharedPreferences.setString(PrefProfileModel.address, address);
      sharedPreferences.setString(PrefProfileModel.createdAt, createdAt);
    });
  }

  // Retrieves user name from shared preferences
  String? name;
  getPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    name = sharedPreferences.getString(PrefProfileModel.name);
  }

  // Builds the login page UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(25),
        children: [
          // Logo and welcome text
          GeneralLogo(child: SizedBox()),
          SizedBox(height: 25),
          Text(
            "Login",
            style: regularTextStyle.copyWith(fontSize: 25),
          ),
          SizedBox(height: 10),
          Text(
            "Login into your account",
            style:
                regularTextStyle.copyWith(fontSize: 15, color: greyLightColor),
          ),
          SizedBox(height: 30),

          // Email and password input fields
          _buildTextField("Email Address", emailController),
          SizedBox(height: 20),
          _buildPasswordField(),

          // Login button with form validation
          SizedBox(height: 20),
          Center(
            child: ButtonPrimary(
              text: "Login",
              onTap: () {
                if (emailController.text.isEmpty ||
                    passwordController.text.isEmpty) {
                  _showAlertDialog("Warning !!!", "Please fill out all fields",
                      () {
                    Navigator.pop(context);
                  });
                } else {
                  submitLogin();
                }
              },
            ),
          ),
          SizedBox(height: 20),

          // Register button if user doesn't have an account
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account?",
                style: lightTextStyle.copyWith(color: greyLightColor),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                child: Text(
                  "Register",
                  style:
                      lightTextStyle.copyWith(color: greenColor, fontSize: 15),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper method to build text fields for input
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
          ),
        ],
        color: whiteColor,
      ),
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
          ),
        ],
        color: whiteColor,
      ),
      child: TextField(
        controller: passwordController,
        obscureText: _secureText, // Controls password visibility
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: showHide,
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
