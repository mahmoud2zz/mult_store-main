import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mult_store/widget/appber_widgets.dart';
import 'package:mult_store/widget/sankbar.dart';
import 'package:mult_store/widget/yellow_button.dart';

class EditeStore extends StatefulWidget {
  final dynamic data;

  const EditeStore({super.key, required this.data});

  @override
  State<EditeStore> createState() => _EditeStoreState();
}

class _EditeStoreState extends State<EditeStore> {
  final ImagePicker _picker = ImagePicker();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  XFile? imageFileLogo;
  XFile? imageFileCover;
  dynamic pickedError;
  late String storeName;
  late String coverImage;
  late String storeLogo;
  late String phone;
  bool processing = false;
  Future<void> pickLogo() async {
    try {
      final XFile? pickedStoreLogo = await _picker.pickImage(
          source: ImageSource.gallery,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);
      setState(() {
        print(pickedStoreLogo);
        imageFileLogo = pickedStoreLogo;
        print('++1');
        print(imageFileLogo);
      });
    } catch (e) {
      print('++2');
      setState(() {
        pickedError = e;
      });
      print(pickedError);
    }
  }

  Future<void> pickCoverImage() async {
    try {
      final XFile? pickCoverImage = await _picker.pickImage(
          source: ImageSource.gallery,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);
      setState(() {
        print(pickCoverImage);
        imageFileCover = pickCoverImage;
        print('++1');
        print(imageFileLogo);
      });
    } catch (e) {
      print('++2');
      setState(() {
        pickedError = e;
      });
      print(pickedError);
    }
  }

  Future<void> uploadStoreLoge() async {
    if (imageFileLogo != null) {
      try {
        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref('supp_images/${widget.data['email']}.jpg');
        await ref.putFile(File(imageFileLogo!.path));

        storeLogo = await ref.getDownloadURL();
      } catch (e) {
        print('filled upload');
        print(e);
      }
    } else {
      storeLogo = widget.data['storeLogo'];
    }
  }

  Future uploadCoverImage() async {
    if (imageFileCover != null) {
      try {
        firebase_storage.Reference ref2 = firebase_storage
            .FirebaseStorage.instance
            .ref('supp_images/${widget.data['email']}.jpg_cover');
        await ref2.putFile(File(imageFileLogo!.path));

        coverImage = await ref2.getDownloadURL();
      } catch (e) {
        print('filled upload');
        print(e);
      }
    } else {
      coverImage = widget.data['coverImage'];
    }
  }

  Future<void> onSaveChanges() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        processing = true;
      });
      print('success save');

      await uploadStoreLoge().whenComplete(() async {
        await uploadCoverImage().whenComplete(() {
          editeStoreData();
        });
        setState(() {
          processing = false;
        });
      });
    } else {
      setState(() {
        processing = false;
      });
      print('fill save');
      MyMessagesHandler.showSankBar(_scaffoldKey, 'please all  fields');
    }
  }

  void editeStoreData() async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('suppliers')
          .doc(FirebaseAuth.instance.currentUser!.uid);
      transaction.update(documentReference, {
        'storeName': storeName,
        'storeLogo': storeLogo,
        'phone': phone,
        'coverImage': coverImage,
      });
    }).whenComplete(() {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: AppBerTitle(title: 'Edite Store'),
          leading: AppBeckButton(),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Column(
                children: [
                  Text(
                    'Store Loge',
                    style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(widget.data['storeLogo']),
                      ),
                      Column(
                        children: [
                          YellowButton(
                            onPressed: () => pickLogo(),
                            label: 'Change',
                            width: 0.25,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          imageFileLogo == null
                              ? SizedBox()
                              : YellowButton(
                                  onPressed: () {
                                    setState(() {
                                      imageFileLogo = null;
                                    });
                                  },
                                  label: 'Rest',
                                  width: 0.25,
                                ),
                        ],
                      ),
                      imageFileLogo == null
                          ? SizedBox(
                              height: 10,
                            )
                          : CircleAvatar(
                              radius: 60,
                              backgroundImage:
                                  FileImage(File(imageFileLogo!.path)),
                            ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(
                      16,
                    ),
                    child: Divider(
                      color: Colors.yellow,
                      thickness: 2.5,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    'Cover Loge',
                    style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage:
                            NetworkImage(widget.data['coverImage']),
                      ),
                      Column(
                        children: [
                          YellowButton(
                            onPressed: () async => await pickCoverImage(),
                            label: 'Change',
                            width: 0.25,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          imageFileCover == null
                              ? SizedBox()
                              : YellowButton(
                                  onPressed: () {
                                    setState(() {
                                      imageFileCover = null;
                                    });
                                  },
                                  label: 'Rest',
                                  width: 0.25,
                                ),
                        ],
                      ),
                      imageFileCover == null
                          ? SizedBox(
                              height: 10,
                            )
                          : CircleAvatar(
                              radius: 60,
                              backgroundImage:
                                  FileImage(File(imageFileCover!.path)),
                            ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(
                      16,
                    ),
                    child: Divider(
                      color: Colors.yellow,
                      thickness: 2.5,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'pleas enter store name';
                    }
                  },
                  onSaved: (value) {
                    storeName = value!;
                  },
                  initialValue: widget.data['storeName'],
                  decoration: textFromDecoration.copyWith(
                      labelText: 'store name', helperText: 'Edite Store name '),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'pleas enter phone';
                    }
                  },
                  onSaved: (value) {
                    phone = value!;
                  },
                  initialValue: widget.data['phone'],
                  decoration: textFromDecoration.copyWith(
                      labelText: 'phone', helperText: 'Edite phone '),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    YellowButton(
                        label: 'Cancel',
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        width: 0.25),
                    processing == true
                        ? YellowButton(
                            label: 'pleas wait..',
                            onPressed: () async {
                              null;
                            },
                            width: 0.5)
                        : YellowButton(
                            label: 'Save Changes',
                            onPressed: () async {
                              await onSaveChanges();
                            },
                            width: 0.5),
                  ],
                ),
              )
            ],
          ),
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
