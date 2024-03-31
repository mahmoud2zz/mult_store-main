
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widget/auth_widgets.dart';
import '../widget/sankbar.dart';

class CustomerLogin extends StatefulWidget {
  const CustomerLogin({super.key});

  @override
  State<CustomerLogin> createState() => _CustomerLoginState();
}

class _CustomerLoginState extends State<CustomerLogin> {
  late String name;
  late String email;
  late String password;
  late String profileImage;
  bool processing = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
  GlobalKey<ScaffoldMessengerState>();

  bool passwordVisible = false;

  void logIn() async {
    setState(() {
      processing = true;
    });
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email, password: password);

        _formKey.currentState!.reset();


        Navigator.pushNamed(context, '/customer_home');
      setState(() {
        processing = false;
      });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          setState(() {
            processing = false;
          });
          MyMessagesHandler.showSankBar(
              _scaffoldKey, 'No user found for that email.');
        } else if (e.code == 'wrong-password') {
          setState(() {
            processing = false;
          });
          MyMessagesHandler.showSankBar(
              _scaffoldKey, 'Wrong password provided for that user.');
        }

      }

    }  else {
      setState(() {
        processing = false;
      });
      MyMessagesHandler.showSankBar(_scaffoldKey, 'please fill all filed');
    }
  }
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              reverse: true,
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding:  EdgeInsets.all(16),
                        child: AuthHeaderLabel(
                          headerLabel: 'Login In',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          onChanged: (value) {
                            email = value;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter your email';
                            } else if (value.isValidEmail() == false) {
                              return 'invalid email';
                            } else if (value.isValidEmail() == true) {
                              return null;
                            }
                            return null;
                          },
                          decoration: textFormDecoration.copyWith(
                              labelText: 'Email Address',
                              hintText: 'Enter your email'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          onChanged: (value) {
                            password = value;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter your password';
                            }
                            return null;
                          },
                          obscureText: passwordVisible,
                          decoration: textFormDecoration.copyWith(
                              labelText: 'Password',
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    passwordVisible = !passwordVisible;
                                  });
                                },
                                icon: passwordVisible
                                    ? Icon(Icons.visibility_off)
                                    : Icon(Icons.visibility),
                                color: Colors.purple,
                              ),
                              hintText: 'Enter your password'),
                        ),
                      ),
                      TextButton(
                          onPressed: () {},
                          child: Text(
                            'Forget Password?',
                            style: TextStyle(
                                fontSize: 18, fontStyle: FontStyle.italic),
                          )),
                      HaveAccount(
                        haveAccount: 'Dot\'n hava account?',
                        actionLabel: 'Sing Up',
                        onPressed: () =>
                            Navigator.pushNamed(
                                context, '/customer_signup'),
                      ),
                      processing==true
                          ? Center(
                        child: CircularProgressIndicator(
                          color: Colors.purple.shade500,
                        ),
                      )
                          : AuthMainButton(
                        mainButtonLabel: 'Login',
                        onPressed: () {
                          logIn();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


}




