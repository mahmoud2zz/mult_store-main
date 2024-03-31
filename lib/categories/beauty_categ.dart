import 'package:flutter/material.dart';

import '../utilities/categ_list.dart';
import '../widget/categ_widgets.dart';
class BeautyCategory extends StatelessWidget {
  BeautyCategory({super.key});

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
                    mainCageName: 'beauty',
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.68,
                    child: GridView.count(
                        crossAxisCount: 3,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 70,
                        children: List.generate(beauty.length-1, (index) {
                          return Column(
                            children: [
                              SubCategModel(
                                subCageName: beauty[index+1],
                                mainCageName: 'beauty',
                                assetsName: 'images/beauty/beauty$index.jpg',
                                subCategLabel: beauty[index+1],
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
            child: SilderBer(mainCageName: 'beauty'),
          )
        ],
      ),
    );
  }
}
