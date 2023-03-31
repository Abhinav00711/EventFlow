import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/drawer_item.dart';
import '../data/global.dart';

class DrawerList {
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

  DrawerList();

  List<DrawerItem> get items {
    var a = [..._items];
    if (Global.hostedEvent == null ||
        Global.hostedEvent!.status == 'COMPLETED') {
      return a;
    }
    a.add(DrawerItem(
      index: DrawerIndex.hosted,
      labelName: Global.hostedEvent!.name,
      icon: const Icon(FontAwesomeIcons.sitemap),
    ));
    return a;
  }
}
