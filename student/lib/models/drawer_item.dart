import 'package:flutter/material.dart';

enum DrawerIndex {
  home,
  profile,
  myEvents,
}

class DrawerItem {
  DrawerItem({
    this.isAssetsImage = false,
    this.labelName = '',
    this.icon,
    required this.index,
    this.imageName = '',
  });

  String labelName;
  Icon? icon;
  bool isAssetsImage;
  String imageName;
  DrawerIndex index;
}
