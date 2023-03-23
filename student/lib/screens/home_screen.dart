import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

import '../data/global.dart';
import '../models/event.dart';
import '../services/mysql_service.dart';
import '../screens/event_request_screen.dart';

class HomeScreen extends StatefulWidget {
  final Event? event;
  const HomeScreen({required this.event, super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isFirstBack = true;
  Event? _isHosting;

  @override
  void initState() {
    _isHosting = widget.event;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
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
      },
      child: Scaffold(
        body: const Center(
          child: Text('loggedin'),
        ),
        floatingActionButton: _isHosting != null
            ? null
            : FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EventRequestScreen()))
                      .then((_) async {
                    var check =
                        await MySqlService().isHosting(Global.userData!.sid);
                    setState(() {
                      _isHosting = check;
                    });
                  });
                },
                backgroundColor: Colors.amber,
                child: const Icon(
                  Icons.event,
                  color: Colors.black,
                ),
              ),
      ),
    );
  }
}
