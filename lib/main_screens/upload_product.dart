import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../utilities/categ_list.dart';
import '../widget/sankbar.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;

class UploadProductScreen extends StatefulWidget {
  const UploadProductScreen({super.key});

  @override
  State<UploadProductScreen> createState() => _UploadProductScreenState();
}

class _UploadProductScreenState extends State<UploadProductScreen> {
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
  List<String> imagesUrlList = [];
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

        imagesFileList = pickedImage;
        print(imagesFileList);

        print('______________1');
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
    return ListView.builder(
        itemCount: imagesFileList!.length,
        itemBuilder: (context, index) {
          return Image.file(File(imagesFileList![index].path));
        });
  }

  Future<void> uploadImage() async {

    if (mainCateValue != 'select category' && subCateValue != 'subcategory') {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        if (imagesFileList!.isNotEmpty) {
          setState(() {
            processing = true;
          });
          try {
            for (var image in imagesFileList!) {
              firebase_storage.Reference ref = firebase_storage
                  .FirebaseStorage.instance
                  .ref('products/${path.basename(image.path)}');
              print(ref.fullPath);
              print('++++@');
               await ref.putFile(File(image.path)).whenComplete(() {
                ref.getDownloadURL().then((value) {
                  print('----4');
                  print(value);
                setState(() {
                  imagesUrlList.add(value);
                  print(imagesUrlList.length);
                  print('===========111');

                });
                }).catchError((e) {
                  print('===========1');
                  print(e);
                });
              });
            }
          } catch (e) {
            print(e);
          }
        } else {
          setState(() {
            processing = false;
          });

          MyMessagesHandler.showSankBar(_scaffoldKey, 'pleas pick images');
        }
      } else {
        setState(() {
          processing = false;
        });

        MyMessagesHandler.showSankBar(_scaffoldKey, 'pleas fill fields');
      }
    } else {
      setState(() {
        processing = false;
      });

      MyMessagesHandler.showSankBar(_scaffoldKey, 'pleas selected category');
    }
  }

  uploadData() async {
    if (imagesUrlList.isNotEmpty) {
      CollectionReference products =
          FirebaseFirestore.instance.collection('products');
      String proId =  Uuid().v4();
      print(proId);
      products.doc(proId).set({
        'proId': proId,
        'mainCate': mainCateValue,
        'subCate': subCateValue,
        'price': price,
        'instock': quantity,
        'proName': proName,
        'proDesc': proDesc,
        'sid': FirebaseAuth.instance.currentUser!.uid,
        'proImages': imagesUrlList,
        'discount': discount,
      }).whenComplete(() {
        print('000000000');
        setState(() {
          processing = false;
          imagesFileList = [];
          mainCateValue = 'select category';
          subCateList = [];
          imagesUrlList = [];
        });
        _formKey.currentState!.reset();

      }).catchError((e){
        print(e);
        setState(() {
          processing=false;
          imagesFileList=[];
        });
        _formKey.currentState!.reset();

      });
    } else {
 print('qqq');
      print('no images');

    _formKey.currentState!.reset();

    }
  }

  uploadProduct() async {
    await uploadImage().whenComplete(() => uploadData());
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
                  Row(
                    children: [
                      Container(
                        color: Colors.blueGrey.shade200,
                        width: size,
                        height: size,
                        child: imagesFileList != null
                            ? previewImages()
                            : Row(
                                children: [
                                  Center(
                                    child: Text(
                                      'you hava not \n \n  picked images yet !',
                                      style: TextStyle(fontSize: 16),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                ],
                              ),
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
                                    items: maincateg
                                        .map<DropdownMenuItem<String>>((value) {
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
                                  items: subCateList
                                      .map<DropdownMenuItem<String>>((value) {
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
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: FloatingActionButton(
                backgroundColor: Colors.yellow,
                onPressed: imagesFileList!.isEmpty
                    ? () {
                        pickProductsImages();
                      }
                    : () {
                        setState(() {
                          imagesFileList = [];
                        });
                      },
                child: imagesFileList!.isEmpty
                    ? Icon(
                        Icons.photo_library,
                        color: Colors.black,
                      )
                    : Icon(
                        Icons.delete_forever,
                        color: Colors.black,
                      ),
              ),
            ),
            FloatingActionButton(
              backgroundColor: Colors.yellow,
              onPressed: processing == true
                  ? () {
                      null;
                    }
                  : () {
                      uploadProduct();
                    },
              child: processing == true
                  ? CircularProgressIndicator(
                      color: Colors.black,
                    )
                  : Icon(Icons.upload, color: Colors.black),
            )
          ],
        ),
      ),
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
