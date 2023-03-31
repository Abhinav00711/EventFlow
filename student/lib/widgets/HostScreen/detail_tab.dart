import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../data/global.dart';
import './edit_details.dart';

class DetailTab extends StatefulWidget {
  const DetailTab({Key? key}) : super(key: key);

  @override
  State<DetailTab> createState() => _DetailTabState();
}

class _DetailTabState extends State<DetailTab> {
  @override
  Widget build(BuildContext context) {
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
              image: NetworkImage(Global.hostedEvent!.image ??
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
                        Global.hostedEvent!.name,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        const Icon(FontAwesomeIcons.buildingColumns),
                        const SizedBox(width: 8),
                        Text(
                          Global.hostedEvent!.interest,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        const Icon(FontAwesomeIcons.userGraduate),
                        const SizedBox(width: 8),
                        Text(
                          Global.hostedEvent!.graduate.toUpperCase() == 'BOTH'
                              ? 'UG / PG'
                              : Global.hostedEvent!.graduate.toUpperCase(),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today),
                        const SizedBox(width: 8),
                        Text(Global.hostedEvent!.start ==
                                Global.hostedEvent!.end
                            ? Global.hostedEvent!.start
                            : '${Global.hostedEvent!.start} - ${Global.hostedEvent!.end}'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      Global.hostedEvent!.description,
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
              onPressed: () {
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        builder: (context) => const EditDetails(),
                      ),
                    )
                    .then((value) => setState(() {}));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                shadowColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: const Text('EDIT'),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
