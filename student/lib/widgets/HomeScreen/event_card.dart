import 'package:flutter/material.dart';

import '../../models/event.dart';

class EventCard extends StatefulWidget {
  final Event event;

  const EventCard({
    super.key,
    required this.event,
  });

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Colors.white70,
        elevation: 4.0,
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(widget.event.name),
              subtitle:
                  Text('From: ${widget.event.start}\nTo: ${widget.event.end}'),
              trailing: Text(
                  '${widget.event.interest}\n${widget.event.graduate.toUpperCase()}'),
            ),
            if (_isExpanded)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(widget.event.description),
              ),
            InkWell(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _isExpanded ? 'Hide Details' : 'Show Details',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
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
