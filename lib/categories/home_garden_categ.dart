import 'package:flutter/material.dart';

import '../utilities/categ_list.dart';
import '../widget/categ_widgets.dart';
class HomeandGardenCategory extends StatelessWidget {
  const HomeandGardenCategory({super.key});

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
                    mainCageName: 'homeandgarden',
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.68,
                    child: GridView.count(
                        crossAxisCount: 3,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 70,
                        children: List.generate(homeandgarden.length-1, (index) {
                          return Column(
                            children: [
                              SubCategModel(
                                subCageName: homeandgarden[index+1],
                                mainCageName: 'homeandgarden',
                                assetsName: 'images/homegarden/home$index.jpg',
                                subCategLabel: homeandgarden[index+1],
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
            child: SilderBer(mainCageName: 'homeandgarden'),
          )
        ],
      ),
    );
  }
}
