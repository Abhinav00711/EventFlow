import 'package:flutter/material.dart';
import 'package:teacher/data/global.dart';
import 'package:teacher/services/mysql_service.dart';
import '../../models/event.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

import 'action_button_widget.dart';

class MyEventsScreen extends StatefulWidget {
  const MyEventsScreen({super.key});

  @override
  _MyEventsScreenState createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen> {
  List<Event> _events = [];

  @override
  void initState() {
    super.initState();
    MySqlService().getPendingEvents().then((events) {
      setState(() {
        _events = events;
      });
    });
  }

  void _dismissCard(Event event) {
    // TODO: Implement reject event logic
    setState(() {
    });
  }

  void _acceptCard(Event event) {
    // TODO: Implement accept event logic
    setState(() {
      MySqlService().updateTeacherIdEvent(event, Global.userData?.tid);
    });
  }
  void onDismissed(BuildContext context, DismissDirection direction, Event event) {
    if (direction == DismissDirection.endToStart) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Reject/Ignore Event'),
            content: const Text('Are you sure you want to ignore this event?'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Reject'),
                onPressed: () {
                  _dismissCard(event);
                  _events.remove(event);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else if (direction == DismissDirection.startToEnd) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Accept Event'),
            content: const Text('Are you sure you want to be in charge of this event?'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Accept'),
                onPressed: () {
                  _acceptCard(event);
                  _events.remove(event);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    if (_events.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          iconTheme: const IconThemeData(color: Colors.red),
          centerTitle: true,
          title: const Text(
            'Discover Events',
            style: TextStyle(
              color: Colors.white,
            ),
          )
      ),
      body: Stack(
        children: _events
            .asMap()
            .entries
            .map(
              (entry) => _buildDismissibleCard(
            entry.value,
            _dismissCard,
            _acceptCard,
          ),
        )
            .toList(),
      ),
    );
  }

  Widget _buildDismissibleCard(
      Event event,
      Function(Event) onDismissed,
      Function(Event) onAccepted,
      ) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.horizontal,
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Reject Event'),
                content: const Text('Are you sure you want to ignore this event?'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('Reject'),
                    onPressed: () {
                      _dismissCard(event);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else if (direction == DismissDirection.startToEnd) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Accept Event'),
                content: const Text('Are you sure you want to be in charge of this event?'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('Accept'),
                    onPressed: () {
                      _acceptCard(event);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      },
      child: Card(
        color: const Color(0xffffffff),
        elevation: 50.0,
        margin: const EdgeInsets.all(15.0),
        child: Padding(
          padding: const EdgeInsets.all(5.8),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            event.image == null?
            Image.asset(
              'assets/images/comp.jpg',
              fit: BoxFit.cover,
              height: 300.0,
            ):Image.network(
        event.image ?? '',
        fit: BoxFit.cover,
        height: 300.0,
        ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.name,
                    style: GoogleFonts.bebasNeue(
                        fontSize: 40,
                        color: const Color(0xFF410909),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 20.0, color: Color(0xff181818)),
                      const SizedBox(width: 8.0),
                      Text(
                        '${DateFormat('MMM dd, yyyy').format(DateTime.parse(event.start))} - ${DateFormat('MMM dd, yyyy').format(DateTime.parse(event.end))}',
                        style: const TextStyle(
                            color: Color(0xff181818),
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      const Icon(Icons.person, size: 16.0, color: Color(0xff181818)),
                      const SizedBox(width: 8.0),
                      Text(
                        'Organizer: ${event.sid}',
                        style: const TextStyle(
                            color: Color(0xff181818),
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      const Icon(Icons.business, size: 16.0, color: Color(0xff181818)),
                      const SizedBox(width: 8.0),
                      Text(
                        'Department: ${event.interest} | ${event.graduate}',
                        style: const TextStyle(
                            color: Color(0xff181818),
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),

                  Text(
                    event.description,
                    textAlign: TextAlign.justify,
                    style: GoogleFonts.poppins(
                        color: Colors.black,

                    ),
                  ),

                ],
              ),
            ),
              Padding(
                padding: const EdgeInsets.all(16.0),
              child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:const [
                    ActionButtonWidget(
                      icon: Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(width: 20),
                    ActionButtonWidget(
                      icon: Icon(
                        Icons.close,
                        color: Colors.grey,
                      ),
                    ),
                    ],
                  ),
    ),
          ],
            ),
        ),
      ),
    );
  }
}
