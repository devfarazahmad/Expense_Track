import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Profile"),
            subtitle: Text("Manage your profile"),
          ),
          ListTile(
            leading: Icon(Icons.palette),
            title: Text("Theme"),
            subtitle: Text("Light / Dark mode"),
          ),
          ListTile(
            leading: Icon(Icons.backup),
            title: Text("Backup"),
            subtitle: Text("Export or Import Data"),
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text("About"),
            subtitle: Text("Version 1.0.0"),
          ),
        ],
      ),
    );
  }
}

