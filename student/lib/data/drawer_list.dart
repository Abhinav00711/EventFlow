import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/drawer_item.dart';
import '../models/event.dart';

class DrawerList {
  Event? event;
  final List<DrawerItem> _items = [
    DrawerItem(
      index: DrawerIndex.home,
      labelName: 'Home',
      icon: const Icon(Icons.home),
    ),
    DrawerItem(
      index: DrawerIndex.profile,
      labelName: 'Profile',
      icon: const Icon(FontAwesomeIcons.solidUser),
    ),
    DrawerItem(
      index: DrawerIndex.myEvents,
      labelName: 'My Events',
      icon: const Icon(FontAwesomeIcons.calendarDays),
    ),
  ];

  DrawerList(this.event);

  List<DrawerItem> get items {
    var a = [..._items];
    if (event == null || event!.status == 'COMPLETED') {
      return a;
    }
    a.add(DrawerItem(
      index: DrawerIndex.hosted,
      labelName: event!.name,
      icon: const Icon(FontAwesomeIcons.sitemap),
    ));
    return a;
  }
}
