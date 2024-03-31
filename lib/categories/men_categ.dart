import 'package:flutter/material.dart';

import '../utilities/categ_list.dart';
import '../widget/categ_widgets.dart';

class MenCategory extends StatelessWidget {
  MenCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width * 0.75,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  CategHederLabel(
                    mainCageName: 'Men',
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.68,
                    child: GridView.count(
                        crossAxisCount: 3,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 70,
                        children: List.generate(men.length-1, (index) {
                          return Column(
                            children: [
                              SubCategModel(
                                subCageName: men[index+1],
                                mainCageName: 'men',
                                assetsName: 'images/men/men$index.jpg',
                                subCategLabel: men[index+1],
                              ),
                            ],
                          );
                        })),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: SilderBer(mainCageName: 'men'),
          )
        ],
      ),
    );
  }
}
