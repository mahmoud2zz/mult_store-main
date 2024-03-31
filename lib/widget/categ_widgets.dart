import 'package:flutter/material.dart';

import '../minor_screens/sub_categ_products.dart';

class SilderBer extends StatelessWidget {
  final String mainCageName;

  const SilderBer({
    super.key,
    required this.mainCageName,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      width: MediaQuery.of(context).size.width * 0.05,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Colors.brown.withOpacity(0.2),
            borderRadius: BorderRadius.circular(50),
          ),
          child: RotatedBox(
            quarterTurns: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                mainCageName == 'beauty'
                    ? Text('')
                    : Text(
                        '<<',
                        style: style,
                      ),
                Text(
                  mainCageName.toUpperCase(),
                  style: TextStyle(
                      color: Colors.brown,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 10),
                ),
                mainCageName == 'men'
                    ? Text('')
                    : Text(
                        '>>',
                        style: style,
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

const style = TextStyle(
    color: Colors.brown,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 10);

class SubCategModel extends StatelessWidget {
  final String subCageName;
  final String mainCageName;
  final String assetsName;
  final String subCategLabel;

  const SubCategModel({
    super.key,
    required this.subCageName,
    required this.mainCageName,
    required this.assetsName,
    required this.subCategLabel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SubCategProducts(
                      subCageName: subCageName,
                      mainCageName: mainCageName,
                    )));
      },
      child: Column(
        children: [
          SizedBox(
            width: 70,
            height: 70,
            child: Image.asset(assetsName,),
          ),
          Text(subCategLabel,style: TextStyle(fontSize: 11),)
        ],
      ),
    );
  }
}

class CategHederLabel extends StatelessWidget {
  final String mainCageName;

  const CategHederLabel({
    super.key,
    required this.mainCageName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      child: Text(
        mainCageName,
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 1.5),
      ),
    );
  }
}
