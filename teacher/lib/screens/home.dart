import 'package:flutter/material.dart';
import 'package:teacher/data/global.dart';
import '../widgets/DashboardScreen/Approvals.dart';
import '../widgets/DashboardScreen/EventRequests.dart';
import '../widgets/DashboardScreen/homeScreen.dart';
import '../widgets/DashboardScreen/profile.dart';

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class HomePage extends StatefulWidget {
  final drawerItems = [
    DrawerItem("Home", Icons.home),
    DrawerItem("Approvals", Icons.approval_sharp),
    DrawerItem("Event Requests", Icons.request_page_outlined),
    DrawerItem("Profile", Icons.person_2),
  ];

  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int _selectedDrawerIndex = 0;

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 1:
        return Approvals();
      case 2:
        return EventRequests();
      case 0:
        return MyEventsScreen();
      case 3:
        return const ProfileScreen();

      default:
        return const Text("Error");
    }
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  @override
  Widget build(BuildContext context) {
    var drawerOptions = <Widget>[];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(
          ListTile(
            leading: Icon(d.icon),
            title: Text(d.title),
            selected: i == _selectedDrawerIndex,
            onTap: () => _onSelectItem(i),
          )
      );
    }

    return Scaffold(
      appBar: AppBar(
        // here we display the title corresponding to the fragment
        // you can instead choose to have a static title
        title: Text(widget.drawerItems[_selectedDrawerIndex].title),
      ),

      drawer: Drawer(

        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text((Global.userData?.name).toString()),
              accountEmail: Text((Global.userData?.email).toString()),
              currentAccountPicture: CircleAvatar(
                backgroundColor: const Color(0xFF800E13),
                child: CircleAvatar(
                  backgroundColor: const Color(0xFF800E13),
                  radius: 30,
                  child: Text(((Global.userData?.name).toString())[0]),
                ),
              ),
            ),
             Column(children: drawerOptions)
          ],
        ),
      ),

      body: _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }
}