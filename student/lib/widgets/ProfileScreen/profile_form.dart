import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../data/global.dart';
import '../../models/student.dart';
import '../LoginScreen/decoration_functions.dart';

class ProfileForm extends StatelessWidget {
  const ProfileForm({Key? key}) : super(key: key);

  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Student user = Global.userData!;

    return Form(
      key: ProfileForm._formKey,
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
              enabled: false,
              initialValue: user.name,
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
                hintText: 'Register Number',
                icon: FontAwesomeIcons.idCard,
              ),
              enabled: false,
              initialValue: user.sid,
              keyboardType: TextInputType.number,
              autocorrect: false,
              cursorColor: Colors.white,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return 'Please enter your register number.';
                } else if (!RegExp('[0-9]').hasMatch(value.trim())) {
                  return 'Invalid register number';
                } else {
                  return null;
                }
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
              enabled: false,
              initialValue: user.phone,
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
              enabled: false,
              initialValue: user.email,
              keyboardType: TextInputType.streetAddress,
              autocorrect: false,
              cursorColor: Colors.white,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return 'Please enter your email.';
                } else {
                  return null;
                }
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
              enabled: false,
              initialValue: user.department,
              keyboardType: TextInputType.number,
              autocorrect: false,
              cursorColor: Colors.white,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return 'Please enter department.';
                } else if (!RegExp('[a-zA-Z]').hasMatch(value.trim())) {
                  return 'Invalid department';
                } else {
                  return null;
                }
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
              enabled: false,
              initialValue: user.course,
              keyboardType: TextInputType.number,
              autocorrect: false,
              cursorColor: Colors.white,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return 'Please enter course.';
                } else if (!RegExp('[a-zA-Z]').hasMatch(value.trim())) {
                  return 'Invalid course';
                } else {
                  return null;
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
