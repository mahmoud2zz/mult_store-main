import 'package:flutter/material.dart';

class AppBerTitle extends StatelessWidget {
  final String title;

  const AppBerTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:EdgeInsets.zero,
      child: Center(
        child: Text(
          title,
          style: TextStyle(
              color: Colors.black,
              fontFamily: 'Acme',
              fontSize: 30,
              letterSpacing: 1.2,),

        ),
      ),
    );
  }
}

class AppBeckButton extends StatelessWidget {
  const AppBeckButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
      ),
    );
  }
}

class AppBerYellowButton extends StatelessWidget {
  const AppBerYellowButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.pop(context),
      icon: Icon(
        Icons.arrow_back_ios,
        color: Colors.yellow,
      ),
    );
  }
}
