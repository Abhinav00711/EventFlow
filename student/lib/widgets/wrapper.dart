import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

// import '../screens/login_screen.dart';
// import '../screens/tabs_screen.dart';
// import '../screens/verify_screen.dart';
import '../screens/error_screen.dart';
import '../screens/loading_screen.dart';
import '../providers/auth_provider.dart';
// import '../services/firestore_service.dart';
// import '../models/retailer.dart';
// import '../data/global.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthProvider().user,
      builder: (context, user) {
        if (user.hasError) {
          return const ErrorScreen();
        } else if (user.hasData) {
          return FutureBuilder<bool>(
            future:
                Provider.of<AuthProvider>(context, listen: false).isVerified(),
            builder: (context, verify) {
              if (verify.hasError) {
                return const ErrorScreen();
              } else if (verify.hasData) {
                if (verify.data!) {
                  return const Scaffold(
                    body: Center(
                      child: Text('loggedin'),
                    ),);
                  // return FutureBuilder<Retailer?>(
                  //   future: FirestoreService().getUser(user.data!.uid),
                  //   builder: (context, userData) {
                  //     if (userData.hasError) {
                  //       return const ErrorScreen();
                  //     } else if (userData.hasData) {
                  //       Global.userData = userData.data;
                  //       return TabsScreen();
                  //     } else {
                  //       return const LoadingScreen();
                  //     }
                  //   },
                  // );
                } else {
                  user.data!.sendEmailVerification();
                  return const Scaffold(
                    body: Center(
                      child: Text('Verify Screen'),
                    ),);
                  // return VerifyScreen();
                }
              } else {
                return const LoadingScreen();
              }
            },
          );
        } else {
          return const Scaffold(
                    body: Center(
                      child: Text('login screen'),
                    ),
                    );
          // return LoginScreen();
        }
      },
    );
  }
}
