import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

import '../data/global.dart';
import '../models/event.dart';
import '../services/mysql_service.dart';
import '../screens/event_request_screen.dart';
import '../widgets/HomeScreen/event_card.dart';
import './event_detail_screen.dart';

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
    late List<Event> ongoingEvents;
    late List<Event> completedEvents;
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
      child: DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            iconTheme: const IconThemeData(color: Colors.white),
            centerTitle: true,
            title: const Text(
              'Events',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            bottom: const TabBar(
              indicatorColor: Colors.amber,
              tabs: [
                Tab(
                  text: 'Ongoing',
                ),
                Tab(
                  text: 'Completed',
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              FutureBuilder<List<Event>>(
                future: MySqlService().getOngoingEvents(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  } else if (snapshot.hasData) {
                    ongoingEvents = snapshot.data!;
                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: NotificationListener<
                              OverscrollIndicatorNotification>(
                            onNotification: (overScroll) {
                              overScroll.disallowIndicator();
                              return false;
                            },
                            child: ListView.builder(
                              itemCount: ongoingEvents.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EventDetailScreen(
                                                event: ongoingEvents[index],
                                              )),
                                    );
                                  },
                                  child: EventCard(event: ongoingEvents[index]),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    );
                  }
                },
              ),
              FutureBuilder<List<Event>>(
                future: MySqlService().getCompletedEvents(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  } else if (snapshot.hasData) {
                    completedEvents = snapshot.data!;
                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: NotificationListener<
                              OverscrollIndicatorNotification>(
                            onNotification: (overScroll) {
                              overScroll.disallowIndicator();
                              return false;
                            },
                            child: ListView.builder(
                              itemCount: completedEvents.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EventDetailScreen(
                                                event: completedEvents[index],
                                              )),
                                    );
                                  },
                                  child:
                                      EventCard(event: completedEvents[index]),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
          floatingActionButton: _isHosting != null
              ? null
              : FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const EventRequestScreen())).then((_) async {
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
      ),
    );
  }
}
