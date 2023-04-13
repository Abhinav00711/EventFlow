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
                      ProfileForm(),
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
