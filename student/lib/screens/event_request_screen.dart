import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/LoginScreen/decoration_functions.dart';
import '../data/global.dart';
import '../models/event.dart';
import '../services/mysql_service.dart';
import '../services/firebase_storage_service.dart';

class EventRequestScreen extends StatefulWidget {
  static final _formKey = GlobalKey<FormState>();
  const EventRequestScreen({super.key});

  @override
  State<EventRequestScreen> createState() => _EventRequestScreenState();
}

class _EventRequestScreenState extends State<EventRequestScreen> {
  TextEditingController startDate = TextEditingController();
  TextEditingController endDate = TextEditingController();
  List<String> _interests = [];
  List<String> _graduates = [];
  String _eventName = '';
  String _eventInterest = 'Computer Science';
  String _description = '';
  String _graduate = 'Both';
  String? _imageUrl;
  bool isConfirming = false;
  XFile? _image;

  @override
  void initState() {
    startDate.text = '';
    endDate.text = '';
    _interests = [
      'Computer Science',
      'Law',
      'Statistics',
      'Commerce',
      'Humanities',
      'Science'
    ];
    _graduates = ['Both', 'Postgraduate', 'Undergraduate'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        title: const Text(
          'EVENT REQUEST',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: EventRequestScreen._formKey,
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextFormField(
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                      decoration: registerInputDecoration(
                        hintText: 'Event Name',
                        icon: FontAwesomeIcons.bookOpenReader,
                      ),
                      keyboardType: TextInputType.name,
                      autocorrect: false,
                      cursorColor: Colors.white,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return 'Please enter event name.';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (newValue) {
                        _eventName = newValue!.trim();
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    foregroundDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      border: Border.all(
                        color: const Color(0xff092E34),
                        width: 2.0,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      horizontalTitleGap: 0,
                      leading: _eventInterest.isEmpty
                          ? const Icon(
                              FontAwesomeIcons.envelope,
                              color: Colors.black,
                            )
                          : const Icon(
                              FontAwesomeIcons.envelopeOpen,
                              color: Colors.black,
                            ),
                      title: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          menuMaxHeight:
                              MediaQuery.of(context).size.height * 0.4,
                          icon: const Icon(
                            Icons.arrow_drop_down_circle,
                            color: Colors.black,
                          ),
                          hint: const Text('Interest'),
                          value: _eventInterest,
                          isExpanded: true,
                          items: _interests.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (_eventInterest != value) {
                              setState(() {
                                _eventInterest = value!;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    foregroundDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      border: Border.all(
                        color: const Color(0xff092E34),
                        width: 2.0,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      horizontalTitleGap: 0,
                      leading: _graduate.isEmpty
                          ? const Icon(
                              FontAwesomeIcons.envelope,
                              color: Colors.black,
                            )
                          : const Icon(
                              FontAwesomeIcons.envelopeOpen,
                              color: Colors.black,
                            ),
                      title: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          menuMaxHeight:
                              MediaQuery.of(context).size.height * 0.4,
                          icon: const Icon(
                            Icons.arrow_drop_down_circle,
                            color: Colors.black,
                          ),
                          hint: const Text('Graduate'),
                          value: _graduate,
                          isExpanded: true,
                          items: _graduates.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (_graduate != value) {
                              setState(() {
                                _graduate = value!;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextFormField(
                      controller: startDate,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                      decoration: registerInputDecoration(
                        hintText: 'Start Date',
                        icon: FontAwesomeIcons.hourglassStart,
                      ),
                      readOnly: true,
                      keyboardType: TextInputType.datetime,
                      autocorrect: false,
                      cursorColor: Colors.white,
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
                            startDate.text = formattedDate;
                          });
                        }
                      },
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return 'Please enter start date.';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextFormField(
                      controller: endDate,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                      decoration: registerInputDecoration(
                        hintText: 'End Date',
                        icon: FontAwesomeIcons.hourglassEnd,
                      ),
                      readOnly: true,
                      keyboardType: TextInputType.datetime,
                      autocorrect: false,
                      cursorColor: Colors.white,
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
                            endDate.text = formattedDate;
                          });
                        }
                      },
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return 'Please enter end date.';
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
                        color: Colors.white,
                      ),
                      decoration: registerInputDecoration(
                        hintText: 'Event Description',
                        icon: FontAwesomeIcons.bars,
                      ),
                      maxLength: 250,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      minLines: 1,
                      maxLines: 6,
                      keyboardType: TextInputType.multiline,
                      autocorrect: false,
                      cursorColor: Colors.white,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return 'Please enter event description.';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (newValue) {
                        _description = newValue!.trim();
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Center(
                      child: _image == null
                          ? ElevatedButton(
                              onPressed: () async {
                                _image = await ImagePicker()
                                    .pickImage(source: ImageSource.gallery);
                                setState(() {
                                  _image = _image;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 10),
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
                                      'Upload Event Banner',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF213333),
                                      ),
                                    ),
                            )
                          : ListTile(
                              leading: const Icon(
                                FontAwesomeIcons.image,
                                color: Colors.black,
                              ),
                              title: Text(
                                _image!.path.split('/').last,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _image = null;
                                  });
                                },
                                icon: const Icon(
                                  FontAwesomeIcons.trash,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 20),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            isConfirming = true;
                          });
                          if (EventRequestScreen._formKey.currentState!
                              .validate()) {
                            EventRequestScreen._formKey.currentState!.save();
                            final eid = const Uuid()
                                .v1()
                                .replaceAll('-', '')
                                .substring(0, 10);
                            if (_image != null) {
                              await FirebaseStorageService()
                                  .uploadEventBanner(
                                      eid, _image!.name, _image!.path)
                                  .then((value) {
                                _imageUrl = value;
                              });
                            }
                            Event event = Event(
                                eid: eid,
                                sid: Global.userData!.sid,
                                tid: null,
                                name: _eventName,
                                interest: _eventInterest,
                                start: startDate.text,
                                end: endDate.text,
                                description: _description,
                                status: 'PENDING',
                                graduate: _graduate,
                                image: _imageUrl);
                            await MySqlService()
                                .requestEvent(event)
                                .then((value) {
                              if (value == 1) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Event requested successfully.'),
                                  ),
                                );
                                Navigator.pop(context);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Event request failed.'),
                                  ),
                                );
                              }
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
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
                                'REQUEST EVENT',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF213333),
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
