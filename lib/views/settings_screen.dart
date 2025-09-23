
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:track_expense/theme/theme_provider.dart';

// class SettingsScreen extends StatelessWidget {
//   const SettingsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);

//     return Scaffold(
//       appBar: AppBar(title: const Text("Settings")),
//       body: ListView(
//         children: [
//           const ListTile(
//             leading: Icon(Icons.person),
//             title: Text("Profile"),
//             subtitle: Text("Manage your profile"),
//           ),
//           SwitchListTile(
//             secondary: const Icon(Icons.palette),
//             title: const Text("Theme"),
//             subtitle: Text(themeProvider.isDarkMode ? "Dark Mode" : "Light Mode"),
//             value: themeProvider.isDarkMode,
//             onChanged: (value) {
//               themeProvider.toggleTheme();
//             },
//           ),
//           const ListTile(
//             leading: Icon(Icons.backup),
//             title: Text("Backup"),
//             subtitle: Text("Export or Import Data"),
//           ),
//           const ListTile(
//             leading: Icon(Icons.info),
//             title: Text("About"),
//             subtitle: Text("Version 1.0.0"),
//           ),
//         ],
//       ),
//     );
//   }
// }




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
              themeProvider.toggleTheme(); // ✅ This now also saves user choice
            },
          ),
          const ListTile(
            leading: Icon(Icons.backup),
            title: Text("Backup"),
            subtitle: Text("Export or Import Data"),
          ),
          const ListTile(
            leading: Icon(Icons.info),
            title: Text("About"),
            subtitle: Text("Version 1.0.0"),
          ),
        ],
      ),
    );
  }
}


