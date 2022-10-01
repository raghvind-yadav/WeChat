import 'package:flutter/material.dart';
import './login_screen.dart';
import './registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);
  static String id = 'welcome_screen';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 1),
      upperBound: 100.0,
      vsync: this,
    );
    controller.forward();
    setState(() {});
    controller.addListener(() {
      print(controller.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    var mediaquery = MediaQuery.of(context).size;
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: 'logo',
                child: SizedBox(
                  height: mediaquery.height * 0.15,
                  child: Image.asset(
                    'assets/images/logo.png',
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              Center(
                  child: DefaultTextStyle(
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                    child: AnimatedTextKit(
                                  animatedTexts: [TyperAnimatedText('WeChat')],
                                ),
                  )),
            ],
          ),
          SizedBox(
            height: mediaquery.height * 0.03,
          ),
          SizedBox(
            height: mediaquery.height * 0.03,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Material(
              elevation: 5.0,
              color: Colors.lightBlueAccent,
              borderRadius: BorderRadius.circular(30.0),
              child: MaterialButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LoginScreen()));
                },
                minWidth: 200.0,
                height: 42.0,
                child: const Text(
                  'Log In',
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Material(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(30.0),
              elevation: 5.0,
              child: MaterialButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const RegistrationScreen()));
                },
                minWidth: 200.0,
                height: 42.0,
                child: const Text(
                  'Register',
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
