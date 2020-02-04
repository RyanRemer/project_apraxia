import 'package:flutter/material.dart';

import 'package:project_apraxia/widget/form/UpdateUserForm.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
          bottom: TabBar(
            tabs: <Widget>[
              Text("Account"),
              Text("Prompts"),
              Text("Waivers")
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            UpdateUserForm(),
            Container(),
            Container()
          ],
        ),
      ),
    );
  }
}
