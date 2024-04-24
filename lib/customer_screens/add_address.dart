import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mult_store/widget/appber_widgets.dart';
import 'package:mult_store/widget/sankbar.dart';
import 'package:mult_store/widget/yellow_button.dart';
import 'package:uuid/uuid.dart';

import '../widget/auth_widgets.dart';

class AddAddress extends StatefulWidget {
  AddAddress({super.key});

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  late String firstName;
  late String lastName;
  late String phone;
  late String countryValue = 'Choose Country';
  late String stateValue = 'Choose State';
  late String cityValue = 'Choose City';

  addAddress() async {
    CollectionReference reference = await FirebaseFirestore.instance
        .collection('customers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('address');

    var addressId = Uuid().v1();
    await reference.doc(addressId).set({
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'addressId': addressId,
      'country': countryValue,
      'state': stateValue,
      'city': cityValue,
      'default': false
    }).whenComplete(() => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: AppBeckButton(),
          title: AppBerTitle(
            title: 'Add Address',
          ),
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 40, 30, 40),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.50,
                          height: MediaQuery.of(context).size.height * 0.10,
                          child: TextFormField(
                            onChanged: (value) {
                              firstName = value;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'please enter your first name';
                              }
                              return null;
                            },
                            decoration: textFormDecoration.copyWith(
                                labelText: 'First Name',
                                hintText: 'Enter your first name'),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.50,
                          height: MediaQuery.of(context).size.height * 0.10,
                          child: TextFormField(
                            onChanged: (value) {
                              lastName = value;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'please enter your last name';
                              }
                              return null;
                            },
                            decoration: textFormDecoration.copyWith(
                                labelText: 'Last Name',
                                hintText: 'Enter your last name'),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.50,
                          height: MediaQuery.of(context).size.height * 0.10,
                          child: TextFormField(
                            onChanged: (value) {
                              phone = value;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'please enter your phone ';
                              }
                              return null;
                            },
                            decoration: textFormDecoration.copyWith(
                                labelText: 'phone',
                                hintText: 'Enter your phone '),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SelectState(
                  onCountryChanged: (value) {
                    setState(() {
                      countryValue = value;
                    });
                  },
                  onStateChanged: (value) {
                    setState(() {
                      stateValue = value;
                    });
                  },
                  onCityChanged: (value) {
                    setState(() {
                      cityValue = value;
                    });
                  },
                ),
                Center(
                    child: YellowButton(
                        label: 'Add New Address',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (countryValue != 'Choose Country' &&
                                stateValue != 'Choose State' &&
                                cityValue != 'Choose City') {
                              _formKey.currentState!.save();
                              addAddress();
                            } else {
                              MyMessagesHandler.showSankBar(
                                  _scaffoldKey, 'pleas full all field');
                            }
                          } else {
                            MyMessagesHandler.showSankBar(
                                _scaffoldKey, 'pleas set your location');
                          }
                        },
                        width: 0.8))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
