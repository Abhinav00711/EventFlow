import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:provider/provider.dart';

import '../LoginScreen/decoration_functions.dart';
// import '../../models/retailer.dart';
// import '../../services/firestore_service.dart';
import '../../providers/auth_provider.dart';

class RegisterForm extends StatefulWidget {
  static final _formKey = GlobalKey<FormState>();

  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  String _name = '';
  String _sid = '';
  String _phone = '';
  String _department = '';
  String _email = '';
  String _course = '';

  static final List<String> _interests = [
    'Computer Science',
    'Law',
    'Statistics',
    'Commerce',
    'Humanities',
    'Science',
  ];

  final List<MultiSelectItem<String?>> _items =
      _interests.map((i) => MultiSelectItem<String?>(i, i)).toList();

  List<String?> _selectedInterests = [];

  @override
  Widget build(BuildContext context) {
    return Form(
      key: RegisterForm._formKey,
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextFormField(
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
                decoration: registerInputDecoration(
                  hintText: 'Name',
                  icon: FontAwesomeIcons.user,
                ),
                keyboardType: TextInputType.name,
                autocorrect: false,
                cursorColor: Colors.white,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return 'Please enter your name.';
                  } else if (!RegExp('[a-zA-Z]').hasMatch(value.trim())) {
                    return 'Invalid name';
                  } else {
                    return null;
                  }
                },
                onSaved: (newValue) {
                  _name = newValue!.trim();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextFormField(
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
                decoration: registerInputDecoration(
                  hintText: 'Registration Number',
                  icon: FontAwesomeIcons.idCard,
                ),
                keyboardType: TextInputType.number,
                autocorrect: false,
                maxLength: 7,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                cursorColor: Colors.white,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return 'Please enter your register number.';
                  } else if (!RegExp('[0-9]').hasMatch(value.trim()) ||
                      value.trim().length != 7) {
                    return 'Invalid register number';
                  } else {
                    return null;
                  }
                },
                onSaved: (newValue) {
                  _sid = newValue!.trim();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextFormField(
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
                decoration: registerInputDecoration(
                  hintText: 'Phone',
                  icon: FontAwesomeIcons.phone,
                ),
                maxLength: 10,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                keyboardType: TextInputType.phone,
                autocorrect: false,
                cursorColor: Colors.white,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return 'Please enter your phone number.';
                  } else if (!RegExp('[0-9]').hasMatch(value.trim()) ||
                      value.trim().length != 10) {
                    return 'Invalid Phone Number';
                  } else {
                    return null;
                  }
                },
                onSaved: (newValue) {
                  _phone = newValue!.trim();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextFormField(
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
                decoration: registerInputDecoration(
                  hintText: 'Email',
                  icon: Icons.mail,
                ),
                keyboardType: TextInputType.streetAddress,
                autocorrect: false,
                cursorColor: Colors.white,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return 'Please enter your email.';
                  } else if (!value.trim().contains('@')) {
                    return 'Invalid Email';
                  } else {
                    return null;
                  }
                },
                onSaved: (newValue) {
                  _email = newValue!.trim();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextFormField(
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
                decoration: registerInputDecoration(
                  hintText: 'Department',
                  icon: FontAwesomeIcons.building,
                ),
                keyboardType: TextInputType.name,
                autocorrect: false,
                cursorColor: Colors.white,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return 'Please enter your department.';
                  } else {
                    return null;
                  }
                },
                onSaved: (newValue) {
                  _department = newValue!.trim();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextFormField(
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
                decoration: registerInputDecoration(
                  hintText: 'Course',
                  icon: FontAwesomeIcons.book,
                ),
                keyboardType: TextInputType.name,
                autocorrect: false,
                cursorColor: Colors.white,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return 'Please enter your course.';
                  } else {
                    return null;
                  }
                },
                onSaved: (newValue) {
                  _course = newValue!.trim();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: MultiSelectChipField<String?>(
                items: _items,
                icon: const Icon(FontAwesomeIcons.xmark),
                title: const Text(
                  "Interests",
                  style: TextStyle(color: Colors.white),
                ),
                headerColor: Colors.transparent,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1.8),
                ),
                selectedChipColor: Colors.red.withOpacity(0.5),
                selectedTextStyle: TextStyle(color: Colors.red[800]),
                scroll: false,
                onTap: (values) {
                  _selectedInterests = values;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              child: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (RegisterForm._formKey.currentState!.validate()) {
                      RegisterForm._formKey.currentState!.save();
                      // Retailer userData = Retailer(
                      //   rid: widget.uid,
                      //   name: _name,
                      //   phone: _phone,
                      //   state: _state,
                      //   email: _email,
                      //   delivery_address: _daddress,
                      // );
                      //await FirestoreService().addUser(userData);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(FontAwesomeIcons.circleCheck),
                              SizedBox(width: 20),
                              Text(
                                'Registered Successfully',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          backgroundColor: Colors.tealAccent,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                      await Provider.of<AuthProvider>(context, listen: false)
                          .logout();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    shadowColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text(
                    'REGISTER',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF213333),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
