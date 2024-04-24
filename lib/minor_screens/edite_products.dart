import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mult_store/widget/pink_button.dart';
import 'package:mult_store/widget/yellow_button.dart';
import 'package:uuid/uuid.dart';
import '../utilities/categ_list.dart';
import '../widget/sankbar.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;

class EditeProducts extends StatefulWidget {
  final dynamic item;
  const EditeProducts({super.key, this.item});

  @override
  State<EditeProducts> createState() => _EditeProducts();
}

class _EditeProducts extends State<EditeProducts> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  late double price;
  late int? quantity;
  late String proName;
  late String proDesc;
  String mainCateValue = 'select category';
  String subCateValue = 'subcategory';
  List<String> subCateList = [];
  List<dynamic> imagesUrlList = [];
  List<XFile>? imagesFileList = [];
  dynamic pickedError;
  int? discount = 0;
  bool processing = false;

  final ImagePicker _picker = ImagePicker();

  void pickProductsImages() async {
    try {
      var pickedImage = await _picker.pickMultiImage(
          maxHeight: 300, maxWidth: 300, imageQuality: 95);
      setState(() {
        print('---23');
        print(pickedImage);
        setState(() {
          imagesFileList = pickedImage;
        });
      });
    } catch (e) {
      setState(() {
        pickedError = e;
        print('______________3');
        print(e);
      });
      print(pickedError);
    }
  }

  Widget previewImages() {
    if (imagesFileList!.isNotEmpty) {
      return ListView.builder(
          itemCount: imagesFileList!.length,
          itemBuilder: (context, index) {
            return Image.file(File(imagesFileList![index].path));
          });
    } else {
      return Center(
        child: Text('you hava not \n \n  picked images yet !',
            style: TextStyle(fontSize: 16), textAlign: TextAlign.center),
      );
    }
  }

  Widget previewCurrentImages() {
    List<dynamic> itemImages = widget.item['proImages'];
    return ListView.builder(
        itemCount: itemImages.length,
        itemBuilder: (context, index) {
          return Image.network(itemImages[index].toString());
        });
  }

  void selectedMainCategory(String? value) {
    if (value == 'select category') {
      subCateList = [];
    } else if (value == 'men') {
      subCateList = men;
    } else if (value == 'women') {
      subCateList = women;
    } else if (value == 'electronics') {
      subCateList = electronics;
    } else if (value == 'accessories') {
      subCateList = accessories;
    } else if (value == 'shoes') {
      subCateList = shoes;
    } else if (value == 'home & garden') {
      subCateList = homeandgarden;
    } else if (value == 'beauty') {
      subCateList = beauty;
    } else if (value == 'kids') {
      subCateList = kids;
    } else if (value == 'bags') {
      subCateList = bags;
    }
    print('---');
    print(value);
    setState(() {
      mainCateValue = value!;
      subCateValue = 'subcategory';
    });
  }

  Future<void> uploadImages() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (imagesFileList!.isNotEmpty) {
        if (mainCateValue != 'select category' &&
            subCateValue != 'subcategory') {
          try {
            for (var image in imagesFileList!) {
              firebase_storage.Reference ref = firebase_storage
                  .FirebaseStorage.instance
                  .ref('products/${path.basename(image.path)}');
              print(ref.fullPath);
              print('++++@');
              await ref.putFile(File(image.path)).whenComplete(() async {
                await ref.getDownloadURL().then((value) async {
                  imagesUrlList.add(value);
                });
              });
            }
          } catch (e) {
            print(e);
          }
        } else {
          MyMessagesHandler.showSankBar(
              _scaffoldKey, 'pleas selected category');
        }
      } else {
        imagesUrlList = widget.item['proImages'];
      }
    } else {
      MyMessagesHandler.showSankBar(_scaffoldKey, 'pleas fill fields');
    }
  }

  void editeProductData() {
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('products')
          .doc(widget.item['proId']);
      transaction.update(documentReference, {
        'mainCate': mainCateValue,
        'subCate': subCateValue,
        'price': price,
        'instock': quantity,
        'proName': proName,
        'proDesc': proDesc,
        'proImages': imagesUrlList,
        'discount': discount,
      });
    }).whenComplete(() => Navigator.pop(context));
  }

  void deleteItem() {
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('products')
          .doc(widget.item['proId']);

      transaction.delete(documentReference);
    }).whenComplete(() => Navigator.pop(context));
  }

  void saveChanges() async {
    await uploadImages().whenComplete(() {
      editeProductData();
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context).width * 0.5;
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            reverse: true,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Container(
                              color: Colors.blueGrey.shade200,
                              width: size,
                              height: size,
                              child: previewCurrentImages()),
                          SizedBox(
                            height: size,
                            width: size,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      '  main category',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.all(10),
                                      constraints:
                                          BoxConstraints(minWidth: size),
                                      decoration: BoxDecoration(
                                        color: Colors.yellow,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                          child: Text(widget.item['mainCate'])),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text('sub category',
                                        style: TextStyle(color: Colors.red)),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.all(10),
                                      constraints:
                                          BoxConstraints(minWidth: size),
                                      decoration: BoxDecoration(
                                        color: Colors.yellow,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                          child: Text(widget.item['subCate'])),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      ExpandablePanel(
                          theme: ExpandableThemeData(hasIcon: false),
                          header: Padding(
                            padding: EdgeInsets.all(0),
                            child: Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                  color: Colors.yellow,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: Text('Change Images & Categories',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                              ),
                            ),
                          ),
                          collapsed: SizedBox(),
                          expanded: changeImages(size)),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                    child: Divider(
                      color: Colors.yellow,
                      thickness: 1.5,
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.4,
                          child: TextFormField(
                            initialValue:
                                widget.item['price'].toStringAsFixed(2),
                            onSaved: (value) {
                              price = double.parse(value!);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'pleas enter price';
                              } else if (value.isValidatorPrice() == true) {
                                return 'invalid price';
                              }
                              return null;
                            },
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            decoration: textFromDecoration.copyWith(
                              labelText: 'price',
                              hintText: 'price...',
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.4,
                          child: TextFormField(
                            initialValue: widget.item['discount'].toString(),
                            maxLength: 2,
                            onSaved: (value) {
                              discount = int.parse(value!);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return null;
                              } else if (value.isValidatorDiscount() == true) {
                                return 'invalid discount';
                              }
                              return null;
                            },
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            decoration: textFromDecoration.copyWith(
                              labelText: 'discount',
                              hintText: 'discount..%',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      child: TextFormField(
                        initialValue: widget.item['instock'].toString(),
                        onSaved: (value) {
                          quantity = int.parse(value!);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'pleas enter Quantity';
                          } else if (value.isValidatorQuantity() != true) {
                            print('invalidQuantity');
                          }
                          return null;
                        },
                        decoration: textFromDecoration.copyWith(
                          labelText: 'Quantity',
                          hintText: 'Add Quantity',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      child: TextFormField(
                        initialValue: widget.item['proName'],
                        maxLength: 100,
                        maxLines: 3,
                        decoration: textFromDecoration.copyWith(
                          labelText: 'product name',
                          hintText: 'Enter  product name',
                        ),
                        onSaved: (value) {
                          proName = value!;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'pleas enter product name';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      child: TextFormField(
                        initialValue: widget.item['proDesc'],
                        onSaved: (value) {
                          proDesc = value!;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'pleas enter product description';
                          }
                          return null;
                        },
                        maxLength: 800,
                        maxLines: 5,
                        decoration: textFromDecoration.copyWith(
                          labelText: 'product description',
                          hintText: 'Enter  product description',
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          YellowButton(
                              label: 'Cancel',
                              onPressed: () {
                                Navigator.of(context);
                              },
                              width: 0.3),
                          YellowButton(
                              label: 'Save Changes',
                              onPressed: () => saveChanges(),
                              width: 0.5),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PinkButton(
                            label: 'Delete item',
                            onPressed: () => deleteItem(),
                            width: 0.7),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget changeImages(dynamic size) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              color: Colors.blueGrey.shade200,
              width: size,
              height: size,
              child: imagesFileList != null
                  ? previewImages()
                  : Center(
                      child: Text(
                      'you hava not \n \n  picked images yet !',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    )),
            ),
            SizedBox(
              height: size,
              width: size,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Text(
                        '* select  main category',
                        style: TextStyle(color: Colors.red),
                      ),
                      DropdownButton(
                          iconSize: 40,
                          iconEnabledColor: Colors.red,
                          dropdownColor: Colors.yellow.shade400,
                          iconDisabledColor: Colors.black,
                          value: mainCateValue,
                          items:
                              maincateg.map<DropdownMenuItem<String>>((value) {
                            return DropdownMenuItem(
                              child: Text(value),
                              value: value,
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            selectedMainCategory(value!);
                          }),
                    ],
                  ),
                  Column(
                    children: [
                      Text('select Category',
                          style: TextStyle(color: Colors.red)),
                      DropdownButton(
                        iconEnabledColor: Colors.red,
                        iconDisabledColor: Colors.black,
                        iconSize: 40,
                        dropdownColor: Colors.yellow.shade400,
                        disabledHint: Text('* select Category'),
                        value: subCateValue,
                        items:
                            subCateList.map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem(
                            child: Text(value),
                            value: value,
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            subCateValue = value!;
                          });
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: imagesFileList!.isNotEmpty
              ? YellowButton(
                  label: 'Reset',
                  onPressed: () {
                    setState(() {
                      imagesFileList = [];
                    });
                  },
                  width: 0.5)
              : YellowButton(
                  label: 'Change Images',
                  onPressed: () {
                    pickProductsImages();
                  },
                  width: 0.5),
        )
      ],
    );
  }
}

var textFromDecoration = InputDecoration(
    labelText: '',
    hintText: '',
    labelStyle: TextStyle(color: Colors.purple),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.yellow, width: 1)),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.yellow, width: 2)));

extension QuantityValidator on String {
  bool isValidatorQuantity() {
    return RegExp(r'^[1_9][0_9]*$').hasMatch(this);
  }
}

extension PriceValidator on String {
  bool isValidatorPrice() {
    return RegExp(r'^(([1_9][0_9]*[\.]*)||([0][\.])([0_9]{1,2}))$')
        .hasMatch(this);
  }
}

extension DiscountValidator on String {
  bool isValidatorDiscount() {
    return RegExp(r'^([0_9]*)$').hasMatch(this);
  }
}
