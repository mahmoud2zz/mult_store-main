import 'package:flutter/material.dart';

class AuthMainButton extends StatelessWidget {
  final String mainButtonLabel;
  final Function() onPressed;

  const AuthMainButton({
    super.key,
    required this.mainButtonLabel,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Material(
          color: Colors.purple,
          borderRadius: BorderRadius.circular(25),
          child: MaterialButton(
            minWidth: double.infinity,
            onPressed: onPressed,
            child: Text(
              mainButtonLabel,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ));
  }
}

class HaveAccount extends StatelessWidget {
  final String haveAccount;
  final String actionLabel;
  final Function() onPressed;

  const HaveAccount({
    super.key,
    required this.haveAccount,
    required this.actionLabel,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          haveAccount,
          style: TextStyle(
            fontSize: 16,
            fontStyle: FontStyle.italic,
          ),
        ),
        TextButton(
            onPressed: onPressed,
            child: Text(
              actionLabel,
              style: TextStyle(
                color: Colors.purple,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ))
      ],
    );
  }
}

class AuthHeaderLabel extends StatelessWidget {
  final String headerLabel;

  const AuthHeaderLabel({
    super.key,
    required this.headerLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          headerLabel,
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.home_work,
              size: 40,
            ))
      ],
    );
  }
}

var textFormDecoration = InputDecoration(
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(25),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(25),
    borderSide: BorderSide(
      width: 1,
      color: Colors.purple,
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(25),
    borderSide: BorderSide(
      width: 2,
      color: Colors.deepPurpleAccent,
    ),
  ),
);

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^([a-zA-Z0-9]+)([\-\_\.]*)([a-zA-Z0-9]*)([@])([a-zA-Z0-9]{2,})([\.][a-zA-Z]{2,3})$')
        .hasMatch(this);
  }
}
