import 'package:flutter/material.dart';
import 'package:teacher/models/approval.dart';


import '../../screens/event_detail_screen.dart';
import '../../services/mysql_service.dart';
import 'event_card.dart';

class Approvals extends StatefulWidget {
  const Approvals({super.key});

  @override
  State<Approvals> createState() => _ApprovalsState();
}

class _ApprovalsState extends State<Approvals> {
  bool _isFirstBack = true;

  @override
  Widget build(BuildContext context) {
    late List<Approval> approvals;
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
          iconTheme: const IconThemeData(color: Colors.red),
          centerTitle: true,
          title: const Text(
            'Pending Approvals',
            style: TextStyle(
            color: Colors.white,
            ),
            )
          ),
      body: FutureBuilder<List<Approval>>(
        future: MySqlService().getApprovals(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return Center(

              child: Text(snapshot.error.toString()),
            );
          } else if (snapshot.hasData) {
            approvals = snapshot.data!;
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
                      itemCount: approvals.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EventDetailScreen(
                                        approval: approvals[index],
                                      )),
                            );
                          },
                          child: EventCard(approval: approvals[index]),
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
    );
  }

}