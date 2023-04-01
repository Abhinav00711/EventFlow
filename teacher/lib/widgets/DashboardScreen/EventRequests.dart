import 'package:flutter/material.dart';
import 'package:teacher/data/global.dart';
import 'package:teacher/services/mysql_service.dart';
import '../../models/event.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

import 'action_button_widget.dart';

class EventRequests extends StatefulWidget {
  const EventRequests({super.key});

  @override
  _EventRequestsState createState() => _EventRequestsState();
}

class _EventRequestsState extends State<EventRequests> {
  List<Event> _events = [];

  @override
  void initState() {
    super.initState();
    MySqlService().getAllTeacherEvents().then((events) {
      setState(() {
        _events = events;
      });
    });
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
            'My Events',
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
          ),
        )
            .toList(),
      ),
    );
  }

  Widget _buildDismissibleCard(
      Event event,
      ) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.horizontal,
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
                'assets/images/comp.jpg' ?? '',
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
            ],
          ),
        ),
      ),
      // ),
      /*child: Padding(
        padding: EdgeInsets.only(left: 36.0),
        child: Container(
          height: 580,
          width: 340,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Stack(
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset('assets/images/download.jpeg',
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  height: 80,
                  width: 340,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shadows: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          event.name,
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w800,
                            fontSize: 21,
                          ),
                        ),
                        Text(
                          event.description,
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
    ),*/
      /*  background: Container(
        color: Colors.red,
        child: Icon(Icons.close, color: Colors.white),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 16),
      ),
      secondaryBackground: Container(
        color: Colors.green,
        child: Icon(Icons.check, color: Colors.white),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 16),
      ),*/
      //  onSecondaryTap: () => onAccepted(event),
    );
  }
}
