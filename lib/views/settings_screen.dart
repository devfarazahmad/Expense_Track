
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_expense/theme/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        children: [
          const ListTile(
            leading: Icon(Icons.person),
            title: Text("Profile"),
            subtitle: Text("Manage your profile"),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.palette),
            title: const Text("Theme"),
            subtitle:
                Text(themeProvider.isDarkMode ? "Dark Mode" : "Light Mode"),
            value: themeProvider.isDarkMode,
            onChanged: (value) {
              themeProvider.toggleTheme(); 
            },
          ),
         
           const ListTile(
            leading: Icon(Icons.subscriptions),
            title: Text("Manage Subscription"),
            subtitle: Text("Manage your subscription plan"),
          ),
           const ListTile(
            leading: Icon(Icons.history),
            title: Text("Rstore Purchases"),
            subtitle: Text("Restore your previous purchases"),
          ),
           const ListTile(
            leading: Icon(Icons.cached),
            title: Text("Manage Subscription"),
            subtitle: Text("Manage your subscription plan"),
          ),
            const ListTile(
            leading: Icon(Icons.rate_review),
            title: Text("Write a Review"),
            subtitle: Text("Rate us on the App Store"),
          ),
            const ListTile(
            leading: Icon(Icons.share),
            title: Text("Share the App"),
            subtitle: Text("Tell your friends about us"),
          ),
            const ListTile(
            leading: Icon(Icons.support_agent),
            title: Text("Support"),
            subtitle: Text("Get help with your account"),
          ),
           const ListTile(
            leading: Icon(Icons.privacy_tip),
            title: Text("Privacy Policy"),
            subtitle: Text("How we handle your data"),
          ),
           const ListTile(
            leading: Icon(Icons.note),
            title: Text("Terms of use"),
            subtitle: Text("App use terms and conditions"),
          ),
        ],
      ),
    );
  }
}


