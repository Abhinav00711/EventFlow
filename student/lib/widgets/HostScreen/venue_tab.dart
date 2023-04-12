import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../LoginScreen/decoration_functions.dart';
import '../../models/booking.dart';
import '../../services/mysql_service.dart';
import '../../data/global.dart';
import '../../models/venue.dart';

class VenueTab extends StatefulWidget {
  static final _formKey = GlobalKey<FormState>();
  const VenueTab({super.key});

  @override
  State<VenueTab> createState() => _VenueTabState();
}

class _VenueTabState extends State<VenueTab> {
  TextEditingController bookDate = TextEditingController();
  TextEditingController startTime = TextEditingController();
  TextEditingController endTime = TextEditingController();
  String capacity = '';
  bool isConfirming = false;

  List<Booking> eventBookings = [];
  List<Venue> venues = [];

  @override
  void initState() {
    bookDate.text = '';
    startTime.text = '';
    endTime.text = '';
    super.initState();
  }

  void _showBottomSheet(Widget content) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            color: const Color.fromRGBO(0, 0, 0, 0.001),
            child: GestureDetector(
              onTap: () {},
              child: content,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: VenueTab._formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextFormField(
                controller: bookDate,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
                decoration: registerInputDecoration(
                  hintText: 'Booking Date',
                  icon: FontAwesomeIcons.hourglassStart,
                  color: Colors.black,
                ),
                readOnly: true,
                keyboardType: TextInputType.datetime,
                autocorrect: false,
                cursorColor: Colors.black,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2050),
                  );
                  if (picked != null) {
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(picked);
                    setState(() {
                      bookDate.text = formattedDate;
                    });
                  }
                },
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return 'Please enter date.';
                  } else {
                    return null;
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextFormField(
                controller: startTime,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
                decoration: registerInputDecoration(
                  hintText: 'Start Time',
                  icon: FontAwesomeIcons.hourglassStart,
                  color: Colors.black,
                ),
                readOnly: true,
                keyboardType: TextInputType.datetime,
                autocorrect: false,
                cursorColor: Colors.black,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onTap: () async {
                  final TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    String formattedDate =
                        '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';
                    setState(() {
                      startTime.text = formattedDate;
                    });
                  }
                },
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return 'Please enter start time.';
                  } else {
                    return null;
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextFormField(
                controller: endTime,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
                decoration: registerInputDecoration(
                  hintText: 'End Time',
                  icon: FontAwesomeIcons.hourglassEnd,
                  color: Colors.black,
                ),
                readOnly: true,
                keyboardType: TextInputType.datetime,
                autocorrect: false,
                cursorColor: Colors.black,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onTap: () async {
                  final TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: startTime.text.isEmpty
                        ? TimeOfDay.now()
                        : TimeOfDay(
                            hour: int.parse(startTime.text.split(":")[0]),
                            minute: int.parse(startTime.text.split(":")[1])),
                  );
                  if (pickedTime != null) {
                    String formattedDate =
                        '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';
                    setState(() {
                      endTime.text = formattedDate;
                    });
                  }
                },
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return 'Please enter end time.';
                  } else {
                    return null;
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextFormField(
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
                decoration: registerInputDecoration(
                  hintText: 'Venue Capacity',
                  icon: FontAwesomeIcons.users,
                  color: Colors.black,
                ),
                keyboardType: TextInputType.phone,
                autocorrect: false,
                cursorColor: Colors.black,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return 'Please enter venue capacity.';
                  } else {
                    return null;
                  }
                },
                onSaved: (newValue) {
                  capacity = newValue!.trim();
                },
              ),
            ),
            const SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (VenueTab._formKey.currentState!.validate()) {
                    setState(() {
                      isConfirming = true;
                    });
                    VenueTab._formKey.currentState!.save();
                    venues = await MySqlService().getAvailableVenues(
                      bookDate.text,
                      startTime.text,
                      endTime.text,
                      int.parse(capacity),
                    );
                    _showBottomSheet(DraggableScrollableSheet(
                      initialChildSize: 0.4,
                      minChildSize: 0.25,
                      maxChildSize: 0.75,
                      builder: (_, controller) {
                        return Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25.0),
                              topRight: Radius.circular(25.0),
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.remove,
                                color: Colors.grey[600],
                              ),
                              const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  'Select Venue',
                                  style: TextStyle(fontSize: 20.0),
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  controller: controller,
                                  itemCount: venues.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(height: 16.0),
                                        const Divider(
                                          color: Colors.grey,
                                          height: 5,
                                          thickness: 1,
                                          indent: 5,
                                          endIndent: 5,
                                        ),
                                        const SizedBox(height: 16.0),
                                        ListTile(
                                          title: Text(venues[index].name),
                                          subtitle: Text(
                                              '${venues[index].loc}\n${venues[index].cap.toString()}'),
                                          trailing: ElevatedButton(
                                            onPressed: () async {
                                              final bid = const Uuid()
                                                  .v1()
                                                  .replaceAll('-', '')
                                                  .substring(0, 10);
                                              Booking booking = Booking(
                                                bid: bid,
                                                vid: venues[index].vid,
                                                eid: Global.hostedEvent!.eid,
                                                date: bookDate.text,
                                                start: startTime.text,
                                                end: endTime.text,
                                              );
                                              await MySqlService()
                                                  .addBooking(booking)
                                                  .then((value) {
                                                if (value == 1) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          'Venue booked successfully.'),
                                                    ),
                                                  );
                                                  bookDate.text = '';
                                                  startTime.text = '';
                                                  endTime.text = '';
                                                  Navigator.pop(context);
                                                  setState(() {});
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          'Booking failed.'),
                                                    ),
                                                  );
                                                }
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.amber,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 30,
                                                      vertical: 10),
                                              textStyle: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              shadowColor: Colors.amberAccent,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                              ),
                                            ),
                                            child: const Text(
                                              'Book',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF213333),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ));
                    setState(() {
                      isConfirming = false;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  shadowColor: Colors.amberAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: isConfirming
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Color(0xff092E34),
                        ),
                      )
                    : const Text(
                        'Select Venue',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF213333),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _showBottomSheet(DraggableScrollableSheet(
                    initialChildSize: 0.4,
                    minChildSize: 0.25,
                    maxChildSize: 0.75,
                    builder: (_, controller) {
                      return Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25.0),
                            topRight: Radius.circular(25.0),
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.remove,
                              color: Colors.grey[600],
                            ),
                            const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                'Event Bookings',
                                style: TextStyle(fontSize: 20.0),
                              ),
                            ),
                            Expanded(
                              child: FutureBuilder<List<Booking>>(
                                future: MySqlService()
                                    .getEventBookings(Global.hostedEvent!.eid),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return Center(
                                      child: Text(snapshot.error.toString()),
                                    );
                                  } else if (snapshot.hasData) {
                                    eventBookings = snapshot.data!;
                                    return ListView.builder(
                                      controller: controller,
                                      itemCount: eventBookings.length,
                                      itemBuilder: (context, index) {
                                        Booking booking = eventBookings[index];
                                        return FutureBuilder<Venue?>(
                                          future: MySqlService()
                                              .getVenue(booking.vid),
                                          builder: (context, s) {
                                            if (s.hasError) {
                                              return Center(
                                                child: Text(s.error.toString()),
                                              );
                                            } else if (s.hasData) {
                                              Venue venue = s.data!;
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Card(
                                                  margin: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10),
                                                  color: Colors.amber,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            'Venue : ${venue.name}',
                                                            style: const TextStyle(
                                                                fontSize: 18.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        const SizedBox(
                                                            height: 8.0),
                                                        Text(
                                                            'Date: ${booking.date}'),
                                                        const SizedBox(
                                                            height: 8.0),
                                                        Text(
                                                            'Time: ${booking.start} - ${booking.end}'),
                                                        const SizedBox(
                                                            height: 8.0),
                                                        Text(
                                                            'Capacity: ${venue.cap}'),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                ),
                                              );
                                            }
                                          },
                                        );
                                      },
                                    );
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  shadowColor: Colors.amberAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text(
                  'Event Bookings',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF213333),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
