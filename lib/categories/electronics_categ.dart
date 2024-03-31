import 'package:flutter/material.dart';

import '../utilities/categ_list.dart';
import '../widget/categ_widgets.dart';
class ElectronicsCategory extends StatelessWidget {
  const ElectronicsCategory({super.key});

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
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CategHederLabel(
                    mainCageName: 'electronics',
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.68,
                    child: GridView.count(
                        crossAxisCount: 3,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 70,
                        children: List.generate(electronics.length-1, (index) {
                          return Column(
                            children: [
                              SubCategModel(
                                subCageName: electronics[index+1],
                                mainCageName: 'electronics',
                                assetsName: 'images/electronics/electronics$index.jpg',
                                subCategLabel: electronics[index+1],
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
            child: SilderBer(mainCageName: 'electronics'),
          )
        ],
      ),
    );
  }
}
