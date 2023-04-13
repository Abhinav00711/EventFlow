import 'package:flutter/material.dart';
import 'package:teacher/models/approval.dart';


class EventCard extends StatefulWidget {
  final Approval approval;

  const EventCard({
    super.key,
    required this.approval,
  });

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('${widget.approval.eventname} | ${widget.approval.type}'),
            subtitle: Text('${widget.approval.status}'),
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('${widget.approval.description}'),
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
    );
  }
}
