import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:file_picker/file_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../models/approval.dart';
import '../LoginScreen/decoration_functions.dart';
import '../../data/global.dart';
import '../../services/mysql_service.dart';
import '../../services/firebase_storage_service.dart';

class ApprovalTab extends StatefulWidget {
  static final _formKey = GlobalKey<FormState>();
  const ApprovalTab({super.key});

  @override
  State<ApprovalTab> createState() => _ApprovalTabState();
}

class _ApprovalTabState extends State<ApprovalTab> {
  List<String> _types = [];
  String _type = 'DESIGN';
  String? _fileUrl;
  bool isConfirming = false;
  FilePickerResult? _filePickerResult;
  File? _file;
  final TextEditingController _desc = TextEditingController();

  List<Approval> eventApprovals = [];

  @override
  void initState() {
    _desc.text = '';
    _types = ['DESIGN', 'DOCUMENT'];
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
    return Form(
      key: ApprovalTab._formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
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
                      leading: _type.isEmpty
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
                          hint: const Text('Approval Type'),
                          value: _type,
                          isExpanded: true,
                          items: _types.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (_type != value) {
                              setState(() {
                                _type = value!;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextFormField(
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                    controller: _desc,
                    decoration: registerInputDecoration(
                      hintText: 'Approval Description',
                      icon: FontAwesomeIcons.bars,
                      color: Colors.black,
                    ),
                    maxLength: 250,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    minLines: 1,
                    maxLines: 6,
                    keyboardType: TextInputType.multiline,
                    autocorrect: false,
                    cursorColor: Colors.black,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return 'Please enter approval description.';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (newValue) {
                      _desc.text = newValue!.trim();
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Center(
                    child: _file == null
                        ? ElevatedButton(
                            onPressed: () async {
                              _filePickerResult =
                                  await FilePicker.platform.pickFiles();
                              if (_filePickerResult != null) {
                                _file =
                                    File(_filePickerResult!.files.single.path!);
                              }
                              setState(() {
                                _file = _file;
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
                                    'Upload Attatchment',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF213333),
                                    ),
                                  ),
                          )
                        : ListTile(
                            leading: const Icon(
                              FontAwesomeIcons.file,
                              color: Colors.black,
                            ),
                            title: Text(
                              _file!.path.split('/').last,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                setState(() {
                                  _file = null;
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
                const SizedBox(height: 8.0),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isConfirming = true;
                    });
                    if (ApprovalTab._formKey.currentState!.validate()) {
                      ApprovalTab._formKey.currentState!.save();
                      final aid = const Uuid()
                          .v1()
                          .replaceAll('-', '')
                          .substring(0, 10);
                      if (_file != null) {
                        await FirebaseStorageService()
                            .uploadEventApproval(
                                Global.hostedEvent!.eid, aid, _file!.path)
                            .then((value) {
                          _fileUrl = value;
                        });
                      }
                      Approval approval = Approval(
                        aid: aid,
                        eid: Global.hostedEvent!.eid,
                        status: 'PENDING',
                        type: _type,
                        description: _desc.text,
                        attatchment: _fileUrl,
                        comment: null,
                      );
                      await MySqlService()
                          .requestApproval(approval)
                          .then((value) {
                        if (value == 1) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Approval requested successfully.'),
                            ),
                          );
                          setState(() {
                            isConfirming = false;
                            _desc.text = '';
                            _file = null;
                            _type = 'DESIGN';
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Approval request failed.'),
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
                          'Request Approval',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF213333),
                          ),
                        ),
                ),
              ],
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
                                'My Approvals',
                                style: TextStyle(fontSize: 20.0),
                              ),
                            ),
                            Expanded(
                              child: FutureBuilder<List<Approval>>(
                                future: MySqlService()
                                    .getEventApprovals(Global.hostedEvent!.eid),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return Center(
                                      child: Text(snapshot.error.toString()),
                                    );
                                  } else if (snapshot.hasData) {
                                    eventApprovals = snapshot.data!;
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: eventApprovals.length,
                                          itemBuilder: (context, index) {
                                            Approval approval =
                                                eventApprovals[index];
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Card(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                color: Colors.amber,
                                                child: InkWell(
                                                  onTap: () {
                                                    if (approval.status ==
                                                            'REJECTED' &&
                                                        approval.comment !=
                                                            null) {
                                                      showModalBottomSheet(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return SizedBox(
                                                            height: 300.0,
                                                            child: Column(
                                                              children: [
                                                                const Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              16.0),
                                                                  child: Text(
                                                                    'Rejection Comments',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            20.0),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                    child: Text(
                                                                        approval
                                                                            .comment!)),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    }
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(approval.type,
                                                            style: const TextStyle(
                                                                fontSize: 18.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        const SizedBox(
                                                            height: 8.0),
                                                        Text(approval
                                                            .description),
                                                        const SizedBox(
                                                            height: 8.0),
                                                        Text(
                                                            approval.status
                                                                .toUpperCase(),
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
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
                  'My Approvals',
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
