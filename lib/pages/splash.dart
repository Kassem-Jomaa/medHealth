import 'package:flutter/material.dart';
import 'package:med_health_app/model/pref_profile_model.dart';
import 'package:med_health_app/pages/login_page.dart';
import 'package:med_health_app/pages/main_page.dart';
import 'package:med_health_app/widgets/button_primary.dart';
import 'package:med_health_app/widgets/general_logo.dart';
import 'package:med_health_app/widgets/widget_illustration.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  String? UserId;

  @override
  void initState() {
    super.initState();
    getPref();
  }

  getPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      UserId = sharedPreferences.getString(PrefProfileModel.idUser);
      UserId == null ? sessionLogout() : sessionLogin();
    });
  }

  sessionLogout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  sessionLogin() {
    //coment this to login and remove the saved data
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainPage()),
   );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GeneralLogo(
        child: Column(
          children: [
            const SizedBox(height: 45),
            WidgetIllustration(
              image: 'assets/splash_ilustration.png',
              title: 'Find your medical\nsolution',
              subtitle1: 'Consult with a doctor',
              subtitle2: "wherever and whenever you want!",
              child: ButtonPrimary(
                text: "Get Started",
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
