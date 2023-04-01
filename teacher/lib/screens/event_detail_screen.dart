import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:teacher/models/approval.dart';

import '../models/event.dart';
import '../services/mysql_service.dart';
import './error_screen.dart';
import '../data/global.dart';

class EventDetailScreen extends StatefulWidget {
  final Approval approval;
  const EventDetailScreen({required this.approval, Key? key}) : super(key: key);

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
          'Approval Details',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 250,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.all(15),
                      child: FadeInImage(
                        image: NetworkImage(widget.approval.attatchment ??
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
                                  '${widget.approval.eventname} | ${widget.approval.type}',
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                '${widget.approval.description}',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                    onPressed: () async {
                    await MySqlService().approveProposol(widget.approval.aid).then((value) {
                    setState(() {});
                    });
                    Fluttertoast.showToast(
                        msg: "Approved",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                    Navigator.of(context).pop();
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
                    child: const Text('Approve'),
                    ),
                  ),
                  ],
                ),
                ),
              );
            }
  }
