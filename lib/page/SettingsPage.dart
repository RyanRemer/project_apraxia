import 'package:flutter/material.dart';
import 'package:project_apraxia/widget/form/InvalidateWaiverForm.dart';
import 'package:project_apraxia/widget/form/UpdateUserForm.dart';
import 'package:project_apraxia/controller/Auth.dart';

class SettingsPage extends StatelessWidget {
  final bool isLoggedIn = Auth.instance().isLoggedIn();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: isLoggedIn ? 3 : 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
          bottom: TabBar(
            tabs: _buildTabBar(isLoggedIn)
          ),
        ),
        body: TabBarView(
          children: _buildTabBarView(isLoggedIn)
        ),
      ),
    );
  }

  List<Widget> _buildTabBar(bool isLoggedIn) {
    if (isLoggedIn) {
      return <Widget> [
        Tab(child: Text("Account")),
        Tab(child: Text("Prompts")),
        Tab(child: Text("Waivers"))
      ];
    }
    else {
      return <Widget> [
        Tab(child: Text("Prompts")),
      ];
    }
  }

  List<Widget> _buildTabBarView(bool isLoggedIn) {
    if (isLoggedIn) {
      return [
        UpdateUserForm(),
        Container(),
        Padding(
          padding: EdgeInsets.all(32.0),
          child: InvalidateWaiverForm()
        )
      ];
    }
    else {
      return [
        Container(),
      ];
    }
  }
}
