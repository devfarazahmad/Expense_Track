
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:track_expense/ViewModel/transaction_viewmodel.dart';
// import 'package:track_expense/views/navigation_screen.dart';


// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(
//           create: (_) => TransactionViewModel()..fetchTransactions(),
//         ),
//       ],
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'Track Expenses',
//         theme: ThemeData(
//           colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//           useMaterial3: true,
//         ),
//         home: const NavigationScreen(),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_expense/ViewModel/transaction_viewmodel.dart';
import 'package:track_expense/views/navigation_screen.dart';
import 'package:track_expense/theme/app_theme.dart'; // ✅ import theme

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TransactionViewModel()..fetchTransactions(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Track Expenses',
        theme: AppTheme.light(), // ✅ use Inter + white background
        home: const NavigationScreen(),
      ),
    );
  }
}


