import 'package:flutter/material.dart';
import 'package:mult_store/minor_screens/sub_categ_products.dart';

import '../widget/appber_widgets.dart';

class FullScreenView extends StatefulWidget {
  const FullScreenView({super.key, required this.images});

  final List<dynamic> images;

  @override
  State<FullScreenView> createState() => _FullScreenViewState();
}

class _FullScreenViewState extends State<FullScreenView> {
  final PageController _controller=PageController();
  int index=0;

  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: AppBeckButton(),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: Text(
                ('${index+1}')+('/')+(widget.images.length.toString()),
                style: TextStyle(fontSize: 24, letterSpacing: 8),
              ),
            ),
            SizedBox(
              height: size.height * .5,
              child: PageView(
                  controller: _controller,
                  onPageChanged: (value){
                   setState(() {
                     index=value;
                   });
                  },
                  children: images()),
            ),
            SizedBox(
              height: size.height * .2,
              child: imageView(),
            )
          ],
        ),
      ),
    );
  }

  Widget imageView() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .2,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.images.length,
          itemBuilder: (BuildContext context,  index) {
            return GestureDetector(
              onTap: (){
                _controller.jumpToPage(index);

              },
              child: Container(
                  margin: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.yellow, width: 4)),
                  child: ClipRRect(
                      child: Image.network(
                    widget.images[index],
                    fit: BoxFit.cover,
                  ))),
            );
          }),
    );
  }

  List<Widget> images() {
    return List.generate(widget.images.length, (index) {
      return InteractiveViewer(
          transformationController: TransformationController(),
          child: Image(image: NetworkImage(widget.images[index].toString())));
    });
  }
}
