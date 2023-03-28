import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../screens/login_screen.dart';
import '../screens/verify_screen.dart';
import '../screens/error_screen.dart';
import '../screens/loading_screen.dart';
import '../providers/auth_provider.dart';
import '../models/student.dart';
import '../services/mysql_service.dart';
import '../data/global.dart';
import '../models/event.dart';
import '../screens/navigation_home_screen.dart';

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
                  return FutureBuilder<Student>(
                    future: MySqlService().getStudent(user.data!.email!),
                    builder: (context, userData) {
                      if (userData.hasError) {
                        return const ErrorScreen();
                      } else if (userData.hasData) {
                        Global.userData = userData.data;
                        return FutureBuilder<Event?>(
                          future: MySqlService().isHosting(userData.data!.sid),
                          builder: (context, eventData) {
                            if (eventData.connectionState ==
                                ConnectionState.done) {
                              return NavigationHomeScreen(
                                  event: eventData.data);
                            } else {
                              return const LoadingScreen();
                            }
                          },
                        );
                      } else {
                        return const LoadingScreen();
                      }
                    },
                  );
                } else {
                  user.data!.sendEmailVerification();
                  return const VerifyScreen();
                }
              } else {
                return const LoadingScreen();
              }
            },
          );
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
