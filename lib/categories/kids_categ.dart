import 'package:flutter/material.dart';

import '../utilities/categ_list.dart';
import '../widget/categ_widgets.dart';
class KidsCategory extends StatelessWidget {
  KidsCategory({super.key});

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
                    mainCageName: 'kids',
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.68,
                    child: GridView.count(
                        crossAxisCount: 3,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 70,
                        children: List.generate(kids.length-1, (index) {
                          return Column(
                            children: [
                              SubCategModel(
                                subCageName: kids[index+1],
                                mainCageName: 'kids',
                                assetsName: 'images/kids/kids$index.jpg',
                                subCategLabel: kids[index+1],
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
            child: SilderBer(mainCageName: 'kids'),
          )
        ],
      ),
    );
  }
}
