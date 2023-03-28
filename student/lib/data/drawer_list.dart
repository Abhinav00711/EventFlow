import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/drawer_item.dart';

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
  ];

  List<DrawerItem> get items {
    return [..._items];
  }
}
