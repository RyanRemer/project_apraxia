import 'package:flutter/material.dart';
import 'package:project_apraxia/widget/form/InvalidateWaiverForm.dart';

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
              Tab(child: Text("Account")),
              Tab(child: Text("Prompts")),
              Tab(child: Text("Waivers"))
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            UpdateUserForm(),
            Container(),
            InvalidateWaiverForm()
          ],
        ),
      ),
    );
  }
}
