import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/event_detail.dart';
import '../models/event.dart';
import '../services/mysql_service.dart';
import './error_screen.dart';
import '../data/global.dart';

class EventDetailScreen extends StatefulWidget {
  final Event event;
  const EventDetailScreen({required this.event, Key? key}) : super(key: key);

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          'Event Details',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: FutureBuilder<EventDetail>(
          future:
              MySqlService().getEventDetail(widget.event, Global.userData!.sid),
          builder: (context, eventDetail) {
            if (eventDetail.hasError) {
              debugPrint(eventDetail.data.toString());
              return const ErrorScreen();
            } else if (eventDetail.hasData) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 250,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.all(15),
                      child: FadeInImage(
                        image: NetworkImage(eventDetail.data!.image ??
                            'https://firebasestorage.googleapis.com/v0/b/eventflow-23e7e.appspot.com/o/no_photo.png?alt=media&token=0ed5f538-2ec6-4907-8d1d-dee89bcdb641'),
                        placeholder: const AssetImage('assets/images/logo.png'),
                        width: MediaQuery.of(context).size.width * 0.7,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        color: Colors.amber,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Center(
                                child: Text(
                                  eventDetail.data!.name,
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: [
                                  const Icon(FontAwesomeIcons.buildingColumns),
                                  const SizedBox(width: 8),
                                  Text(
                                    eventDetail.data!.interest,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: [
                                  const Icon(FontAwesomeIcons.userGraduate),
                                  const SizedBox(width: 8),
                                  Text(
                                    eventDetail.data!.graduate.toUpperCase() ==
                                            'BOTH'
                                        ? 'UG / PG'
                                        : eventDetail.data!.graduate
                                            .toUpperCase(),
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: [
                                  const Icon(Icons.calendar_today),
                                  const SizedBox(width: 8),
                                  Text(eventDetail.data!.start ==
                                          eventDetail.data!.end
                                      ? eventDetail.data!.start
                                      : '${eventDetail.data!.start} - ${eventDetail.data!.end}'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                eventDetail.data!.description,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Student Coordinator',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.person),
                                      const SizedBox(width: 8),
                                      Text(eventDetail.data!.studName),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.phone),
                                      const SizedBox(width: 8),
                                      Text(eventDetail.data!.studPhone),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Teacher Coordinator',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.person),
                                      const SizedBox(width: 8),
                                      Text(eventDetail.data!.teacherName),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.phone),
                                      const SizedBox(width: 8),
                                      Text(eventDetail.data!.teacherPhone),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    eventDetail.data!.isParticipating ||
                            DateTime.now()
                                .isAfter(DateTime.parse(eventDetail.data!.end))
                        ? const SizedBox(height: 0)
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await MySqlService()
                                        .participate(widget.event.eid,
                                            Global.userData!.sid)
                                        .then((value) {
                                      setState(() {});
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 10),
                                    textStyle: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    shadowColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                  child: const Text('Participate'),
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                  ],
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
