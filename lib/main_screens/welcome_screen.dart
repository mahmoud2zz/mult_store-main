import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import '../widget/yellow_button.dart';

List<Color> textColor = [
  Colors.yellow,
  Colors.red,
  Colors.blueAccent,
  Colors.green,
  Colors.purple,
  Colors.teal
];


TextStyle textStyle =
    TextStyle(fontSize: 45, fontWeight: FontWeight.bold, fontFamily: 'Acme');

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool processing = false;
  CollectionReference anonymous = FirebaseFirestore.instance.collection('anonymous');
  late String uid;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _controller.repeat();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/inapp/bgimage.jpg'), fit: BoxFit.cover),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AnimatedTextKit(
                animatedTexts: [
                  ColorizeAnimatedText('WELCOME ',
                      textStyle: textStyle, colors: textColor),
                  ColorizeAnimatedText('Duck Store ',
                      textStyle: textStyle, colors: textColor)
                ],
                isRepeatingAnimation: true,
                repeatForever: true,
              ),
              SizedBox(
                height: 120,
                width: 200,
                child: Image.asset('images/inapp/logo.jpg'),
              ),
              SizedBox(
                height: 80,
                child: DefaultTextStyle(
                  style: TextStyle(
                      fontSize: 45,
                      color: Colors.lightBlueAccent,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Acme'),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      RotateAnimatedText('Buy'),
                      RotateAnimatedText('SHOP'),
                      RotateAnimatedText('DUCK Store'),
                    ],
                    repeatForever: true,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white38,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(
                                  50,
                                ),
                                topLeft: Radius.circular(
                                  50,
                                ))),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            'Supplier one',
                            style: TextStyle(
                                color: Colors.yellow,
                                fontSize: 26,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                            color: Colors.white38,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(
                                  50,
                                ),
                                topLeft: Radius.circular(
                                  50,
                                ))),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AnimatedLog(controller: _controller),
                              YellowButton(
                                label: 'Log In',
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, '/supplier_login');
                                },
                                width: 0.25,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: YellowButton(
                                  label: 'Sign Up',
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, '/supplier_signup');
                                  },
                                  width: 0.25,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                        color: Colors.white38,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(
                              50,
                            ),
                            topRight: Radius.circular(
                              50,
                            ))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: YellowButton(
                              label: 'Log In',
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, '/customer_login');
                              },
                              width: 0.25,
                            ),
                          ),
                          YellowButton(
                            label: 'Sign Up',
                            onPressed: () => Navigator.pushReplacementNamed(
                                context, '/customer_signup'),
                            width: 0.25,
                          ),
                          AnimatedLog(controller: _controller),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                decoration:
                    BoxDecoration(color: Colors.white38.withOpacity(.4)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FaceBookGoogleLogIn(
                      label: 'Google',
                      onTap: () {},
                      child: Image.asset('images/inapp/google.jpg'),
                    ),
                    FaceBookGoogleLogIn(
                        label: 'FaceBook',
                        onTap: () {},
                        child: Image.asset('images/inapp/facebook.jpg')),
                    processing
                        ? CircularProgressIndicator()
                        : FaceBookGoogleLogIn(
                            label: 'Guest',
                            onTap: () async {
                              setState(() {
                                processing = true;
                              });

                               await FirebaseAuth.instance.signInAnonymously().whenComplete(() async{
                                 uid=FirebaseAuth.instance.currentUser!.uid;
                                 anonymous.doc(uid).set({
                                   'name': '',
                                   'email':'' ,
                                   'profileImage': '',
                                   'address': '',
                                   'phone': '',
                                   'cid': uid,
                                   'coverImage':''
                                 });
                               });


                              Navigator.pushReplacementNamed(
                                  context, '/customer_home');
                            },
                            child: Icon(
                              Icons.person,
                              color: Colors.lightBlueAccent,
                              size: 55,
                            ),
                          ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedLog extends StatelessWidget {
  const AnimatedLog({
    super.key,
    required AnimationController controller,
  }) : _controller = controller;

  final AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        return Transform.rotate(
            angle: _controller.value * 2 * pi, child: child);
      },
      child: Image.asset(
        'images/inapp/logo.jpg',
      ),
    );
  }
}

class FaceBookGoogleLogIn extends StatelessWidget {
  final String label;
  final Function() onTap;
  final Widget child;

  const FaceBookGoogleLogIn({
    super.key,
    required this.label,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            SizedBox(
              child: child,
              width: 50,
              height: 50,
            ),
            Text(
              label,
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
