import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fluttertoast/fluttertoast.dart';

import '../utils/app_theme.dart';
import '../widgets/HomeScreen/drawer_user_controller.dart';
import '../models/drawer_item.dart';
import '../models/event.dart';
import './home_screen.dart';
import './profile_screen.dart';
import './my_events_screen.dart';
import './host_event_screen.dart';

class NavigationHomeScreen extends StatefulWidget {
  final Event? event;
  const NavigationHomeScreen({required this.event, Key? key}) : super(key: key);

  @override
  State<NavigationHomeScreen> createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  late Widget screenView;
  late DrawerIndex drawerIndex;
  bool _isFirstBack = true;

  @override
  void initState() {
    super.initState();
    drawerIndex = DrawerIndex.home;
    screenView = const HomeScreen();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
    ));
    return WillPopScope(
      onWillPop: () async {
        if (drawerIndex != DrawerIndex.home) {
          setState(() {
            drawerIndex = DrawerIndex.home;
            screenView = const HomeScreen();
          });
          return false;
        } else {
          if (_isFirstBack) {
            Fluttertoast.showToast(
                msg: "Press again to exit",
                toastLength: Toast.LENGTH_SHORT,
                timeInSecForIosWeb: 1,
                fontSize: 16.0);
            _isFirstBack = false;
            await Future.delayed(const Duration(seconds: 1))
                .then((_) => _isFirstBack = true);
          } else {
            return true;
          }
          return false;
        }
      },
      child: Container(
        color: AppTheme.nearlyWhite,
        child: SafeArea(
          top: false,
          bottom: false,
          child: Scaffold(
            backgroundColor: AppTheme.nearlyWhite,
            body: DrawerUserController(
              event: widget.event,
              screenIndex: drawerIndex,
              drawerWidth: MediaQuery.of(context).size.width * 0.75,
              onDrawerCall: (DrawerIndex drawerIndexdata) {
                changeIndex(drawerIndexdata);
                //callback from drawer for replace screen as user need with passing DrawerIndex(Enum index)
              },
              screenView: screenView,
              //we replace screen view as we need on navigate starting screens like MyHomePage, HelpScreen, FeedbackScreen, etc...
            ),
          ),
        ),
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      switch (drawerIndex) {
        case DrawerIndex.home:
          {
            setState(() {
              screenView = const HomeScreen();
            });
            break;
          }
        case DrawerIndex.profile:
          {
            setState(() {
              screenView = const ProfileScreen();
            });
            break;
          }
        case DrawerIndex.myEvents:
          {
            setState(() {
              screenView = const MyEventsScreen();
            });
            break;
          }
        case DrawerIndex.hosted:
          {
            setState(() {
              screenView = const HostEventScreen();
            });
            break;
          }
        default:
          {
            break;
          }
      }
    }
  }
}
