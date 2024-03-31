import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../widget/auth_widgets.dart';
import '../widget/sankbar.dart';

class SupplierRegister extends StatefulWidget {
  const SupplierRegister({super.key});

  @override
  State<SupplierRegister> createState() => _SupplierRegisterState();
}

class _SupplierRegisterState extends State<SupplierRegister> {
  late String storeName;
  late String email;
  late String password;
  late String _uid;
  late String storeLogo;
  bool processing = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  ImagePicker _picker = ImagePicker();
  bool passwordVisible = false;

  CollectionReference suppliers =
      FirebaseFirestore.instance.collection('suppliers');
  XFile? _imageFile;
  dynamic pickedError;

  void _pickImageFromCamera() async {
    try {
      var pickedImage = await _picker.pickImage(
          source: ImageSource.camera,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);
      setState(() {
        _imageFile = pickedImage;
      });
    } catch (e) {
      setState(() {
        pickedError = e;
      });
      print(pickedError);
    }
  }

  void _pickImageFromGallery() async {
    try {
      final pickedImage = await _picker.pickImage(
          source: ImageSource.gallery,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);
      setState(() {
        _imageFile = pickedImage;
      });
    } catch (e) {
      setState(() {
        pickedError = e;
      });
      print(pickedError);
    }
  }

  void singUp() async {
    setState(() {
      processing = true;
    });
    if (_formKey.currentState!.validate()) {
      if (_imageFile != null) {
        try {
          await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: password);

          firebase_storage.Reference ref =
              FirebaseStorage.instance.ref('supp_images/$email.jpg');

          UploadTask uploadTask = ref.putFile(File(_imageFile!.path));
          TaskSnapshot downloadURL = (await uploadTask);
          _uid = FirebaseAuth.instance.currentUser!.uid;
          storeLogo = await ref.getDownloadURL();

          await suppliers.doc(_uid).set({
            'storeName': storeName,
            'email': email,
            'storeLogo': storeLogo,
            'phone': '',
            'sid': _uid
          });

          _formKey.currentState!.reset();
          setState(() {
            _imageFile = null;
          });

          Navigator.pushNamed(context, '/supplier_login');
        } on FirebaseException catch (e) {
          print('_____');
          print(e);
          if (e.code == 'weak-password') {
            setState(() {
              processing = false;
            });
            MyMessagesHandler.showSankBar(
                _scaffoldKey, 'The password provided is too weak.');
          } else if (e.code == 'email-already-in-use') {
            setState(() {
              processing = false;
            });
            MyMessagesHandler.showSankBar(
                _scaffoldKey, 'The account already exists for that email.');
          }
        }
      } else {
        setState(() {
          processing = false;
        });
        MyMessagesHandler.showSankBar(_scaffoldKey, 'please pick image first');
      }
    } else {
      setState(() {
        processing = false;
      });
      MyMessagesHandler.showSankBar(_scaffoldKey, 'please fill all filed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              reverse: true,
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: AuthHeaderLabel(
                          headerLabel: 'Sing Up',
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 40),
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.purpleAccent,
                              backgroundImage: _imageFile == null
                                  ? null
                                  : FileImage(File(_imageFile!.path)),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.purple,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15))),
                                child: IconButton(
                                  onPressed: () => _pickImageFromCamera(),
                                  icon: Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.purple,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(15),
                                        bottomRight: Radius.circular(15))),
                                child: IconButton(
                                  onPressed: () {
                                    _pickImageFromGallery();
                                  },
                                  icon: Icon(
                                    Icons.photo,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          onChanged: (value) {
                            storeName = value;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter your full storeName';
                            }
                            return null;
                          },
                          decoration: textFormDecoration.copyWith(
                              labelText: 'Full storeName',
                              hintText: 'Enter your full storeName'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter your email';
                            } else if (value.isValidEmail() == false) {
                              return 'invalid email';
                            } else if (value.isValidEmail() == true) {
                              MyMessagesHandler.showSankBar(_scaffoldKey, 'your  email is valid');
                            }
                            return null;
                          },
                          onChanged: (value) {
                            email = value;
                          },
                          decoration: textFormDecoration.copyWith(
                              labelText: 'Email Address',
                              hintText: 'Enter your email'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          onChanged: (value) {
                            password = value;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter your password';
                            }
                            return null;
                          },
                          obscureText: passwordVisible,
                          decoration: textFormDecoration.copyWith(
                              labelText: 'Password',
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    passwordVisible = !passwordVisible;
                                  });
                                },
                                icon: passwordVisible
                                    ? Icon(Icons.visibility_off)
                                    : Icon(Icons.visibility),
                                color: Colors.purple,
                              ),
                              hintText: 'Enter your password'),
                        ),
                      ),
                      HaveAccount(
                        haveAccount: 'already hava account?',
                        actionLabel: 'Log In',
                        onPressed: () =>
                            Navigator.pushNamed(context, '/supplier_login'),
                      ),
                      processing == true
                          ? const CircularProgressIndicator(
                              color: Colors.purple,
                            )
                          : AuthMainButton(
                              mainButtonLabel: 'Sign Up',
                              onPressed: () {
                                singUp();
                              },
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
