import 'package:flutter/material.dart';

import '../widgets/HostScreen/detail_tab.dart';
import '../widgets/HostScreen/approval_tab.dart';
import '../widgets/HostScreen/venue_tab.dart';

class HostEventScreen extends StatelessWidget {
  const HostEventScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          title: const Text(
            'Event Name',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.amber,
            tabs: [
              Tab(text: 'Details'),
              Tab(text: 'Approval'),
              Tab(text: 'Venue'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            DetailTab(),
            ApprovalTab(),
            VenueTab(),
          ],
        ),
      ),
    );
  }
}
