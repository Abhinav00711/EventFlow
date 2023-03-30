import 'package:flutter/material.dart';

import '../../utils/curve_painter.dart';
import '../ProfileScreen/profile_form.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  // static final _formKey = GlobalKey<FormState>();

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // late bool _isEditable;

  // @override
  // void initState() {
  //   super.initState();
  //   _isEditable = false;
  // }

  @override
  Widget build(BuildContext context) {
    //   String _name = '';
    // String _sid = '';
    // String _phone = '';
    // String _department = '';
    // String _course = '';

    //   Student user = Global.userData!;

    return Scaffold(
      backgroundColor: const Color(0xFF640D14),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.ease,
              height: MediaQuery.of(context).size.height * 0.2,
              child: CustomPaint(
                painter: CurvePainter(true, color: const Color(0xFF800E13)),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.only(top: 30),
                    child: Center(
                      child: Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: const Color(0xFF640D14).withOpacity(0.6),
                                offset: const Offset(2.0, 4.0),
                                blurRadius: 8),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius:
                          const BorderRadius.all(Radius.circular(60.0)),
                          child: Image.asset('assets/images/userImage.png'),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.ease,
              height: MediaQuery.of(context).size.height * 0.8,
              child: Container(
                color: Colors.transparent,
                padding: const EdgeInsets.only(top: 60),
                child: SingleChildScrollView(
                  child: Column(
                    children: const [
                      // _isEditable
                      //     ? Form(
                      //         key: ProfileScreen._formKey,
                      //         child: Column(
                      //           mainAxisSize: MainAxisSize.min,
                      //           children: [
                      //             Padding(
                      //               padding: const EdgeInsets.all(16),
                      //               child: TextFormField(
                      //                 style: const TextStyle(
                      //                   fontSize: 18,
                      //                   color: Colors.white,
                      //                 ),
                      //                 decoration: registerInputDecoration(
                      //                   hintText: 'Name',
                      //                   icon: FontAwesomeIcons.user,
                      //                 ),
                      //                 initialValue: user.name,
                      //                 keyboardType: TextInputType.name,
                      //                 autocorrect: false,
                      //                 cursorColor: Colors.white,
                      //                 autovalidateMode:
                      //                     AutovalidateMode.onUserInteraction,
                      //                 validator: (value) {
                      //                   if (value!.trim().isEmpty) {
                      //                     return 'Please enter your name.';
                      //                   } else if (!RegExp('[a-zA-Z]')
                      //                       .hasMatch(value.trim())) {
                      //                     return 'Invalid name';
                      //                   } else {
                      //                     return null;
                      //                   }
                      //                 },
                      //                 onSaved: (newValue) {
                      //                   name = newValue!.trim();
                      //                 },
                      //               ),
                      //             ),
                      //             Padding(
                      //               padding: const EdgeInsets.all(16),
                      //               child: TextFormField(
                      //                 style: const TextStyle(
                      //                   fontSize: 18,
                      //                   color: Colors.white,
                      //                 ),
                      //                 decoration: registerInputDecoration(
                      //                     hintText: 'Phone',
                      //                     icon: FontAwesomeIcons.phone,
                      //                     counterStyle: Colors.white),
                      //                 initialValue: user.phone,
                      //                 keyboardType: TextInputType.phone,
                      //                 autocorrect: false,
                      //                 maxLength: 10,
                      //                 maxLengthEnforcement:
                      //                     MaxLengthEnforcement.enforced,
                      //                 cursorColor: Colors.white,
                      //                 autovalidateMode:
                      //                     AutovalidateMode.onUserInteraction,
                      //                 validator: (value) {
                      //                   if (value!.trim().isEmpty) {
                      //                     return 'Please enter your phone number.';
                      //                   } else if (!RegExp('[0-9]')
                      //                           .hasMatch(value.trim()) ||
                      //                       value.trim().length != 10) {
                      //                     return 'Invalid Phone Number';
                      //                   } else {
                      //                     return null;
                      //                   }
                      //                 },
                      //                 onSaved: (newValue) {
                      //                   phone = newValue!.trim();
                      //                 },
                      //               ),
                      //             ),
                      //             Padding(
                      //               padding: const EdgeInsets.all(16),
                      //               child: TextFormField(
                      //                 style: const TextStyle(
                      //                   fontSize: 18,
                      //                   color: Colors.white,
                      //                 ),
                      //                 decoration: registerInputDecoration(
                      //                   hintText: 'Business Name',
                      //                   icon: FontAwesomeIcons.briefcase,
                      //                 ),
                      //                 initialValue: user.bname,
                      //                 keyboardType: TextInputType.name,
                      //                 autocorrect: false,
                      //                 cursorColor: Colors.white,
                      //                 autovalidateMode:
                      //                     AutovalidateMode.onUserInteraction,
                      //                 validator: (value) {
                      //                   if (value!.trim().isEmpty) {
                      //                     return 'Please enter your business name.';
                      //                   } else if (!RegExp('[a-zA-Z]')
                      //                       .hasMatch(value.trim())) {
                      //                     return 'Invalid name';
                      //                   } else {
                      //                     return null;
                      //                   }
                      //                 },
                      //                 onSaved: (newValue) {
                      //                   bname = newValue!.trim();
                      //                 },
                      //               ),
                      //             ),
                      //             Padding(
                      //               padding: const EdgeInsets.all(16),
                      //               child: TextFormField(
                      //                 style: const TextStyle(
                      //                   fontSize: 18,
                      //                   color: Colors.white,
                      //                 ),
                      //                 decoration: registerInputDecoration(
                      //                   hintText: 'Address',
                      //                   icon: FontAwesomeIcons.addressBook,
                      //                 ),
                      //                 initialValue: user.address,
                      //                 keyboardType: TextInputType.streetAddress,
                      //                 autocorrect: false,
                      //                 cursorColor: Colors.white,
                      //                 autovalidateMode:
                      //                     AutovalidateMode.onUserInteraction,
                      //                 validator: (value) {
                      //                   if (value!.trim().isEmpty) {
                      //                     return 'Please enter your address.';
                      //                   } else {
                      //                     return null;
                      //                   }
                      //                 },
                      //                 onSaved: (newValue) {
                      //                   address = newValue!.trim();
                      //                 },
                      //               ),
                      //             ),
                      //             Padding(
                      //               padding: const EdgeInsets.all(16),
                      //               child: TextFormField(
                      //                 style: const TextStyle(
                      //                   fontSize: 18,
                      //                   color: Colors.white,
                      //                 ),
                      //                 decoration: registerInputDecoration(
                      //                   hintText: 'Discount',
                      //                   icon: FontAwesomeIcons.percent,
                      //                 ),
                      //                 enabled: false,
                      //                 initialValue: user.discount.toString(),
                      //                 keyboardType: TextInputType.number,
                      //                 autocorrect: false,
                      //                 cursorColor: Colors.white,
                      //                 autovalidateMode:
                      //                     AutovalidateMode.onUserInteraction,
                      //                 validator: (value) {
                      //                   if (value!.trim().isEmpty) {
                      //                     return 'Please enter discount.';
                      //                   } else if (!RegExp('[0-9]')
                      //                       .hasMatch(value.trim())) {
                      //                     return 'Invalid Discount';
                      //                   } else {
                      //                     return null;
                      //                   }
                      //                 },
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       )
                      //     :
                      ProfileForm(),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(
                      //       horizontal: 50, vertical: 20),
                      //   child: _isEditable
                      //       ? Row(
                      //           mainAxisSize: MainAxisSize.max,
                      //           mainAxisAlignment:
                      //               MainAxisAlignment.spaceEvenly,
                      //           children: [
                      //             ProfileButton(
                      //               text: ' SAVE ',
                      //               onPressed: () async {
                      //                 if (ProfileScreen._formKey.currentState!
                      //                     .validate()) {
                      //                   ProfileScreen._formKey.currentState!
                      //                       .save();
                      //                   UserData interestData = UserData(
                      //                     id: user.id,
                      //                     name: name,
                      //                     phone: phone,
                      //                     bname: bname,
                      //                     address: address,
                      //                     discount: user.discount,
                      //                     token: user.token,
                      //                   );
                      //                   await MySqlService()
                      //                       .updateInterest(interestData);
                      //                   setState(() {
                      //                     _isEditable = false;
                      //                   });
                      //                 }
                      //               },
                      //             ),
                      //             ProfileButton(
                      //               text: 'CANCEL',
                      //               onPressed: () {
                      //                 setState(() {
                      //                   _isEditable = false;
                      //                 });
                      //               },
                      //             ),
                      //           ],
                      //         )
                      //       : ProfileButton(
                      //           text: ' EDIT ',
                      //           onPressed: () {
                      //             setState(() {
                      //               _isEditable = true;
                      //             });
                      //           },
                      //         ),
                      // ),
                    ],
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
